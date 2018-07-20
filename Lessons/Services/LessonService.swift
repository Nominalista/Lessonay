//
// Created by Nominalista on 03.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import Foundation
import RxSwift

private let baseURL = URL(string: "https://pixabay.com/api/videos")!
private let keyItem = URLQueryItem(name: "key", value: "9307750-f1ece6a3a8526233edf7ca4c1")
private let queryItem = URLQueryItem(name: "q", value: "lesson")

class LessonService {

    func loadLesson() -> Observable<Lesson> {
        return Observable.create { observer in
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [keyItem, queryItem]

            guard let url = components?.url else { return Disposables.create() }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    observer.onError(error ?? ServiceError.unknown)
                    return
                }

                guard let url = LessonService.parse(data: data) else {
                    observer.onError(ServiceError.parsing)
                    return
                }

                observer.onNext(Lesson(videoURL: url))
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create { task.cancel() }
        }
    }

    private static func parse(data: Data) -> URL? {
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            return nil
        }

        let hits = json["hits"] as? [[String: Any]]
        let randomHit = hits?.random
        let videos = randomHit?["videos"] as? [String: Any]
        let mediumVideo = videos?["medium"] as? [String: Any]
        let urlString = mediumVideo?["url"] as? String

        if let urlString = urlString {
            return URL(string: urlString)
        } else {
            return nil
        }
    }
}