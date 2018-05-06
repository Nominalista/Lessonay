//
//  Created by Yasuhiro Inami on 2016-08-15.
//  Modified by Marcin Hatalski on 2018-04-12.
//  Copyright © 2016 Yasuhiro Inami. All rights reserved.
//

import RxCocoa
import RxSwift

class Automaton<T: Transducer> {

    typealias State = T.State
    typealias Input = T.Input

    let state: BehaviorRelay<State>

    var replies: Observable<Reply<State, Input>> {
        return replySubject.asObservable()
    }

    private var transducer: T
    // Subject is two-sided pipe for emitting and observing.
    private let inputSubject = PublishSubject<Input>()
    private let replySubject = PublishSubject<Reply<State, Input>>()
    private let disposeBag = DisposeBag()

    init(state initialState: State, transducer: T) {
        self.state = BehaviorRelay(value: initialState)
        self.transducer = transducer
        observeInputs()
    }

    deinit {
        // Stops emission of replies.
        self.replySubject.onCompleted()
    }

    // Observes `inputObservable` and binds it to state and replies.
    private func observeInputs() {
        // Maps every input sent from `inputs` to `Reply`.
        let replyObservable = recur(inputObservable: inputSubject)
                .map { [unowned self] input -> Reply<State, Input> in
                    let fromState = self.state.value
                    if let (toState, _) = self.transducer.map(state: fromState, input: input) {
                        return .success(input, fromState, toState)
                    } else {
                        return .failure(input, fromState)
                    }
                }
                // Shares events for two observers.
                .share(replay: 1, scope: .forever)

        // Changes state after every successful reply.
        replyObservable
                .flatMap { reply -> Observable<State> in
                    if let toState = reply.toState {
                        return .just(toState)
                    } else {
                        return .empty()
                    }
                }
                .bind(to: state)
                .disposed(by: disposeBag)

        // Assigns `replyObservable` to a property.
        replyObservable
                .subscribe(replySubject)
                .disposed(by: disposeBag)
    }

    // Recurs `inputObservable` for emitting inputs and additional outputs from `transducer`.
    private func recur(inputObservable: Observable<Input>) -> Observable<Input> {
        return Observable.create { [unowned self] observer in
            // Emits input, from state and output.
            let mappedObservable = inputObservable
                    .map { input -> (Input, State, Observable<Input>?) in
                        let fromState = self.state.value
                        if let (_, outputObservable) = self.transducer.map(state: fromState, input: input) {
                            return (input, fromState, outputObservable)
                        } else {
                            return (input, fromState, nil)
                        }
                    }
                    // Shares events for two observers.
                    .share(replay: 1, scope: .forever)

            // Emits input if `transducer` emitted output and uses this output for recursion.
            let successObservable = mappedObservable
                    .filter { _, _, outputObservable in outputObservable != nil }
                    // After switching to another `Observable` it unsubscribes from old,
                    // while `flatMap` would be still emitting.
                    .flatMapLatest { input, fromState, outputObservable -> Observable<Input> in
                        return self.recur(inputObservable: outputObservable!)
                                .startWith(input)
                    }
            // Emits input if `transducer didn't emit output.
            let failureObservable = mappedObservable
                    .filter { _, _, outputObservable in outputObservable == nil }
                    .map { input, fromState, _ in input }

            // `successObservable` and `failureObservable` both emit `Input`.
            let mergedObservable = Observable.of(successObservable, failureObservable).merge()
            return mergedObservable.subscribe(observer)
        }
    }

    func send(input: Input) {
        inputSubject.onNext(input)
    }
}