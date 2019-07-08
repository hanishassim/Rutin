//
//  RTMainMenuVC.swift
//  Rutin
//
//  Created by H on 22/04/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit
import Pastel
import FeedKit

class RTMainMenuVC: UIViewController {
    fileprivate lazy var pastelView: PastelView! = {
        let pastelView = PastelView(frame: view.bounds)
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        return pastelView
    }()
    
    fileprivate lazy var tableView: UITableView! = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 50
        table.rowHeight = UITableView.automaticDimension
        table.delaysContentTouches = false
        table.backgroundColor = .clear
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    fileprivate let headerLabelCellId = "headerLabelCell"
    fileprivate let menuCellId = "menuCell"

    // MARK: Lifecycle
    
    fileprivate func initTableView() {
        tableView.register(RTHeaderLabelCell.self, forCellReuseIdentifier: headerLabelCellId)
        tableView.register(RTMenuCell.self, forCellReuseIdentifier: menuCellId)
        makeViewConstraints()
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        initTableView()
    }
    
    // MARK: Layout
    
    fileprivate func makeViewConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0),
            NSLayoutConstraint( item: tableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal, toItem: view.superview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: -64),
            NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
            ])
    }
    
    // MARK: User Interaction
    
    fileprivate func foobarButtonTapped() {
        // ...
    }
    
    @objc fileprivate func dismissButtonTapped() {
        dismiss(animated: true) {
            self.pastelView.startAnimation()
        }
    }
}

// MARK: UITableViewDataSource

extension RTMainMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch row {
        case 0, 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: headerLabelCellId, for: indexPath) as? RTHeaderLabelCell else {
                return UITableViewCell()
            }
            cell.headerLabel.textColor = Color.white
            cell.headerLabel.adjustsFontForContentSizeCategory = true
            cell.backgroundColor = .clear
            
            switch row {
            case 0:
                cell.headerLabel.text = "Welcome!"
                 cell.headerLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.systemFont(ofSize: UIFont.labelFontSize * 2, weight: UIFont.Weight.black))
                cell.headerLabelTopConstraint.constant = UIScreen.main.bounds.height / 3.9
            default:
                cell.headerLabel.text = "Choose to begin"
                cell.headerLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont.systemFont(ofSize: UIFont.labelFontSize * 2, weight: UIFont.Weight.regular))
                cell.headerLabelTopConstraint.constant = 16
            }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: menuCellId, for: indexPath) as? RTMenuCell else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            cell.backgroundColor = .clear
            
            cell.dataSource.data.value = [
                ["App": "Amanz blog",
                 "image_name": "amanz_icon",
                 "feed_url": "https://amanz.my/feed/"],
                ["App": "Awani news blog",
                 "image_name": "awani_icon",
                 "feed_url": "https://www.astroawani.com/rss/latest/public"],
                ["App": "Workout logger",
                 "image_name": "workout_icon"],
                ["App": "Habit tracker",
                 "image_name": "habit_icon"],
                ["App": "Ingredient book",
                 "image_name": "food_icon"],
                ["App": "Rent Management System",
                 "image_name": "rent_icon"]
            ]
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: UITableViewDelegate

extension RTMainMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension RTMainMenuVC: RTMenuCellDelegate {
    func navigate(appData: [String: String]) {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.title = appData["App"]
        
        let dismissButton = UIBarButtonItem(image: UIImage(named: "close__button_icon"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        vc.navigationItem.leftBarButtonItem  = dismissButton
        vc.navigationItem.leftBarButtonItem?.tintColor = Color.primary
        
        guard let urlString = appData["feed_url"], let feedURL = URL(string: urlString) else {
            return
        }
        
        print(feedURL)
        
        let parser = FeedParser(URL: feedURL)
        
        // Parse asynchronously, not to block the UI.
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            DispatchQueue.main.async {
                // ..and update the UI
                guard let feed = result.rssFeed, result.isSuccess, let title = feed.title, let description = feed.description else {
                    print(result.error)
                    return
                }
                print(feed)
                print(title)
                print(description)
                
                let item = feed.items?.first
                
                print(item?.title)
                print(item?.link)
                print(item?.description)
                print(item?.guid?.value)
                print(item?.pubDate)
            }
        }
        
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
    }
}
