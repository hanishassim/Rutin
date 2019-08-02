//
//  RTFeedListVC.swift
//  Rutin
//
//  Created by H on 09/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

enum FeedStyle {
    case appStore, regularList
}

class RTFeedListVC: UIViewController {
    fileprivate lazy var collectionViewFlowLayout: RTCollectionViewFlowLayout = {
        let layout = RTCollectionViewFlowLayout(display: .grid)
        layout.minimumInteritemSpacing = 60
        return layout
    }()
    
    fileprivate lazy var collectionView: RTDynamicCollectionView! = {
        let cv = RTDynamicCollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = true
        cv.isPagingEnabled = false
        cv.decelerationRate = UIScrollView.DecelerationRate.normal
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    fileprivate lazy var tableView: UITableView! = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 50
        table.rowHeight = UITableView.automaticDimension
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    fileprivate let feedCellId = "feedCell"
    fileprivate var hiddenCells: [RTExpandableCollectionCell] = []
    fileprivate var expandedCell: RTExpandableCollectionCell?
    fileprivate var isStatusBarHidden = false
    fileprivate var feedStyle: FeedStyle
    var dataSource = RTGenericDataSource<AmanzModel>()
    

    // MARK: Lifecycle
    
    init(feedStyle: FeedStyle) {
        self.feedStyle = feedStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initCollectionView() {
        collectionView.register(RTExpandableCollectionCell.self, forCellWithReuseIdentifier: feedCellId)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        makeViewConstraints()
    }
    
    fileprivate func initTableView() {
        
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.data.addAndNotify(observer: self) { [weak self] in
            self?.collectionView.reloadData()
            self?.collectionView.layoutIfNeeded()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if feedStyle == .appStore {
            initCollectionView()
        } else {
            initTableView()
        }
    }
    
    // MARK: Layout
    
    fileprivate func makeViewConstraints() {
        if feedStyle == .appStore {
            view.addSubview(collectionView)
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: collectionView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0),
                NSLayoutConstraint( item: collectionView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: collectionView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: collectionView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
                ])
        } else {
            view.addSubview(tableView)
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0),
                NSLayoutConstraint( item: tableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
                ])
        }
    }
    
    // MARK: User Interaction
    
    fileprivate func foobarButtonTapped() {
        // ...
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension RTFeedListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: collectionView.bounds.width - 40, height: RTBaseRoundedCardCell.cellHeight)
        } else {
            
            // Number of Items per Row
            let numberOfItemsInRow = 2
            
            // Current Row Number
            let rowNumber = indexPath.item/numberOfItemsInRow
            
            // Compressed With
            let compressedWidth = collectionView.bounds.width/3
            
            // Expanded Width
            let expandedWidth = (collectionView.bounds.width/3) * 2
            
            // Is Even Row
            let isEvenRow = rowNumber % 2 == 0
            
            // Is First Item in Row
            let isFirstItem = indexPath.item % numberOfItemsInRow != 0
            
            // Calculate Width
            var width: CGFloat = 0.0
            if isEvenRow {
                width = isFirstItem ? compressedWidth : expandedWidth
            } else {
                width = isFirstItem ? expandedWidth : compressedWidth
            }
            
            return CGSize(width: width, height: RTBaseRoundedCardCell.cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

// MARK: UICollectionViewDataSource

extension RTFeedListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        
        switch item {
        case 0...dataSource.data.value.count - 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as? RTExpandableCollectionCell else {
                return UICollectionViewCell()
            }
            
            // cell.heroImageView.image = UIImage.init(named: dataSource.data.value[item].)
            cell.headerLabel.text = dataSource.data.value[item].title
            cell.timeAgoLabel.text = dataSource.data.value[item].publishedTime.description
            
            cell.headerLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.systemFont(ofSize: UIFont.labelFontSize * 1.4, weight: UIFont.Weight.black))
            cell.timeAgoLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: UIFont.Weight.semibold))
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: UICollectionViewDelegate

extension RTFeedListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.contentOffset.y < 0 ||
            collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.frame.height {
            return
        }
        
        let dampingRatio: CGFloat = 0.8
        let initialVelocity: CGVector = CGVector.zero
        let springParameters: UISpringTimingParameters = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: initialVelocity)
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: springParameters)
        
        
        view.isUserInteractionEnabled = false
        
        if let selectedCell = expandedCell {
            isStatusBarHidden = false
            
            animator.addAnimations {
                selectedCell.collapse()
                
                for cell in self.hiddenCells {
                    cell.show()
                }
            }
            
            animator.addCompletion { _ in
                collectionView.isScrollEnabled = true
                
                self.expandedCell = nil
                self.hiddenCells.removeAll()
            }
        } else {
            isStatusBarHidden = true
            
            collectionView.isScrollEnabled = false
            
            let selectedCell = collectionView.cellForItem(at: indexPath)! as! RTExpandableCollectionCell
            let frameOfSelectedCell = selectedCell.frame
            
            expandedCell = selectedCell
            hiddenCells = collectionView.visibleCells.map { $0 as! RTExpandableCollectionCell }.filter { $0 != selectedCell }
            
            animator.addAnimations {
                selectedCell.expand(in: collectionView)
                
                for cell in self.hiddenCells {
                    cell.hide(in: collectionView, frameOfSelectedCell: frameOfSelectedCell)
                }
            }
        }
        
        
        animator.addAnimations {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        animator.addCompletion { _ in
            self.view.isUserInteractionEnabled = true
        }
        
        animator.startAnimation()
    }
}

// MARK: UITableViewDataSource

extension RTFeedListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.data.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate

extension RTFeedListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
