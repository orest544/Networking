//
//  UIRefreshControl+CommonRefresher.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 12/27/18.
//  Copyright © 2018 Orest Patlyka. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    static func commonRefresher(target: AnyObject, selector: Selector) -> UIRefreshControl {
        let refresher = UIRefreshControl()
        refresher.backgroundColor = UIColor(red: 34/255, green: 45/255, blue: 55/255, alpha: 1)
        refresher.tintColor = .clear
        refresher.addTarget(target, action: selector, for: .valueChanged)
        return refresher
    }
}
