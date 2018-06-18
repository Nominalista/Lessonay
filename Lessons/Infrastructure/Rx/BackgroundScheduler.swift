//
// Created by Nominalista on 18.06.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

class BackgroundScheduler {

    static let instance = ConcurrentDispatchQueueScheduler(qos: .background)
}