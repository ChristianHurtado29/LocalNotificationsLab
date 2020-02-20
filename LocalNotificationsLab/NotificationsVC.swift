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
    
    private var notifications = [""]
    
    private let pendingNotification = PendingNotification()
    
    private var refreshControl: UIRefreshControl!
    
    private let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

