//
//  Created by Yasuhiro Inami on 2016-08-15.
//  Modified by Marcin Hatalski on 2018-04-12.
//  Copyright © 2016 Yasuhiro Inami. All rights reserved.
//

import RxCocoa
import RxSwift

class Automaton<State> {

    typealias Mapping = (State, Input) -> (State, Observable<Input>?)

    let state: BehaviorRelay<State>

    var replies: Observable<Reply<State>> {
        return replySubject.asObservable()
    }

    private var mapping: Mapping

    // Subject is two-sided pipe for emitting and observing.
    private let inputSubject = PublishSubject<Input>()
    private let replySubject = PublishSubject<Reply<State>>()
    private let disposeBag = DisposeBag()

    init(state: State, mapping: @escaping Mapping) {
        self.state = BehaviorRelay(value: state)
        self.mapping = mapping
        observeInputs()
    }

    deinit {
        // Stops emission of replies.
        self.replySubject.onCompleted()
    }

    private func observeInputs() {
        let recurredReplyObservable = recurReply(from: inputSubject)
                .share(replay: 1, scope: .forever)

        // Changes state after every reply.
        recurredReplyObservable
                .map { $0.toState }
                .bind(to: state)
                .disposed(by: disposeBag)

        // Transmits replies into other observable.
        recurredReplyObservable
                .subscribe(replySubject)
                .disposed(by: disposeBag)
    }

    // Recurs `inputObservable` to emit inputs and outputs produced from `mapping`.
    private func recurReply(from inputObservable: Observable<Input>) -> Observable<Reply<State>> {
        let replyObservable = inputObservable
                .map { [unowned self] input -> Reply<State> in
                    let fromState = self.state.value
                    let (toState, output) = self.mapping(fromState, input)
                    return Reply(input: input, fromState: fromState, toState: toState, output: output)
                }
                // Shares events for two observers.
                .share(replay: 1, scope: .forever)

        // Recurs successfully mapped replies.
        let successObservable = replyObservable
                .filter { $0.output != nil }
                // After switching to another `Observable` it unsubscribes from old,
                // while `flatMap` would be still emitting.
                .flatMapLatest { [unowned self] reply -> Observable<Reply<State>> in
                    let output = reply.output!
                    return self.recurReply(from: output)
                            .startWith(reply)
                }

        // Emits replies without output.
        let failureObservable = replyObservable
                .filter { $0.output == nil }

        // `successObservable` and `failureObservable` both emit `Reply<State>`.
        return Observable.merge(successObservable, failureObservable)
    }

    func send(input: Input) {
        inputSubject.onNext(input)
    }
}