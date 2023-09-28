//
//  NotificationService.swift
//  NotificationService
//
//  Created by Karthik Iyer on 16/09/23.
//

import UserNotifications
import CTNotificationService
import CleverTapSDK

class NotificationService: CTNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        
        let defaults = UserDefaults.init(suiteName: "group.clevertapTest")
        let emailId = defaults?.value(forKey: "userEmailID") as? String
        let userId = defaults?.value(forKey: "userIdentity")
        let userMobNo = defaults?.value(forKey: "userMobileNumber")
        print("From Notification Service EmailID: \(String(describing: emailId))")
        
        let props = [
            "emailId": emailId,
            "userId": userId,
            "userMobNo": userMobNo
        ]
        
        CleverTap.sharedInstance()?.recordEvent("NotificationServiceEventForPushImpression", withProps: props)
        
        if let emailId = emailId, let userId = userId, let userMobNo = userMobNo {
            let profile: Dictionary<String, Any> = [
                "Identity": userId,
                "Email": emailId,
                "Phone": userMobNo
            ]
            CleverTap.sharedInstance()?.onUserLogin(profile)
        }
        
        //        let profile: Dictionary<String, Any> = [
        //            "Identity": "ioskk2",
        //            "Email": "ioskk2@test.com",]
        //        CleverTap.sharedInstance()?.onUserLogin(profile)
        // call to record the Notification viewed
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData:request.content.userInfo)
        super.didReceive(request, withContentHandler: contentHandler)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
