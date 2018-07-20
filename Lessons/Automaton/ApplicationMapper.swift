//
// Created by Nominalista on 06.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

struct ApplicationMapper {

    typealias ApplicationMapperResult = (ApplicationState, Observable<ApplicationInput>?)

    private let homeMapper = HomeMapper()
    private let playbackMapper = PlaybackMapper()

    func map(state: ApplicationState, input: ApplicationInput) -> ApplicationMapperResult {
        switch (input) {
        case let input as HomeInput:
            return map(state: state, input: input)
        case let input as PlaybackInput:
            return map(state: state, input: input)
        default:
            return (state, nil)
        }
    }

    private func map(state: ApplicationState, input: HomeInput) -> ApplicationMapperResult {
        let (homeState, homeOutput) = homeMapper.map(state: state.homeState, input: input)
        return (ApplicationState(homeState: homeState, playbackState: state.playbackState), homeOutput)
    }

    private func map(state: ApplicationState, input: PlaybackInput) -> ApplicationMapperResult {
        let (playbackState, playbackOutput) = playbackMapper.map(state: state.playbackState, input: input)
        return (ApplicationState(homeState: state.homeState, playbackState: playbackState), playbackOutput)
    }
}