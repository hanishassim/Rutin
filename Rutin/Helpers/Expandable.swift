//
//  Expandable.swift
//  Rutin
//
//  Created by H on 09/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

protocol Expandable {
    func collapse()
    func expand(in collectionView: UICollectionView)
}
