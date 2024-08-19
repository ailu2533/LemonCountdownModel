//
//  WidgetTemplateModel.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation
import SwiftData
import SwiftUI
import UIKit

public enum WidgetTemplateKind: Int, CaseIterable, Codable, Identifiable {
    case baseTemplate = 0
    case widgetInstance = 1

    public var id: Self {
        self
    }

    var text: LocalizedStringKey {
        switch self {
        case .baseTemplate:
            return "模板视图"
        case .widgetInstance:
            return "小组件视图"
        }
    }
}

@Model
public class WidgetTemplateModel {
    // 模板id
    public var uuid = UUID()
    // 模板名称
    public var title: String
    public let sizeStore: WidgetSize.RawValue = WidgetSize.small.rawValue
    // 模板尺寸
    public var size: WidgetSize {
        WidgetSize(rawValue: sizeStore) ?? WidgetSize.small
    }

    // 使用了此模板的事件
    public let event: EventModel?
    // 新建一个 EventBackupModel结构

    @Relationship(deleteRule: .cascade)
    public let eventBackup: EventBackupModel?

    // 如果模板绑定事件或，kind 就是 instance
    public let templateKind: WidgetTemplateKind.RawValue = WidgetTemplateKind.baseTemplate.rawValue

    // 模板的json数据 类型是WidgetTemplate
    public var jsonData: String

    // 数据类型
    var dataModelType: DataModelType.RawValue = DataModelType.user.rawValue

    public var createTime: Date
    public var updateTime: Date

    public init(title: String, jsonData: String, size: WidgetSize = .small, templateKind: WidgetTemplateKind = WidgetTemplateKind.baseTemplate, event: EventModel?, eventBackup: EventBackupModel?) {
        self.title = title
        self.jsonData = jsonData
        sizeStore = size.rawValue
        self.templateKind = templateKind.rawValue
        self.event = event
        self.eventBackup = eventBackup
        createTime = .now
        updateTime = .now
    }

    public static func encodeWidgetTemplate(_ widgetTemplate: WidgetTemplate) -> String {
        do {
            let json = try JSONEncoder().encode(widgetTemplate)
            return String(data: json, encoding: .utf8)!
        } catch {
            fatalError()
        }
    }

    // 将json字符串转换为MultiplePhaseTemplate
    public func toWidgetTemplate() -> WidgetTemplate {
        do {
            let widgetTemplate = try JSONDecoder().decode(WidgetTemplate.self, from: jsonData.data(using: .utf8)!)
            widgetTemplate.setWidgetTemplateModel(self)

            return widgetTemplate
        } catch {
            return WidgetTemplate()
//            fatalError("toWidgetTemplate \(jsonData)")
        }
    }
}

public func decodeWidgetTemplate(_ jsonData: String) -> WidgetTemplate {
    do {
        return try JSONDecoder().decode(WidgetTemplate.self, from: jsonData.data(using: .utf8)!)
    } catch {
        Logging.shared.error("\(error)")
        return WidgetTemplate()
    }
}

extension WidgetTemplateModel: CustomStringConvertible {
    public var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        var desc = "WidgetTemplateModel(uuid: \(uuid), title: \(title), size: \(size), jsonData: \(jsonData), createTime: \(dateFormatter.string(from: createTime)), updateTime: \(dateFormatter.string(from: updateTime))"

        if let event {
            desc += ", event: \(event.description)"
        } else {
            desc += ", event: nil"
        }

        if let eventBackup {
            desc += ", eventBackup: \(eventBackup.description)"
        } else {
            desc += ", eventBackup: nil"
        }

//        if let widgetTemplate = widgetTemplate {
//            desc += ", widgetTemplate: \(widgetTemplate.description)"
//        } else {
//            desc += ", widgetTemplate: nil"
//        }

        return desc + ")"
    }
}

extension WidgetTemplateModel: Identifiable {
    public var id: UUID {
        uuid
    }
}

extension WidgetTemplateModel {
    // 创建一个新的WidgetTemplateModel实例，复制当前实例的属性，但kind设置为instance
    public func cloneAsWidgetInstance(event: EventModel, eventBackup: EventBackupModel) -> WidgetTemplateModel {
        let newTitle = "\(event.title) \(Date().formatted(date: .omitted, time: .shortened))"

//        clonedModel.event = event
//        clonedModel.eventBackup = eventBackup

//        clonedModel.title = title
        return WidgetTemplateModel(title: newTitle, jsonData: jsonData, size: size, templateKind: .widgetInstance, event: event, eventBackup: eventBackup)
    }
}
