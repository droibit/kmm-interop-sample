//
//  Dependencies.swift
//  ios
//
//  Created by Shinya Kumagai on 2021/01/07.
//  Copyright © 2021 orgName. All rights reserved.
//

import Foundation
import Shared

class Dependencies {
    let dispatcherProvider: DispatcherProvider
    
    let sampleRepository: SampleRepository
    
    init() {
        dispatcherProvider = DispatcherProvider()
        sampleRepository = SampleRepositoryImpl(backgroundDispatcher: dispatcherProvider.computation)
    }
}

let dependencies = Dependencies()
