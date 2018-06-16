//
// Created by Nominalista on 05.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

struct Reply<State, Input> {

    var input: Input
    var fromState: State
    var toState: State
    var output: Observable<Input>?

    var isSuccessful: Bool { return output != nil }
}