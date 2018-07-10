//
// Created by Nominalista on 06.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

struct ApplicationMapper {

    private let homeMapper = HomeMapper()
    private let playbackMapper = PlaybackMapper()

    func map(state: ApplicationState, input: ApplicationInput) -> (ApplicationState, Observable<ApplicationInput>?) {
        let (homeState, homeOutput) = homeMapper.map(state: state.homeState, input: input)
        let (playbackState, playbackOutput) = playbackMapper.map(state: state.playbackState, input: input)
        let newState = ApplicationState(homeState: homeState, playbackState: playbackState)
        let output = maybeCombine(outputs: homeOutput, playbackOutput)
        return (newState, output)
    }
}