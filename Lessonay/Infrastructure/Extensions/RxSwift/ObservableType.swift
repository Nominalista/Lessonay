//
// Created by Nominalista on 08.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxSwift

extension ObservableType where E: Equatable {

    func distinctUntilChanged() -> Observable<E> {
        return distinctUntilChanged { $0 == $1 }
    }
}