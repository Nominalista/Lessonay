//
// Created by Nominalista on 02.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class HomeViewController: UIViewController {

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Play", for: .normal)
        return button
    }()

    private let automaton: Automaton<AppTransducer>
    private let disposeBag = DisposeBag()

    init(automaton: Automaton<AppTransducer>) {
        self.automaton = automaton
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColor()
        setupPlayButton()
        observeState()
        requestLesson()
    }

    private func setupBackgroundColor() {
        view.backgroundColor = .white
    }

    private func setupPlayButton() {
        view.addSubview(playButton)
        playButton.anchorCenterToSuperview()
        playButton.rx
                .tap
                .bind { print("Test") }
                .disposed(by: disposeBag)
    }

    private func observeState() {
        automaton.state
                .bind { [weak self] state in
                    if state.lesson == nil {
                        self?.playButton.isHidden = true
                    } else {
                        self?.playButton.isHidden = false
                    }
                }
                .disposed(by: disposeBag)
    }

    private func requestLesson() {
        automaton.send(input: .retrieveLessonRequested)
    }
}
