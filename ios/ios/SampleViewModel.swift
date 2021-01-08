//
//  SampleViewModel.swift
//  ios
//
//  Created by Shinya Kumagai on 2021/01/07.
//  Copyright © 2021 orgName. All rights reserved.
//

import Combine
import CombineSchedulers
import Foundation
import Shared

class SampleViewModel: ObservableObject {
    
    private let sampleRepository: SampleRepository
    
    private let mainScheduler: AnySchedulerOf<DispatchQueue>
    
    @Published var oneshotUUID: String = "-"
    
    @Published var streamedUUID: String = "-"
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var cancellableForStream: AnyCancellable? = nil
    
    private var initialized: Bool = false
    
    private var getUUIDEventSink: PassthroughSubject<Void, Never>
    
    var isWatchingUUID: Bool {
        cancellableForStream != nil
    }
        
    init(sampleRepository: SampleRepository,
         mainScheduler: AnySchedulerOf<DispatchQueue>,
         getUUIDEventSink: PassthroughSubject<Void, Never> = .init()) {
        self.sampleRepository = sampleRepository
        self.mainScheduler = mainScheduler
        self.getUUIDEventSink = getUUIDEventSink
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
        
        getUUIDEventSink
            .flatMap { [unowned self] _ in
                self.sampleRepository.geUUIDAsSinle()
            }
            .receive(on: mainScheduler)
            .assign(to: \.oneshotUUID, on: self)
            .store(in: &cancellables)

        
        initialized = true
    }
    
    func getUUID() {
        getUUIDEventSink.send(())
    }
    
    func toggleWatchingUUID() {
        if let cancellable = cancellableForStream {
            cancellable.cancel()
            cancellableForStream = nil
            return
        }
        
        cancellableForStream = sampleRepository.getUUID()
            .receive(on: mainScheduler)
            .assign(to: \.streamedUUID, on: self)
    }
}

// MARK: -

extension SampleRepository {
    func geUUIDAsSinle() -> AnyPublisher<String, Never> {
        // No error occurs because it is a sample app.
        Future { promise in
            self.getUUID { uuid, error in
                promise(.success(uuid!))
            }
        }.eraseToAnyPublisher()
    }
    
    func getUUID() -> AnyPublisher<String, Never> {
        let sink = PassthroughSubject<String, Never>()
        let closable = self.getUUIDAsFlow().watch { uuid, throwable in
            if let throwable = throwable {
                print("error: \(throwable)")
                return
            }
            sink.send(String(uuid!))
        }
        
        return sink.handleEvents(receiveCancel: {
            closable.close()
        }).eraseToAnyPublisher()
    }
}
