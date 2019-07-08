//
//  RTMenuCell.swift
//  Rutin
//
//  Created by H on 08/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit
import Foundation

protocol RTMenuCellDelegate: class {
    func navigate(appData: [String: String])
}

class RTMenuCell: RTTableBaseCell {
    fileprivate lazy var collectionViewFlowLayout: RTCollectionViewFlowLayout = {
        let layout = RTCollectionViewFlowLayout(display: .grid)
        return layout
    }()

    lazy var collectionView: RTDynamicCollectionView! = {
        let cv = RTDynamicCollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.isPagingEnabled = false
        cv.scrollsToTop = false
        cv.decelerationRate = UIScrollView.DecelerationRate.fast
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    fileprivate let menuCollectionCellId = "menuCollectionCell"
    var dataSource = RTGenericDataSource<[String: String]>()
    weak var delegate: RTMenuCellDelegate?
    
    fileprivate func makeViewConstraints() {
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: collectionView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            ])
    }
    
    override func setupCell() {
        collectionView.register(RTMenuCollectionCell.self, forCellWithReuseIdentifier: menuCollectionCellId)
        
        makeViewConstraints()
        
        collectionView.contentInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        
        dataSource.data.addAndNotify(observer: self) { [weak self] in
            self?.collectionView.reloadData()
            self?.collectionView.layoutIfNeeded()
        }

        selectionStyle = .none
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension RTMenuCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.width / 3)
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

extension RTMenuCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCollectionCellId, for: indexPath) as? RTMenuCollectionCell, let imageName = dataSource.data.value[item]["image_name"] else {
            return UICollectionViewCell()
        }
        
        cell.iconImageView.image = UIImage(named: imageName)

        return cell
    }
}

// MARK: UICollectionViewDelegate

extension RTMenuCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        
        print(dataSource.data.value[item]["App"]!)
        
//        guard let app = dataSource.data.value[item]["App"] else {
//            return
//        }
        
        delegate?.navigate(appData: dataSource.data.value[item])
    }
}
