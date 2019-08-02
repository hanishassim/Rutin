//
//  RTExpandableCollectionCell.swift
//  Rutin
//
//  Created by H on 09/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

class RTExpandableCollectionCell: RTBaseRoundedCardCell, Expandable {
    lazy var heroImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var headerLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.init(name: Font.bold, size: 22)
        label.textAlignment = .left
        label.textColor = Color.label.primary
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeAgoLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.init(name: Font.regular, size: 16)
        label.textAlignment = .left
        label.textColor = Color.label.primary
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var initialFrame: CGRect?
    fileprivate var initialCornerRadius: CGFloat?
    
//    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> RTExpandableCollectionCell {
//        guard let cell: RTExpandableCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) else {
//            fatalError("*** Failed to dequeue WorldPremiereCell ***")
//        }
//        return cell
//    }
    
    fileprivate func makeViewConstraints() {
        contentView.addSubview(heroImageView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: heroImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: heroImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: heroImageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: heroImageView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -20),
            ])
        
        contentView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: headerLabel, attribute: .leading, relatedBy: .equal, toItem: heroImageView, attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: headerLabel, attribute: .top, relatedBy: .equal, toItem: heroImageView, attribute: .top, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: headerLabel, attribute: .centerX, relatedBy: .equal, toItem: heroImageView, attribute: .centerX, multiplier: 1, constant: 0),
            ])
        
        contentView.addSubview(timeAgoLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: timeAgoLabel, attribute: .leading, relatedBy: .equal, toItem: heroImageView, attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: timeAgoLabel, attribute: .bottom, relatedBy: .equal, toItem: heroImageView, attribute: .bottom, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: timeAgoLabel, attribute: .centerX, relatedBy: .equal, toItem: heroImageView, attribute: .centerX, multiplier: 1, constant: 0),
            ])
    }
    
    // MARK: - View Life Cycle
    
    override func setupViews() {
        makeViewConstraints()
    
        configureCell()
    }
    
    // MARK: - Configuration
    
    private func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = contentView.layer.cornerRadius
        
        heroImageView.layer.cornerRadius = 14
    }
    
    // MARK: - Showing/Hiding Logic
    
    func hide(in collectionView: UICollectionView, frameOfSelectedCell: CGRect) {
        initialFrame = self.frame
        
        let currentY = self.frame.origin.y
        let newY: CGFloat
        
        if currentY < frameOfSelectedCell.origin.y {
            let offset = frameOfSelectedCell.origin.y - currentY
            newY = collectionView.contentOffset.y - offset
        } else {
            let offset = currentY - frameOfSelectedCell.maxY
            newY = collectionView.contentOffset.y + collectionView.frame.height + offset
        }
        
        self.frame.origin.y = newY
        
        layoutIfNeeded()
    }
    
    func show() {
        self.frame = initialFrame ?? self.frame
        
        initialFrame = nil
        
        layoutIfNeeded()
    }
    
    // MARK: - Expanding/Collapsing Logic
    
    func expand(in collectionView: UICollectionView) {
        initialFrame = self.frame
        initialCornerRadius = self.contentView.layer.cornerRadius
        
        self.contentView.layer.cornerRadius = 0
        self.frame = CGRect(x: 0, y: collectionView.contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
        
        layoutIfNeeded()
    }
    
    func collapse() {
        self.contentView.layer.cornerRadius = initialCornerRadius ?? self.contentView.layer.cornerRadius
        self.frame = initialFrame ?? self.frame
        
        initialFrame = nil
        initialCornerRadius = nil
        
        layoutIfNeeded()
    }
}
