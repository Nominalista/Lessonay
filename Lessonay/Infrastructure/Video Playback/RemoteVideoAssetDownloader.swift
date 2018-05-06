//
// Created by Nominalista on 02.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import AVFoundation
import Foundation

protocol RemoteVideoAssetDownloaderDelegate: class {

    func remoteVideoAssetDownloader(_ remoteVideoAssetDownloader: RemoteVideoAssetDownloader, didDownload data: Data)
}

class RemoteVideoAssetDownloader: NSObject {

    weak var delegate: RemoteVideoAssetDownloaderDelegate?

    let url: URL

    private var session: URLSession?
    private var response: URLResponse?
    private var mediaData: Data?

    private var pendingRequests = Set<AVAssetResourceLoadingRequest>()

    init(url: URL) {
        self.url = url
    }

    func download() {
        startDataRequest()
    }

    private func startDataRequest() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        session?.dataTask(with: url).resume()
    }

    private func processPendingRequests() {
        let fulfilledRequests: [AVAssetResourceLoadingRequest] = pendingRequests.compactMap { pendingRequest in
            self.fillIn(contentInformationRequest: pendingRequest.contentInformationRequest)
            if self.hasEnoughDataToFulfill(dataRequest: pendingRequest.dataRequest) {
                pendingRequest.finishLoading()
                return pendingRequest
            }
            return nil
        }

        _ = fulfilledRequests.forEach { self.pendingRequests.remove($0) }
    }

    private func fillIn(contentInformationRequest: AVAssetResourceLoadingContentInformationRequest?) {
        guard let response = response else {
            // have no response from the server yet
            return
        }

        contentInformationRequest?.contentType = response.mimeType
        contentInformationRequest?.contentLength = response.expectedContentLength
        contentInformationRequest?.isByteRangeAccessSupported = true
    }

    private func hasEnoughDataToFulfill(dataRequest: AVAssetResourceLoadingDataRequest?) -> Bool {
        guard let dataRequest = dataRequest else {
            return false
        }

        let requestedOffset = Int(dataRequest.requestedOffset)
        let requestedLength = dataRequest.requestedLength
        let currentOffset = Int(dataRequest.currentOffset)

        guard let mediaData = mediaData, mediaData.count > currentOffset else {
            // Don't have any data at all for this request.
            return false
        }

        let bytesToRespond = min(mediaData.count - currentOffset, requestedLength)
        let dataToRespondRange = Range(uncheckedBounds: (currentOffset, currentOffset + bytesToRespond))
        let dataToRespond = mediaData.subdata(in: dataToRespondRange)
        dataRequest.respond(with: dataToRespond)

        return mediaData.count >= requestedLength + requestedOffset
    }

    deinit {
        session?.invalidateAndCancel()
    }
}

extension RemoteVideoAssetDownloader: AVAssetResourceLoaderDelegate {

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader,
                        shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        if session == nil {
            startDataRequest()
        }

        pendingRequests.insert(loadingRequest)
        processPendingRequests()
        return true
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader,
                        didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        pendingRequests.remove(loadingRequest)
    }
}

extension RemoteVideoAssetDownloader: URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        mediaData?.append(data)
        processPendingRequests()
    }

    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(URLSession.ResponseDisposition.allow)
        self.mediaData = Data()
        self.response = response
        processPendingRequests()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil {
            processPendingRequests()
            if let data = mediaData {
                delegate?.remoteVideoAssetDownloader(self, didDownload: data)
            }
        }
    }
}