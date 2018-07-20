//
// Created by Nominalista on 10.07.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

protocol PlaybackInput: ApplicationInput {}

struct SetIsPlayingInput: PlaybackInput {
    let isPlaying: Bool
}

struct SetLessonInput: PlaybackInput {
    let lesson: Lesson?
}