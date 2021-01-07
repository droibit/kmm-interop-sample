//
//  SampleViewModel.swift
//  ios
//
//  Created by Shinya Kumagai on 2021/01/07.
//  Copyright © 2021 orgName. All rights reserved.
//

import Combine
import Foundation
import Shared

class SampleViewModel: ObservableObject {
    
    private let sampleRepository: SampleRepository
    
    init(sampleRepository: SampleRepository) {
        self.sampleRepository = sampleRepository
    }

    convenience init() {
        self.init(sampleRepository: dependencies.sampleRepository)
    }
}
