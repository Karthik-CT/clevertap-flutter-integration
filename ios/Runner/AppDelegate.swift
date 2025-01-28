import UIKit
import Flutter
import UserNotifications
import CleverTapSDK
import clevertap_plugin

@main
@objc class AppDelegate: FlutterAppDelegate, CleverTapURLDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

      
    //clever tap
    CleverTap.autoIntegrate()
    registerForPush()
    CleverTapPlugin.sharedInstance()?.applicationDidLaunch(options: launchOptions)
    CleverTap.sharedInstance()?.setUrlDelegate(self)
    CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)

       

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // CleverTapURLDelegate method
    @objc(shouldHandleCleverTapURL:forChannel:) public func shouldHandleCleverTap(_ url: URL?, for channel: CleverTapChannel) -> Bool {
       print("Handling URL: \(url!) for channel: \(channel)")
       return true
   }
    
    func registerForPush() {
        // Register for Push notifications
        UNUserNotificationCenter.current().delegate = self
        // request Permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: {granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })}
    
        
        override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            
            NSLog("%@: did receive notification response: %@", self.description, response.notification.request.content.userInfo)
            CleverTap.sharedInstance()?.recordNotificationClickedEvent(withData: response.notification.request.content.userInfo)
            var channel: FlutterMethodChannel?
               if let controller = self.window?.rootViewController as? FlutterViewController {
                 channel = FlutterMethodChannel(name: "cleverTapChannel", binaryMessenger: controller.binaryMessenger)
                 channel?.invokeMethod("pushClickedResponse", arguments: response.notification.request.content.userInfo)
               }
            completionHandler()
        }
        
        
        override func application(_ application: UIApplication,
                         didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            NSLog("%@: did receive remote notification completionhandler: %@", self.description, userInfo)
            completionHandler(UIBackgroundFetchResult.noData)
        }
        
    
        
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            NSLog("%@: will present notification: %@", self.description, notification.request.content.userInfo)
            CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: notification.request.content.userInfo)
            completionHandler([.badge, .sound, .alert])
        }


}
