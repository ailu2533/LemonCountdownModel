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
public class Tag {
    public var uuid: UUID

    @Attribute(.unique) public var title: String
    public var events: [EventModel]? = []

    public var createTime = Date.now
    public var updateTime = Date.now
    public var sortValue = 0

    public init(title: String, sortValue: Int = 0) {
        self.title = title
        self.sortValue = sortValue

        let now = Date.now
        createTime = now
        updateTime = now
        uuid = UUID()
    }
}

extension Tag: Identifiable {
    public var id: UUID {
        uuid
    }
}
