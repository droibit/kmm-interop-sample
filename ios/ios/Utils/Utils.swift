//
//  Utils.swift
//  ios
//
//  Created by Shinya Kumagai on 2021/01/10.
//  Copyright © 2021 orgName. All rights reserved.
//

import Foundation

func currentQueueName() -> String {
    // ref. https://stackoverflow.com/questions/39553171/how-to-get-the-current-queue-name-in-swift-3/39809760
    if let name = String(cString: __dispatch_queue_get_label(nil), encoding: .utf8) {
        return name
    }
    return "unknown"
}
