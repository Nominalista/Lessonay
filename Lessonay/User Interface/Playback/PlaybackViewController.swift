//
// Created by Nominalista on 04.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import DesignExtensions
import RxCocoa
import RxSwift
import UIKit
import VideoPlayer

private let cancelButtonSize = CGSize(width: 28, height: 28)
private let volumeButtonSize = CGSize(width: 28, height: 28)

class PlaybackViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private lazy var videoView = VideoView()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.clearBig?.asTemplate(), for: .normal)
        button.tintColor = .iconActive
        return button
    }()

    private lazy var volumeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .iconActive
        return button
    }()

    private let navigator: ApplicationNavigator
    private let automaton: Automaton<ApplicationState>
    private let videoPlaybackManager: VideoPlaybackManager
    private let disposeBag = DisposeBag()
    private var videoPlayerDisposeBag: DisposeBag?

    init(navigator: ApplicationNavigator,
         automaton: Automaton<ApplicationState>,
         videoPlaybackManager: VideoPlaybackManager) {
        self.navigator = navigator
        self.automaton = automaton
        self.videoPlaybackManager = videoPlaybackManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColor()
        setupVideoView()
        setupCancelButton()
        setupVolumeButton()
        bindToAutomaton()
    }

    private func setupBackgroundColor() {
        view.backgroundColor = .black
    }

    private func setupVideoView() {
        view.addSubview(videoView)
        videoView.fillSuperview()
    }

    private func setupCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                leading: view.leadingAnchor,
                topConstant: .margin,
                leadingConstant: .margin)
        cancelButton.size(with: cancelButtonSize)
        cancelButton.rx.tap
                .bind { [weak self] in self?.dismiss(animated: true) }
                .disposed(by: disposeBag)
    }

    private func setupVolumeButton() {
        view.addSubview(volumeButton)
        volumeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                trailing: view.trailingAnchor,
                topConstant: .margin,
                trailingConstant: .margin)
        volumeButton.size(with: volumeButtonSize)
        volumeButton.rx.tap
                .bind { [weak self] in self?.videoPlaybackManager.changeMuting() }
                .disposed(by: disposeBag)
    }

    private func bindToAutomaton() {
        automaton.state
                .map { $0.playbackState.lesson }
                .distinctUntilChanged()
                .bind { [weak self] in self?.lessonChanged(to: $0) }
                .disposed(by: disposeBag)

        automaton.state
                .map { $0.playbackState.isPlaying }
                .distinctUntilChanged()
                .bind { [weak self] in self?.isPlayingChanged(to: $0) }
                .disposed(by: disposeBag)
    }

    private func lessonChanged(to lesson: Lesson?) {
        if let lesson = lesson {
            let videoPlayer = videoPlaybackManager.configure(with: lesson.videoURL)
            videoView.configure(with: videoPlayer)
            bind(to: videoPlayer)
        } else {
            videoView.configure(with: nil)
            unbindFromVideoPlayer()
        }
    }

    private func bind(to videoPlayer: VideoPlayer) {
        let disposeBag = DisposeBag()
        videoPlayer.isMuted
                .bind { [weak self] isMuted in
                    let image = isMuted ? UIImage.volumeOffBig : UIImage.volumeUpBig
                    self?.volumeButton.setImage(image?.asTemplate(), for: .normal)
                }
                .disposed(by: disposeBag)
        videoPlayerDisposeBag = disposeBag
    }

    private func unbindFromVideoPlayer() {
        videoPlayerDisposeBag = nil
    }

    private func isPlayingChanged(to isPlaying: Bool) {
        if isPlaying {
            videoPlaybackManager.startPlayback()
        } else {
            videoPlaybackManager.stopPlayback()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        automaton.send(input: SetIsPlayingInput(isPlaying: true))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        automaton.send(input: SetIsPlayingInput(isPlaying: false))
    }
}
