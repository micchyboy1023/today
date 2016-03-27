//
//  DataProvider.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/27.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit

protocol DataProvider: class {
    associatedtype Object
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object
    func numberOfSection() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    func numberOfObjects() -> Int
}

protocol DataProviderDelegate: class {
    associatedtype Object
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}

enum DataProviderUpdate<Object> {
    case Insert(NSIndexPath)
    case Update(NSIndexPath, Object)
    case Move(NSIndexPath, NSIndexPath)
    case Delete(NSIndexPath)
}