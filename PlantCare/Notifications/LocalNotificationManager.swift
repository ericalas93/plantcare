//
//  NotificationService.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-10-23.
//

import Foundation
import NotificationCenter
import Combine

class LocalNotificationManager: ObservableObject {
    var notifications = [Notification]()
    let notificationCenter: UNUserNotificationCenter

    init() {
        self.notificationCenter = UNUserNotificationCenter.current()
        self.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                print("Notifications permitted")
            } else {
                print("Notifications not permitted")
            }
        }
    }

    func sendNotification(id: String, title: String, subtitle: String?, body: String, dateComponents: DateComponents) {
        self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])

        let content = UNMutableNotificationContent()
        content.title = title
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        content.body = body
        content.sound = UNNotificationSound.default
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        self.notificationCenter.add(request, withCompletionHandler: nil)
    }

    func getNotifications() -> AnyPublisher<Array<UNNotificationRequest>, Never> {
        let future = Future<Array<UNNotificationRequest>, Never> { promise in
            self.notificationCenter.getPendingNotificationRequests { notifications in
                promise(.success(notifications))
            }
        }

        return future.eraseToAnyPublisher()

    }

    func getNotificationById(id: String) -> AnyPublisher<UNNotificationRequest?, Never> {
        let future = Future<UNNotificationRequest?, Never> { promise in
            self.getNotifications().subscribe(Subscribers.Sink(
                receiveCompletion: { _ in},
                receiveValue: { notifications in
                    let notification = notifications.first { notification in
                        return notification.identifier == id
                    }
                
                    promise(.success(notification))
                }
            ))
        }

        return future.eraseToAnyPublisher()
    }
    
    func deleteNotification(withId: String?) {
        if (withId != nil) {
            self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [withId!])
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [withId!])
        } else {
            self.notificationCenter.removeAllDeliveredNotifications()
            self.notificationCenter.removeAllPendingNotificationRequests()
        }
    }
}
