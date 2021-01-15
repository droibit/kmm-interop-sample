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
    
    let sampleRepository: SampleRepositoryAdapter
    
    let mainScheduler: AnySchedulerOf<DispatchQueue>
    
    init() {
        coroutinesDispatcherProvider = DispatcherProvider()
        sampleRepository = SampleRepositoryAdapter(
            repository: SampleRepositoryImpl(
                backgroundDispatcher: coroutinesDispatcherProvider.computation,
                taskDataSource: TaskDataSource()
            )
        )
        mainScheduler = DispatchQueue.main.eraseToAnyScheduler()
    }
}

let dependencies = Dependencies()
