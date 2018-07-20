//
// Created by Nominalista on 08.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

struct PlaybackMapper {

    typealias PlaybackMapperResult = (PlaybackState, Observable<ApplicationInput>?)

    func map(state: PlaybackState, input: PlaybackInput) -> PlaybackMapperResult {
        switch input {
        case let input as SetIsPlayingInput:
            return setIsPlaying(state: state, input: input)
        case let input as SetLessonInput:
            return setLesson(state: state, input: input)
        default:
            return (state, nil)
        }
    }

    private func setIsPlaying(state: PlaybackState, input: SetIsPlayingInput) -> PlaybackMapperResult {
        return (PlaybackState(isPlaying: input.isPlaying, lesson: state.lesson), .empty())
    }

    private func setLesson(state: PlaybackState, input: SetLessonInput) -> PlaybackMapperResult {
        return (PlaybackState(isPlaying: state.isPlaying, lesson: input.lesson), .empty())
    }
}