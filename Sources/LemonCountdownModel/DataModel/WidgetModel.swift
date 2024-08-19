//
//  WidgetModel.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import Foundation
import SwiftData

@Model
public class WidgetModel: Identifiable {
    public var id = UUID()
    // 模板的json数据 类型是MultiplePhaseTemplate
    public var widgetTemplateModel: WidgetTemplateModel
    public var eventModel: EventModel
    public var createTime: Date

    public init(widgetTemplateModel: WidgetTemplateModel, eventModel: EventModel) {
        self.widgetTemplateModel = widgetTemplateModel
        self.eventModel = eventModel
        createTime = .now
    }
}
