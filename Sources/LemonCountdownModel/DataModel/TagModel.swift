//
//  TagModel.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/4.
//

import Foundation
import SwiftData

// 打卡标签, 用于习惯的分类管理
@Model
class Tag {
    var uuid: UUID

    @Attribute(.unique) var title: String
    var events: [EventModel]? = []

    var createTime = Date.now
    var updateTime = Date.now
    var sortValue = 0

    init(title: String, sortValue: Int = 0) {
        self.title = title
        self.sortValue = sortValue

        let now = Date.now
        createTime = now
        updateTime = now
        uuid = UUID()
    }
}

extension Tag: Identifiable {
    var id: UUID {
        uuid
    }
}
