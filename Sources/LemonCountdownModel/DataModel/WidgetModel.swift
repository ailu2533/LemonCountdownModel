//
//  WidgetModel.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import Foundation
import SwiftData

@Model
class WidgetModel: Identifiable {
    var id = UUID()
    // 模板的json数据 类型是MultiplePhaseTemplate
    var widgetTemplateModel: WidgetTemplateModel
    var eventModel: EventModel
    var createTime: Date

    init(widgetTemplateModel: WidgetTemplateModel, eventModel: EventModel) {
        self.widgetTemplateModel = widgetTemplateModel
        self.eventModel = eventModel
        createTime = .now
    }
}
