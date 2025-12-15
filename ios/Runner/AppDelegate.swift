import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Background Task Management for SQLite Lock Prevention (0xdead10cc)

  override func applicationWillResignActive(_ application: UIApplication) {
    // Called when the app is about to move from active to inactive state
    // Start background task to allow time for SQLite operations to complete
    beginBackgroundTask()
    super.applicationWillResignActive(application)
  }

  override func applicationDidEnterBackground(_ application: UIApplication) {
    // Called when the app enters background
    // Ensure any pending database operations complete before suspension
    super.applicationDidEnterBackground(application)
  }

  override func applicationWillEnterForeground(_ application: UIApplication) {
    // Called when the app is about to enter foreground
    // End background task if still running
    endBackgroundTask()
    super.applicationWillEnterForeground(application)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    // Called when the app becomes active again
    endBackgroundTask()
    super.applicationDidBecomeActive(application)
  }

  override func applicationWillTerminate(_ application: UIApplication) {
    // Called when the app is about to terminate
    endBackgroundTask()
    super.applicationWillTerminate(application)
  }

  // MARK: - Background Task Helpers

  private func beginBackgroundTask() {
    guard backgroundTaskID == .invalid else { return }

    backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "SQLiteLockRelease") { [weak self] in
      // Expiration handler - called if time runs out
      self?.endBackgroundTask()
    }
  }

  private func endBackgroundTask() {
    guard backgroundTaskID != .invalid else { return }

    UIApplication.shared.endBackgroundTask(backgroundTaskID)
    backgroundTaskID = .invalid
  }
}
