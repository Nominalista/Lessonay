//
// Created by Nominalista on 06.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import UIKit

extension UIColor {

    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }

    // General

    class var background: UIColor {
        return rgb(red: 248, green: 222, blue: 173)
    }

    class var primary: UIColor {
        return rgb(red: 76, green: 57, blue: 45)
    }

    // Icons

    class var iconActive: UIColor {
        return rgb(red: 255, green: 255, blue: 255)
    }

    class var iconInactive: UIColor {
        return UIColor.iconActive.withAlphaComponent(0.5)
    }

    class var iconHighlighted: UIColor {
        return UIColor.iconActive.withAlphaComponent(0.3)
    }
}