//
// Created by Nominalista on 06.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import UIKit
import VideoPlayer

class ApplicationNavigator {

    private let automaton: ApplicationAutomaton

    private lazy var homeViewController = HomeViewController(navigator: self, automaton: automaton)

    init() {
        let state = ApplicationState()
        let mapper = ApplicationMapper()
        self.automaton = ApplicationAutomaton(state: state, mapping: mapper.map)
    }

    func configure(window: UIWindow) {
        window.rootViewController = homeViewController
    }

    func toLesson() {
        let videoCache = VideoCache(fileManager: FileManager.default)
        let videoPlaybackSettings = VideoPlaybackSettings(cache: videoCache)
        let videoPlaybackManager = VideoPlaybackManager(settings: videoPlaybackSettings,
                notificationCenter: NotificationCenter.default)
        let lessonViewController = PlaybackViewController(navigator: self,
                automaton: automaton,
                videoPlaybackManager: videoPlaybackManager)
        homeViewController.present(lessonViewController, animated: true)
    }
}