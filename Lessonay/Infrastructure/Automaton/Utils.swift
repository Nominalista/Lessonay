//
// Created by Nominalista on 11.06.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

func maybeCombine<Input>(outputs: Observable<Input>? ...) -> Observable<Input>? {
    let filteredOutputs = outputs.filter { $0 != nil }.map { $0! }
    return filteredOutputs.isEmpty ? nil : Observable.merge(filteredOutputs)
}