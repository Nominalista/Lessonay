//
// Created by Nominalista on 06.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import UIKit

extension UIFont {

    class var display: UIFont {
        return .systemFont(ofSize: .displayFontPointSize, weight: .heavy) // 22
    }

    class var headline: UIFont {
        return .systemFont(ofSize: .headlineFontPointSize, weight: .heavy) // 19
    }

    class var title: UIFont {
        return .systemFont(ofSize: .titleFontPointSize, weight: .heavy) // 17
    }

    class var subhead: UIFont {
        return .systemFont(ofSize: .subheadPointSize, weight: .regular) // 17
    }

    class var subheadBold: UIFont {
        return .systemFont(ofSize: .subheadPointSize, weight: .bold) // 17
    }

    class var body: UIFont {
        return .systemFont(ofSize: .bodyFontPointSize, weight: .regular) // 15
    }

    class var caption: UIFont {
        return .systemFont(ofSize: .captionFontPointSize, weight: .regular) // 13
    }

    class var button: UIFont {
        return .systemFont(ofSize: .buttonFontPointSize, weight: .bold) // 15
    }
}