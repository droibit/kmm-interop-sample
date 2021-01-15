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
    
    private let sampleRepository: SampleRepositoryAdapter
    
    private let mainScheduler: AnySchedulerOf<DispatchQueue>
    
    @Published var oneshotUUID: String = "-"
    
    @Published var streamedUUID: String = "-"
    
    @Published var isWatchingUUID: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var cancellableForStream: AnyCancellable? = nil
    
    private var initialized: Bool = false
    
    private let getUUIDEventSink: PassthroughSubject<Void, Never>
        
    init(sampleRepository: SampleRepositoryAdapter,
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
        defer { isWatchingUUID = cancellableForStream != nil }
        
        if let cancellable = cancellableForStream {
            cancellable.cancel()
            cancellableForStream = nil
            return
        }
        
        cancellableForStream = sampleRepository.getUUID()
            .receive(on: mainScheduler)
            .assign(to: \.streamedUUID, on: self)
    }
    
    func printCrashMethod() {
        do {
            try sampleRepository.forceException()
        } catch {
            print("Catch Exception: \(error.localizedDescription)@\(type(of: error))")
            
            if let realError = error.kotlinThrowable {
                print("Error type: \(type(of: realError))")
            }
        }
        
        do {
            try sampleRepository.forceSampleApiException()
        } catch {
            print("Catch Exception: \(error.localizedDescription)")
            
            if let error = error.kotlinThrowable as? SampleApiException {
                switch error {
                case let realError as SampleApiException.Network:
                    print("Error type: \(type(of: realError))")
                case let realError as SampleApiException.Unauthorized:
                    print("Error type: \(type(of: realError))")
                default:
                    break
                }
            }
        }
    }
}
