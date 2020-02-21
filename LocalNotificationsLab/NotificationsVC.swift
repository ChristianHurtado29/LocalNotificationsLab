//
//  ViewController.swift
//  LocalNotificationsLab
//
//  Created by Christian Hurtado on 2/20/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var notifications = [UNNotificationRequest](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let pendingNotification = PendingNotification()
    
    private var refreshControl: UIRefreshControl!
    
    private let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        checkForNotificationAuthorization()
        loadNotifications()
        configurationRefreshControl()
        center.delegate = self
    }
    
    

    private func configurationRefreshControl(){
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .systemPink
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
            let creatingVC = navController.viewControllers.first as? CreatingVC else {
                fatalError("could not downcast to CreatingVC")
        }
        creatingVC.delegate = self
    }
    
    @objc private func loadNotifications() {
        pendingNotification.getPendingNotifications {
            (requests) in
            self.notifications = requests
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    private func checkForNotificationAuthorization() {
        center.getNotificationSettings {(settings) in
            if settings.authorizationStatus == .authorized {
                print("app is authorized for notifications")
            } else {
                self.requestNotificationPermissions()
            }
            
        }
    }
    
    private func requestNotificationPermissions() {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("error requesting authorization: \(error)")
                return
            }
            if granted {
                print("access was granted")
            } else {
                print("access denied")
            }
        }
    }

}

extension NotificationsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        
        cell.textLabel?.text = notification.content.title
        cell.detailTextLabel?.text = notification.content.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // we will delete the pending notification
            removeNotification(atIndexPath: indexPath)
        }
    }
    
    private func removeNotification(atIndexPath indexPath: IndexPath){
        let notification = notifications[indexPath.row]
        let identifier = notification.identifier
        // remove notification from UNNotificationCenter
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        // remove from array of notifications
        notifications.remove(at: indexPath.row)
        // remove from table view
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}

extension NotificationsVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

extension NotificationsVC: CreatingVCDelegate {
    func didCreateNotification(_ createNotificationCenter: CreatingVC) {
        loadNotifications()
    }
    
    
}
