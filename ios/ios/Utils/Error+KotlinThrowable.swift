//
//  Error+KotlinThrowable.swift
//  ios
//
//  Created by Shinya Kumagai on 2021/01/13.
//  Copyright © 2021 orgName. All rights reserved.
//

import Shared

extension Error {
    var kotlinThrowable: KotlinThrowable? {
        (self as NSError).kotlinException as? KotlinThrowable
    }
}
