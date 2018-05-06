//
// Created by Nominalista on 05.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

// Transducer
protocol Transducer {

    associatedtype State
    associatedtype Input

    func map(state: State, input: Input) -> (State, Observable<Input>)?
}