//
// Created by Nominalista on 04.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController {

    private let automaton: Automaton<AppTransducer>

    init(automaton: Automaton<AppTransducer>) {
        self.automaton = automaton
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}