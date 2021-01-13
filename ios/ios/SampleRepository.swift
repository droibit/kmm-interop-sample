//
//  SampleRepository.swift
//  ios
//
//  Created by Shinya Kumagai on 2021/01/13.
//  Copyright © 2021 orgName. All rights reserved.
//

import Combine
import Foundation
import Shared

class SampleRepository {
    
    private let repository: Shared.SampleRepository
    
    init(repository: Shared.SampleRepository) {
        self.repository = repository
    }

    func geUUIDAsSinle() -> AnyPublisher<String, Never> {
        // No error occurs because it is a sample app.
        Future { promise in
            self.repository.getUUID { uuid, error in
                promise(.success(uuid!))
            }
        }.eraseToAnyPublisher()
    }
    
    func getUUID() -> AnyPublisher<String, Never> {
        let sink = PassthroughSubject<String, Never>()
        let closable = self.repository.getUUIDAsFlow().watch { uuid, throwable in
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
    
    func forceException() throws {
        try repository.forceException()
    }
    
    func forceSampleApiException() throws {
        try repository.forceSampleApiException()
    }
}
