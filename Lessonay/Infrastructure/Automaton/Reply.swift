//
// Created by Nominalista on 05.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

enum Reply<State, Input> {

    // (input, fromState, toState)
    case success(Input, State, State)
    // (input, fromState)
    case failure(Input, State)

    var input: Input {
        switch self {
        case let .success(input, _, _):
            return input
        case let .failure(input, _):
            return input
        }
    }

    var fromState: State {
        switch self {
        case let .success(_, fromState, _):
            return fromState
        case let .failure(_, fromState):
            return fromState
        }
    }

    var toState: State? {
        switch self {
        case let .success(_, _, toState):
            return toState
        case .failure:
            return nil
        }
    }
}