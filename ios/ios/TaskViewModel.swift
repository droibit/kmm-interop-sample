//
//  TaskViewModel.swift
//  ios
//
//  Created by Shinya Kumagai on 2021/01/15.
//  Copyright © 2021 orgName. All rights reserved.
//

import Combine
import CombineSchedulers
import Foundation
import Shared

private let randomWords = [
    "hilarious",
    "shout",
    "shortage",
    "undermine",
    "responsible",
    "conceive",
    "viable",
    "unlike",
    "detector",
    "sleeve"
]

class TaskViewModel: ObservableObject {
    
    private let sampleRepository: SampleRepositoryAdapter
    
    private let mainScheduler: AnySchedulerOf<DispatchQueue>
    
    private let refreshTasksSink: PassthroughSubject<Void, Never>
    
    private let createTaskSink: PassthroughSubject<String, Never>
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var initialized: Bool = false
    
    @Published var tasks: [Task] = []
    
    init(sampleRepository: SampleRepositoryAdapter,
         mainScheduler: AnySchedulerOf<DispatchQueue>,
         createTaskSink: PassthroughSubject<String, Never> = .init(),
         refreshTasksSink: PassthroughSubject<Void, Never> = .init()
    ) {
        self.sampleRepository = sampleRepository
        self.mainScheduler = mainScheduler
        self.createTaskSink = createTaskSink
        self.refreshTasksSink = refreshTasksSink
    }
    
    convenience init() {
        self.init(
            sampleRepository: dependencies.sampleRepository,
            mainScheduler: dependencies.mainScheduler
        )
    }
    
    func onAppear() {
        guard !initialized else {
            return
        }
        
        createTaskSink
            .flatMap { [unowned self] title in
                self.sampleRepository.createTask(title: title)
            }
            .receive(on: mainScheduler)
            .sink(receiveValue: { [unowned self] _ in
                self.refreshTasksSink.send(())
            }).store(in: &cancellables)
                        
        refreshTasksSink
            .flatMap { [unowned self] _ in
                self.sampleRepository.getTasks()
            }
            .receive(on: mainScheduler)
            .sink(receiveValue: { [unowned self] tasks in
                self.tasks = tasks
            }).store(in: &cancellables)
            
        initialized = true
    }
    
    func createRandomTask() {
        let index = Int.random(in: 0 ..< randomWords.count)
        createTaskSink.send(randomWords[index])
    }
}
