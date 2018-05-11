//
// Created by Nominalista on 09.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import AVFoundation
import DesignExtensions
import RxCocoa
import RxSwift
import UIKit
import VideoPlayer

class VideoView: UIView {

    lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.videoGravity = .resizeAspectFill
        return layer
    }()

    lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .white
        indicator.hidesWhenStopped = false
        indicator.startAnimating()
        return indicator
    }()

    private var disposeBag: DisposeBag?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerLayer()
        setupIndicatorView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlayerLayer() {
        layer.addSublayer(playerLayer)
    }

    private func setupIndicatorView() {
        addSubview(indicatorView)
        indicatorView.anchorCenterToSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPlayerLayer()
    }

    private func layoutPlayerLayer() {
        playerLayer.frame = bounds
    }

    func configure(with videoPlayer: VideoPlayer?) {
        if let videoPlayer = videoPlayer {
            playerLayer.player = videoPlayer.player
            let disposeBag = DisposeBag()
            videoPlayer.status
                    .bind { self.indicatorView.isHidden = $0 == .playing }
                    .disposed(by: disposeBag)
            self.disposeBag = disposeBag
        } else {
            playerLayer.player = nil
            indicatorView.isHidden = true
            disposeBag = nil
        }
    }
}