//
//  Dependencies.swift
//  ios
//
//  Created by Shinya Kumagai on 2021/01/07.
//  Copyright © 2021 orgName. All rights reserved.
//

import Combine
import Foundation
import Shared
import CombineSchedulers

class Dependencies {
    private let coroutinesDispatcherProvider: DispatcherProvider
    
    let sampleRepository: SampleRepository
    
    let mainScheduler: AnySchedulerOf<DispatchQueue>
    
    init() {
        coroutinesDispatcherProvider = DispatcherProvider()
        sampleRepository = SampleRepository(
            repository: SampleRepositoryImpl(backgroundDispatcher: coroutinesDispatcherProvider.computation)
        )
        mainScheduler = DispatchQueue.main.eraseToAnyScheduler()
    }
}

let dependencies = Dependencies()
