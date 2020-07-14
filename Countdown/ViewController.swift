//
//  ViewController.swift
//  Countdown
//
//  Created by Pursuit on 7/13/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main // one section for tableview
    }
    
    private var tableView: UITableView!
    
    // define the UITableViewDiffereableDataSource instance 
    private var dataSource : UITableViewDiffableDataSource<Section, Int>!
    
    private var timer: Timer!
    
    private var startInterval = 10 // seconds

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureTableView()
        
            configureDataSource()
    configureNavBar()
        
    }
    
    private func configureNavBar(){
        navigationItem.title = "countdown "
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startCountdown))
    }
    
    private func configureTableView(){
        // can also do this in storyboard
        
        // setting tableview to take up everything
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .systemPink
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
    }
    
    private func configureDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, Int>(tableView: tableView, cellProvider: { (tableView, indexPath, value ) ->
            UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            if value == -1 {
                cell.textLabel?.text = "🚀 it looks good so far, look at crashlytics "
                cell.textLabel?.numberOfLines = 0
            } else {
                    cell.textLabel?.text = "\(value)"

                }

            
            return cell
        })
        
        // set up type of animation for the datasource
        dataSource.defaultRowAnimation = .fade
        
        /*
        // MARK: this is for demonstrating purposes
        // setup snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        // add sections
        snapshot.appendSections([.main])
        snapshot.appendItems([1,2,3,4,5,6,7,8,9,10]) // this is to test results
        
        dataSource.apply(snapshot, animatingDifferences: true)
 */
        startCountdown()
    }
    
   @objc private func startCountdown(){
        if timer != nil {
            timer.invalidate() // says the timer is done
        }
        // configure the timer
        // set interval for countdown
        // assign a method that gets called every seconf
        
        timer = Timer.scheduledTimer(timeInterval: 1.0 , target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
        
        // reset our starting interval if its done
        startInterval = 10 // seconds
        
        // setup snapshot again
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems([startInterval]) // starts at 10
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
   @objc private func decrementCounter(){
        // get access to snapshot in order to manipulate the data
    // snapshot is the source for the data
    var snapshot = dataSource.snapshot()
    guard startInterval > 0 else {
        timer.invalidate()
        ship()
        return
    }
    
    startInterval -= 1 // 10, 9 , 8 ... 0
    snapshot.appendItems([startInterval]) // 9 is inserted into the tableview
    // not removing only appending
    dataSource.apply(snapshot, animatingDifferences: true)
    
    }
    
    private func ship(){
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([-1])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
}

