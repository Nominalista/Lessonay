//
// Created by Nominalista on 02.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import AVFoundation
import Foundation

private let scheme = "remoteVideoAssetScheme"

class RemoteVideoAsset: VideoAsset {

    var downloader: RemoteVideoAssetDownloader? {
        didSet {
            resourceLoader.setDelegate(downloader, queue: DispatchQueue.main)
        }
    }

    override init(url: URL) {
        super.init(url: url.with(scheme: scheme) ?? url)
    }
}