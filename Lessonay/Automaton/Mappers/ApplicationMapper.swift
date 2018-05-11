//
// Created by Nominalista on 06.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

struct ApplicationMapper {

    private let homeMapper = HomeMapper()
    private let playbackMapper = PlaybackMapper()

    func map(state: ApplicationState, input: Input) -> (ApplicationState, Observable<Input>?) {
        let (homeState, homeOutput) = homeMapper.map(state: state.homeState, input: input)
        let (playbackState, playbackOutput) = playbackMapper.map(state: state.playbackState, input: input)
        let newState = ApplicationState(homeState: homeState, playbackState: playbackState)
        let output = combine(outputs: homeOutput, playbackOutput)
        return (newState, output)
    }

    private func combine(outputs: Observable<Input>? ...) -> Observable<Input>? {
        let filteredOutputs = outputs.filter { $0 != nil }.map { $0! }
        return filteredOutputs.isEmpty ? nil : Observable.merge(filteredOutputs)
    }
}