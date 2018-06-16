//
// Created by Nominalista on 03.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import Foundation
import RxSwift

class LessonService {

    func retrieveLesson() -> Observable<Lesson> {
        let videoURL = URL(string: "https://mpcwrkhottyhwpbs37bns2.blob.core.windows.net:443/4972c42ef8b94fb68d7a610f294b278f/xpogo.mp4")!
        let lesson = Lesson(videoURL: videoURL)
        let delay: RxTimeInterval = 2
        return Observable.just(lesson)
                .delay(delay, scheduler: MainScheduler.instance)
    }
}