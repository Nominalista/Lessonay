//
// Created by Nominalista on 08.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

struct PlaybackState {

    var isPlaying = false
    var lesson: Lesson?
}

extension PlaybackState: Equatable {

    static func ==(lhs: PlaybackState, rhs: PlaybackState) -> Bool {
        return lhs.isPlaying == rhs.isPlaying
                && lhs.lesson == rhs.lesson
    }
}