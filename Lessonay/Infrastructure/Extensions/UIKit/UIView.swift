//
// Created by Nominalista on 02.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import UIKit

extension UIView {

    func anchor(top: NSLayoutYAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                topConstant: CGFloat = 0,
                bottomConstant: CGFloat = 0,
                leadingConstant: CGFloat = 0,
                trailingConstant: CGFloat = 0,
                widthConstant: CGFloat = 0,
                heightConstant: CGFloat = 0) {
        _ = anchorWithReturnAnchors(top: top,
                bottom: bottom,
                leading: leading,
                trailing: trailing,
                topConstant: topConstant,
                bottomConstant: bottomConstant,
                leadingConstant: leadingConstant,
                trailingConstant: trailingConstant,
                widthConstant: widthConstant,
                heightConstant: heightConstant)
    }

    func anchorWithReturnAnchors(top: NSLayoutYAxisAnchor? = nil,
                                 bottom: NSLayoutYAxisAnchor? = nil,
                                 leading: NSLayoutXAxisAnchor? = nil,
                                 trailing: NSLayoutXAxisAnchor? = nil,
                                 topConstant: CGFloat = 0,
                                 bottomConstant: CGFloat = 0,
                                 leadingConstant: CGFloat = 0,
                                 trailingConstant: CGFloat = 0,
                                 widthConstant: CGFloat = 0,
                                 heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        if let leading = leading {
            anchors.append(leadingAnchor.constraint(equalTo: leading, constant: leadingConstant))
        }
        if let trailing = trailing {
            anchors.append(trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant))
        }
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        anchors.forEach({ $0.isActive = true })

        return anchors
    }

    func anchorCenterToSuperview(constant: CGFloat = 0) {
        anchorCenterXToSuperview(constant: constant)
        anchorCenterYToSuperview(constant: constant)
    }

    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        if let superview = superview {
            anchorCenterX(to: superview, constant: constant)
        }
    }

    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        if let superview = superview {
            anchorCenterY(to: superview, constant: constant)
        }
    }

    func anchorCenter(to view: UIView, constant: CGFloat = 0) {
        anchorCenterX(to: view, constant: constant)
        anchorCenterY(to: view, constant: constant)
    }

    func anchorCenterX(to view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }

    func anchorCenterY(to view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }
}