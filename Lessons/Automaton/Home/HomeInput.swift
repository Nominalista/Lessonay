//
// Created by Nominalista on 10.07.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

protocol HomeInput: ApplicationInput {
}

struct SetLessonStateInput: HomeInput {
    let lessonState: LessonState
}
