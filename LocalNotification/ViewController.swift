//
//  ViewController.swift
//  LocalNotification
//
//  Created by Hadir on 22/04/2024.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let userNotificationCenter = UNUserNotificationCenter.current()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNotificationCenter.delegate = self
        self.requestNotificationAuthorization()
    }
    
    @IBAction func intervalTapped(_ sender: UIButton) {
        sendIntervalNotification(true)
    }
    
    
    @IBAction func calendarTapped(_ sender: UIButton) {
        sendIntervalNotification(false)
    }
    
    func requestNotificationAuthorization() {
        
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendIntervalNotification(_ interval: Bool) {
        
        let notificationContent = UNMutableNotificationContent()
        if interval {
            notificationContent.title = "Timer"
            notificationContent.body = "This is interval notification"
        }else{
            notificationContent.title = "Reminder"
            notificationContent.body = "This is calendar notification"
        }
        notificationContent.badge = NSNumber(value: 1)

        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current


        dateComponents.weekday = 2
        dateComponents.hour = 14
        dateComponents.minute = 6
        
        let trigger = (interval ? UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                                   repeats: false) : UNCalendarNotificationTrigger(
                                                                    dateMatching: dateComponents, repeats: true))
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "NewViewController") as? NewViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
                
                completionHandler()
            }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
}


