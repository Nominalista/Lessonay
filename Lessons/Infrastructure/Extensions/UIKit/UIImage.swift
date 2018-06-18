//
// Created by Nominalista on 06.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import UIKit

extension UIImage {

    func asTemplate() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }

    // Icons

    class var clearBig: UIImage? {
        return UIImage(named: "ic_clear_36pt")
    }

    class var playLarge: UIImage? {
        return UIImage(named: "ic_play_48pt")
    }

    class var refreshLarge: UIImage? {
        return UIImage(named: "ic_refresh_48pt")
    }

    class var volumeOffBig: UIImage? {
        return UIImage(named: "ic_volume_off_36pt")
    }

    class var volumeUpBig: UIImage? {
        return UIImage(named: "ic_volume_up_36pt")
    }

    // Images

    class var convexity: UIImage? {
        return UIImage(named: "img_convexity_300x300pt")
    }
}

