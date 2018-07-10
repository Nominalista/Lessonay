//
// Created by Nominalista on 10.07.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

struct SetIsPlayingInput: ApplicationInput {
    let isPlaying: Bool
}

struct SetLessonInput: ApplicationInput {
    let lesson: Lesson?
}