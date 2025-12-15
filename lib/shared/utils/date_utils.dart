import 'package:intl/intl.dart';

/// 날짜 유틸리티
class AppDateUtils {
  AppDateUtils._();

  /// 상대적 날짜 표시 (오늘, 어제, N일 전, 날짜)
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = today.difference(target).inDays;

    if (difference == 0) {
      return '오늘';
    } else if (difference == 1) {
      return '어제';
    } else if (difference < 7) {
      return '$difference일 전';
    } else if (difference < 30) {
      return '${(difference / 7).floor()}주 전';
    } else if (date.year == now.year) {
      return DateFormat('M월 d일').format(date);
    } else {
      return DateFormat('yyyy.M.d').format(date);
    }
  }

  /// 전체 날짜 포맷
  static String formatFull(DateTime date) {
    return DateFormat('yyyy년 M월 d일').format(date);
  }

  /// 짧은 날짜 포맷
  static String formatShort(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year) {
      return DateFormat('M/d').format(date);
    }
    return DateFormat('yy/M/d').format(date);
  }

  /// 시간 포함 포맷
  static String formatWithTime(DateTime date) {
    return DateFormat('yyyy.M.d HH:mm').format(date);
  }

  /// 요일 포함 포맷
  static String formatWithWeekday(DateTime date) {
    return DateFormat('M월 d일 (E)', 'ko').format(date);
  }

  /// 경과 일수 계산
  static int daysSince(DateTime date) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;
  }

  /// 두 날짜 사이의 일수
  static int daysBetween(DateTime from, DateTime to) {
    return DateTime(to.year, to.month, to.day)
        .difference(DateTime(from.year, from.month, from.day))
        .inDays;
  }
}
