import UIKit
import Flutter
import CleverTapSDK
import clevertap_plugin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CleverTapPushNotificationDelegate {
    
    var flutterViewController: FlutterViewController!;
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
//        GeneratedPluginRegistrant.register(with: self)
        
        flutterViewController = window?.rootViewController as? FlutterViewController
        
        CleverTap.autoIntegrate()
        
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        
        registerForPush()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
        })
    }
    
    //Background
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         didReceive response: UNNotificationResponse,
                                         withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let channel = FlutterMethodChannel(name: "notificationTapChannel", binaryMessenger:flutterViewController.binaryMessenger)
        channel.invokeMethod("iosPushNotificationClicked", arguments: response.notification.request.content.userInfo)
        
        NSLog("%@:[clevertap] did receive notification response: %@", self.description, response.notification.request.content.userInfo)
        
        CleverTap.sharedInstance()!.handleNotification(withData: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    // Foreground
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //CleverTap.sharedInstance()?.handleNotification(withData: notification.request.content.userInfo, openDeepLinksInForeground: true)
        completionHandler([.badge, .sound, .alert])
    }
    
    //Push Notification Callback
    func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        print("Push Notification Tapped with Custom Extras: \(customExtras)");
    }

    
}
