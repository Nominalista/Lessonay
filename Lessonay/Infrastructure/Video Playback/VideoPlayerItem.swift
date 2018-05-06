//
// Created by Nominalista on 02.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import AVFoundation
import Foundation

class VideoPlayerItem: AVPlayerItem {

    var isRemote: Bool {
        return asset is RemoteVideoAsset
    }

    init(asset: VideoAsset) {
        super.init(asset: asset, automaticallyLoadedAssetKeys: nil)
    }
}