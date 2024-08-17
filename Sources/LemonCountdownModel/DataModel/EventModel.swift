//
//  EventModel.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/4.
//

import AppIntents
import Foundation
import LemonDateUtils
// import LemonUtils
import SwiftData

enum DataModelType: Int, Codable {
    // 用户创建
    case user
    // 内建数据不允许修改
    case builtin
}

protocol RecurringEvent {
    var title: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var recurrenceType: RecurrenceType { get }
    var isRepeatEnabled: Bool { get }
    var repeatPeriod: RepeatPeriod { get }
    var repeatInterval: Int { get }
    var repeatEndDate: Date? { get }
    var repeatCustomWeekly: UInt8 { get }

    var lastCacheUpdateDate: Date? { get }
    var nextStartDateCache: Date? { get }
}

@Model
class EventModel: Identifiable, RecurringEvent {
    // MARK: - Identifiers

    var id: UUID

    // MARK: - Basic Event Details

    var title: String
    var startDate: Date
    var endDate: Date
    var isAllDayEvent = true
    var isEnabled = true

    // MARK: - Appearance

    var icon: String
    var colorHex: String
    var backgroundImage: String?

    // MARK: - Recurrence Settings

    var recurrenceType = RecurrenceType.singleCycle
    var isRepeatEnabled = false
    var repeatPeriod = RepeatPeriod.daily
    var repeatInterval = 1
    var repeatEndDate: Date?
    // Bit array for custom weekly repeat (e.g., 15 means Mon to Thu)
    var repeatCustomWeekly: UInt8 = 0

    // MARK: - Notifications

    var isNotificationEnabled = false
    var eventIdentifier: String?
    var firstNotification = EventNotification.none
    var secondNotification = EventNotification.none

    // MARK: - Widget Templates

//    var widgetTemplateModel: WidgetTemplateModel?
//    var widgetTemplateModelMedium: WidgetTemplateModel?
//    var widgetTemplateModelLarge: WidgetTemplateModel?

    // MARK: - Relationships

    @Relationship(inverse: \Tag.events)
    var tag: Tag?

    // MARK: - Metadata

    var type: DataModelType.RawValue = DataModelType.user.rawValue
    var createDate: Date
    var updateDate: Date

    // MARK: - Caching

    // 上次更新缓存的时间，如果缓存隔天了，则需要重新更新
    @Transient var lastCacheUpdateDate: Date?
    @Transient var nextStartDateCache: Date?

    // MARK: - Initialization

    init(title: String, startDate: Date, endDate: Date, icon: String, colorHex: String) {
        id = UUID()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.icon = icon
        self.colorHex = colorHex
        createDate = .now
        updateDate = .now
    }
}

extension EventModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(isAllDayEvent)
        hasher.combine(icon)
        hasher.combine(colorHex)
        hasher.combine(backgroundImage)
        hasher.combine(isRepeatEnabled)
        hasher.combine(repeatPeriod)
    }
}

extension EventModel: CustomStringConvertible {
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        return """
        EventModel(
            id: \(id),
            title: \(title),
            startDate: \(dateFormatter.string(from: startDate)),
            endDate: \(dateFormatter.string(from: endDate)),
            isAllDayEvent: \(isAllDayEvent),
            isEnabled: \(isEnabled),
            type: \(type),
            icon: \(icon),
            colorHex: \(colorHex),
            backgroundImage: \(backgroundImage ?? "None"),
            isRepeatEnabled: \(isRepeatEnabled),
            repeatPeriod: \(repeatPeriod),
            repeatInterval: \(repeatInterval),
            repeatEndDate: \(repeatEndDate.map { dateFormatter.string(from: $0) } ?? "None"),
            isNotificationEnabled: \(isNotificationEnabled),
            eventIdentifier: \(eventIdentifier ?? "None"),
            firstNotification: \(firstNotification),
            secondNotification: \(secondNotification),
            createDate: \(dateFormatter.string(from: createDate)),
            updateDate: \(dateFormatter.string(from: updateDate))
        )
        """
    }
}
