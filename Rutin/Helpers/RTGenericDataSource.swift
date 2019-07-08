//
//  RTGenericDataSource.swift
//  Rutin
//
//  Created by H on 08/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import Foundation

class RTGenericDataSource<T>: NSObject {
    var data: RTDynamicValue<[T]> = RTDynamicValue([])
}
