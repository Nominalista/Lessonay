//
// Created by Nominalista on 03.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import Foundation
import RxSwift

class LessonService {

    func retrieveLesson() -> Observable<Lesson> {
        let videoURL = URL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!
        let lesson = Lesson(videoURL: videoURL)
        let delay: RxTimeInterval = 2
        return Observable.just(lesson)
                .delay(delay, scheduler: MainScheduler.instance)
    }
}