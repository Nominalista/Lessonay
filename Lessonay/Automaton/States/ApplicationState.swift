//
// Created by Nominalista on 03.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

struct ApplicationState {

    var homeState = HomeState()
    var playbackState = PlaybackState()
}

extension ApplicationState: Equatable {

    static func ==(lhs: ApplicationState, rhs: ApplicationState) -> Bool {
        return lhs.homeState == rhs.homeState
                && lhs.playbackState == rhs.playbackState
    }
}