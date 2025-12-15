import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/app_config.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

/// 인증 서비스 (Riverpod 버전)
/// Google OAuth 로그인 및 세션 관리
class AuthService {
  final SupabaseService _supabaseService;

  /// GoogleSignIn 인스턴스 (lazy initialization)
  GoogleSignIn? _googleSignInInstance;
  GoogleSignIn get _googleSignIn {
    _googleSignInInstance ??= GoogleSignIn(
      clientId: Platform.isIOS ? AppConfig.googleIosClientId : null,
      serverClientId: AppConfig.googleWebClientId,
    );
    return _googleSignInInstance!;
  }

  /// 현재 사용자 상태 스트림
  final _currentUserController = StreamController<UserModel?>.broadcast();
  Stream<UserModel?> get currentUserStream => _currentUserController.stream;

  /// 현재 사용자 (캐시)
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  AuthService(this._supabaseService);

  /// 초기화
  Future<AuthService> init() async {
    // 기존 로그인 상태 확인 시 사용자 정보 로드
    if (isLoggedIn) {
      await _loadCurrentUser();
    }

    return this;
  }

  /// 현재 사용자 ID
  String? get currentUserId => _supabaseService.currentUserId;

  /// 로그인 상태
  bool get isLoggedIn => _supabaseService.isLoggedIn;

  /// 현재 Supabase 사용자
  User? get supabaseUser => _supabaseService.currentUser;

  /// Google 로그인
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      print('[AuthService] Google 로그인 시작');
      print('[AuthService] iOS Client ID: ${AppConfig.googleIosClientId}');
      print('[AuthService] Web Client ID: ${AppConfig.googleWebClientId}');

      // Google 로그인 시작
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('[AuthService] 사용자가 로그인 취소');
        return null;
      }

      print('[AuthService] Google 사용자 획득: ${googleUser.email}');

      // Google 인증 정보 획득
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      print('[AuthService] accessToken: ${accessToken != null ? "있음" : "없음"}');
      print('[AuthService] idToken: ${idToken != null ? "있음" : "없음"}');

      if (accessToken == null || idToken == null) {
        throw Exception(
            'Google 인증 토큰을 가져올 수 없습니다. accessToken: $accessToken, idToken: $idToken');
      }

      print('[AuthService] Supabase signInWithIdToken 호출');

      // Supabase에 로그인
      final response = await _supabaseService.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      print('[AuthService] Supabase 로그인 성공: ${response.user?.id}');

      // 사용자 프로필 저장/업데이트
      if (response.user != null) {
        await _upsertUserProfile(response.user!, googleUser);
        await _loadCurrentUser();
      }

      return response;
    } catch (e, stackTrace) {
      print('[AuthService] 로그인 에러: $e');
      print('[AuthService] 스택트레이스: $stackTrace');
      rethrow;
    }
  }

  /// Apple 로그인
  Future<AuthResponse?> signInWithApple() async {
    try {
      print('[AuthService] Apple 로그인 시작');

      // nonce 생성 (보안을 위한 랜덤 문자열)
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // Apple 로그인 요청
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      print('[AuthService] Apple 인증 정보 획득');

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw Exception('Apple ID 토큰을 가져올 수 없습니다.');
      }

      print('[AuthService] Supabase signInWithIdToken 호출 (Apple)');

      // Supabase에 로그인
      final response = await _supabaseService.client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      print('[AuthService] Supabase 로그인 성공: ${response.user?.id}');

      // 사용자 프로필 저장/업데이트
      if (response.user != null) {
        await _upsertAppleUserProfile(response.user!, credential);
        await _loadCurrentUser();
      }

      return response;
    } catch (e, stackTrace) {
      print('[AuthService] Apple 로그인 에러: $e');
      print('[AuthService] 스택트레이스: $stackTrace');
      rethrow;
    }
  }

  /// Nonce 생성 (Apple 로그인용)
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Apple 사용자 프로필 저장/업데이트
  Future<void> _upsertAppleUserProfile(
      User user, AuthorizationCredentialAppleID credential) async {
    try {
      // 기존 사용자 정보 조회 (deleted_at 포함)
      final existingUser = await _supabaseService
          .from('users')
          .select('name, deleted_at')
          .eq('id', user.id)
          .maybeSingle();

      // 탈퇴한 사용자인지 확인
      final isDeletedUser = existingUser?['deleted_at'] != null;

      // Apple은 최초 로그인 시에만 이름 제공
      String? newName;
      if (credential.givenName != null || credential.familyName != null) {
        newName =
            '${credential.familyName ?? ''}${credential.givenName ?? ''}'.trim();
      }

      // 탈퇴한 사용자면 새로 가입하는 것처럼 처리 (이름 초기화)
      // 기존 활성 사용자이고 이름이 '사용자'가 아니면 유지
      final existingName = existingUser?['name'] as String?;
      final finalName = (!isDeletedUser && existingName != null && existingName != '사용자')
          ? existingName
          : (newName?.isNotEmpty == true ? newName : '사용자');

      await _supabaseService.from('users').upsert({
        'id': user.id,
        'email': user.email ?? credential.email,
        'name': finalName,
        'deleted_at': null, // 탈퇴 상태 초기화
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // 프로필 저장 실패해도 로그인은 성공
    }
  }

  /// 사용자 프로필 저장/업데이트
  Future<void> _upsertUserProfile(
      User user, GoogleSignInAccount googleUser) async {
    try {
      // 기존 사용자 정보 조회 (deleted_at 포함)
      final existingUser = await _supabaseService
          .from('users')
          .select('name, deleted_at')
          .eq('id', user.id)
          .maybeSingle();

      // 탈퇴한 사용자인지 확인
      final isDeletedUser = existingUser?['deleted_at'] != null;

      // 탈퇴한 사용자면 새로 가입하는 것처럼 처리 (이름 초기화)
      // 기존 활성 사용자이고 이름이 '사용자'가 아니면 유지
      final existingName = existingUser?['name'] as String?;
      final finalName = (!isDeletedUser && existingName != null && existingName != '사용자')
          ? existingName
          : (googleUser.displayName ?? '사용자');

      await _supabaseService.from('users').upsert({
        'id': user.id,
        'email': user.email ?? googleUser.email,
        'name': finalName,
        'avatar_url': googleUser.photoUrl,
        'deleted_at': null, // 탈퇴 상태 초기화
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // 프로필 저장 실패해도 로그인은 성공
    }
  }

  /// 사용자 이름 업데이트
  Future<void> updateUserName(String newName) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('로그인이 필요합니다.');

      await _supabaseService.from('users').update({
        'name': newName,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      // 캐시된 사용자 정보 업데이트
      if (_currentUser != null) {
        _setCurrentUser(_currentUser!.copyWith(
          name: newName,
          updatedAt: DateTime.now(),
        ));
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 현재 사용자 정보 로드
  Future<void> _loadCurrentUser() async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        _setCurrentUser(null);
        return;
      }

      final response = await _supabaseService
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        _setCurrentUser(UserModel.fromJson(response));
      } else {
        // DB에 사용자 정보가 없으면 Supabase User에서 생성
        final supaUser = supabaseUser;
        if (supaUser != null) {
          _setCurrentUser(UserModel(
            id: supaUser.id,
            email: supaUser.email ?? '',
            name: supaUser.userMetadata?['full_name'] ?? '사용자',
            avatarUrl: supaUser.userMetadata?['avatar_url'],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ));
        }
      }
    } catch (e) {
      // 사용자 정보 로드 실패
    }
  }

  /// 현재 사용자 설정 (캐시 + 스트림)
  void _setCurrentUser(UserModel? user) {
    _currentUser = user;
    _currentUserController.add(user);
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _supabaseService.client.auth.signOut();
      _setCurrentUser(null);
    } catch (e) {
      rethrow;
    }
  }

  /// 회원 탈퇴
  Future<void> deleteAccount() async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('로그인이 필요합니다.');

      final deletedAt = DateTime.now().toIso8601String();

      // 1. prayer_requests 테이블 soft delete
      await _supabaseService.from('prayer_requests').update({
        'deleted_at': deletedAt,
      }).eq('user_id', userId);

      // 2. requesters 테이블 soft delete
      await _supabaseService.from('requesters').update({
        'deleted_at': deletedAt,
      }).eq('user_id', userId);

      // 3. users 테이블 soft delete
      await _supabaseService.from('users').update({
        'deleted_at': deletedAt,
      }).eq('id', userId);

      // Google 로그아웃
      await _googleSignIn.signOut();

      // Supabase 로그아웃
      await _supabaseService.client.auth.signOut();

      _setCurrentUser(null);
    } catch (e) {
      rethrow;
    }
  }

  /// 자동 로그인 체크 (세션 복원)
  Future<bool> checkAutoLogin() async {
    try {
      final session = _supabaseService.currentSession;
      if (session == null) return false;

      // 세션 만료 체크
      if (session.isExpired) {
        // 토큰 갱신 시도
        final response = await _supabaseService.client.auth.refreshSession();
        if (response.session != null) {
          await _loadCurrentUser();
          return true;
        }
        return false;
      }

      await _loadCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 리소스 정리
  void dispose() {
    _currentUserController.close();
  }
}
