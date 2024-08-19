//
//  EventBuilder.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/4.
//

import Collections
import Foundation
import LemonDateUtils

// import LemonUtils

let desserts: [String] = [
    "001-christmas cookie",
    "002-pumpkin",
    "003-cinnamon roll",
    "004-shaved ice",
    "005-cheesecake",
    "006-jelly beans",
    "007-cupcake",
    "008-cake pop",
    "009-sundae",
    "010-popsicle",
    "011-dango",
    "012-pumpkin pie",
    "013-ice cream",
    "014-pudding",
    "015-chocolate bar",
    "016-donuts",
    "017-candies",
    "018-lollipop",
    "019-milkshake",
    "020-ice cream"
]

let animals: [String] = [
    "dog_1864532",
    "elephant_1864469",
    "hen_1864470",
    "monkey_1864483",
    "parrot_1864474",
    "sheep_1864535",
    "beach_2990644",
    "dolphin_1864473",
    "hedgehog_1864601",
    "koala_1864527",
    "panda-bear_1864516",
    "rabbit_1864488",
    "squirrel_1864480"
]

let emoji = [
    "idea_8231426",
    "laughing_8231446",
    "love_2018269",
    "smileys_9470713",
    "stars_8231347",
    "tired_2018421"
]

let iconsMap: OrderedDictionary<String, [String]> = [
    String(localized: "表情"): emoji,
    String(localized: "甜点"): desserts,
    String(localized: "动物"): animals
]

public enum WidgetSize: Int, CaseIterable, Identifiable, Codable {
    case small = 0
    case medium = 1
//    case large = 2

    var text: String {
        switch self {
        case .small:
            return String(localized: "Small-sized Widget")
        case .medium:
            return String(localized: "Medium-sized Widget")
//        case .large:
//            return String(localized: "Large Widget")
        }
    }

    public var id: Int {
        return rawValue
    }
}

@Observable
public class EventBuilder {
    public var title = ""
    public var startDate: Date = .now
    public var endDate: Date = .now
    public var isAllDayEvent = true
    public var isEnabled = true
    public var icon = ""
    public var colorHex = ""
    public var backgroundImage: String?

    public var recurrenceType = RecurrenceType.singleCycle
    public var repeatCustomWeekly: UInt8 = 0
    public var isRepeatEnabled = false
    public var repeatPeriod: RepeatPeriod = .daily
    public var repeatInterval = 1
    public var hasRepeatEndDate = true
    public var repeatEndDate: Date?

    public var tag: Tag?

    public var eventType: DataModelType.RawValue = DataModelType.user.rawValue
    public var isNotificationEnabled = false
    public var firstNotification: EventNotification = .none
    public var secondNotification: EventNotification = .none
    public var eventIdentifier = ""

    // 小号小组件
    public var widgetTemplateModel: WidgetTemplateModel?
    // 中号小组件
    public var widgetTemplateModelMedium: WidgetTemplateModel?
    // 号小组件
    public var widgetTemplateModelLarge: WidgetTemplateModel?

    public init() {
        let calendar = Calendar.current
        let today = Date()

        isAllDayEvent = true
        startDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: today)!
        endDate = calendar.date(bySettingHour: 23, minute: 59, second: 0, of: today)!

        if let firstKey = iconsMap.keys.first, let firstIcon = iconsMap[firstKey]?.first {
            icon = firstIcon
        } else {
            // 处理错误情况，例如设置一个默认的 icon
            icon = "036-in love" // 假设有一个默认图标名称
        }
    }

    public func postInit(_ event: EventModel) {
        title = event.title
        startDate = event.startDate
        endDate = event.endDate
        colorHex = event.colorHex
        icon = event.icon

        recurrenceType = event.recurrenceType
        repeatCustomWeekly = event.repeatCustomWeekly
        isRepeatEnabled = event.isRepeatEnabled
        repeatPeriod = event.repeatPeriod
        repeatInterval = event.repeatInterval

        isNotificationEnabled = event.isNotificationEnabled
        firstNotification = event.firstNotification
        secondNotification = event.secondNotification

        if let repeatEndDate = event.repeatEndDate {
            hasRepeatEndDate = true
            self.repeatEndDate = repeatEndDate
        } else {
            hasRepeatEndDate = false
            repeatEndDate = nil
        }

//        widgetTemplateModel = event.widgetTemplateModel
//        widgetTemplateModelMedium = event.widgetTemplateModelMedium
//        widgetTemplateModelLarge = event.widgetTemplateModelLarge

        tag = event.tag

        isAllDayEvent = event.isAllDayEvent
    }

    public func adjustDate() {
        if isAllDayEvent {
            // startDate 为当上午 9 点
            let startOfDay = startDate.adjust(for: .startOfDay)!
            startDate = startOfDay
            endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: startDate)!
        }
    }

    @discardableResult
    public func setTitle(_ title: String) -> EventBuilder {
        self.title = title
        return self
    }

    @discardableResult
    public func setStartDate(_ date: Date) -> EventBuilder {
        startDate = date
        return self
    }

    @discardableResult
    public func setEndDate(_ date: Date) -> EventBuilder {
        endDate = date
        return self
    }

    @discardableResult
    public func setAllDayEvent(_ allDay: Bool) -> EventBuilder {
        isAllDayEvent = allDay
        return self
    }

    @discardableResult
    public func setEnabled(_ enabled: Bool) -> EventBuilder {
        isEnabled = enabled
        return self
    }

    @discardableResult
    public func setIcon(_ icon: String) -> EventBuilder {
        self.icon = icon
        return self
    }

    @discardableResult
    public func setColorHex(_ colorHex: String) -> EventBuilder {
        self.colorHex = colorHex
        return self
    }

    @discardableResult
    public func setBackgroundImage(_ image: String) -> EventBuilder {
        backgroundImage = image
        return self
    }

    @discardableResult
    public func setRepeatEnabled(_ enabled: Bool) -> EventBuilder {
        isRepeatEnabled = enabled
        return self
    }

    @discardableResult
    public func setRepeatPeriod(_ period: RepeatPeriod) -> EventBuilder {
        repeatPeriod = period
        return self
    }

    @discardableResult
    public func setRepeatInterval(_ interval: Int) -> EventBuilder {
        repeatInterval = interval
        return self
    }

    @discardableResult
    public func setRepeatEndDate(_ date: Date) -> EventBuilder {
        repeatEndDate = date
        return self
    }

    @discardableResult
    public func setEventType(_ type: DataModelType.RawValue) -> EventBuilder {
        eventType = type
        return self
    }

    @discardableResult
    public func setFirstNotification(_ notification: EventNotification) -> EventBuilder {
        firstNotification = notification
        return self
    }

    @discardableResult
    public func setSecondNotification(_ notification: EventNotification) -> EventBuilder {
        secondNotification = notification
        return self
    }

    public func build() throws -> EventModel {
        guard startDate < endDate else {
            throw EventBuilderError.startDateAfterEndDate
        }

        // 允许重复，且设置了重复结束日期时，要保证重复结束日期大于事件的结束日期
        if isRepeatEnabled && repeatEndDate != nil {
            repeatEndDate = repeatEndDate!.adjust(for: .endOfDay)!

            guard repeatEndDate! >= endDate else {
                throw EventBuilderError.repeatEndDateBeforeEndDate
            }
        }

        guard !title.isEmpty else {
            throw EventBuilderError.emptyTitle
        }

        guard !icon.isEmpty else {
            throw EventBuilderError.emptyIcon
        }

        guard !colorHex.isEmpty else {
            throw EventBuilderError.emptyColorHex
        }

        let event = EventModel(title: title, startDate: startDate, endDate: endDate, icon: icon, colorHex: colorHex)
        event.backgroundImage = backgroundImage

        event.isAllDayEvent = isAllDayEvent
        event.isEnabled = isEnabled

        event.repeatCustomWeekly = repeatCustomWeekly
        event.recurrenceType = recurrenceType
        event.isRepeatEnabled = isRepeatEnabled
        event.repeatPeriod = repeatPeriod
        event.repeatInterval = repeatInterval
        if hasRepeatEndDate {
            event.repeatEndDate = repeatEndDate
        } else {
            event.repeatEndDate = nil
        }

        event.type = eventType
        event.isNotificationEnabled = isNotificationEnabled
        event.firstNotification = firstNotification
        event.secondNotification = secondNotification
        event.eventIdentifier = eventIdentifier

        event.tag = tag

//        event.widgetTemplateModel = widgetTemplateModel
//        event.widgetTemplateModelMedium = widgetTemplateModelMedium
//        event.widgetTemplateModelLarge = widgetTemplateModelLarge

        return event
    }

    public func notificationConfigCopy() -> EventModel {
        let event = EventModel(title: title, startDate: startDate, endDate: endDate, icon: icon, colorHex: colorHex)
        event.isAllDayEvent = isAllDayEvent
        event.isEnabled = isEnabled
        event.isRepeatEnabled = isRepeatEnabled
        event.repeatPeriod = repeatPeriod
        event.repeatInterval = repeatInterval
        if hasRepeatEndDate {
            event.repeatEndDate = repeatEndDate
        } else {
            event.repeatEndDate = nil
        }

        event.type = eventType
        event.isNotificationEnabled = isNotificationEnabled
        event.firstNotification = firstNotification
        event.secondNotification = secondNotification
        event.eventIdentifier = eventIdentifier
        return event
    }
}

enum EventBuilderError: Error, LocalizedError {
    case startDateAfterEndDate
    case repeatEndDateBeforeEndDate
    case emptyTitle
    case emptyIcon
    case emptyColorHex

    var errorDescription: String? {
        switch self {
        case .startDateAfterEndDate:
            return "The start date must be earlier than the end date."
        case .repeatEndDateBeforeEndDate:
            return "The repeat end date must be on or after the end date."
        case .emptyTitle:
            return "The title cannot be empty."
        case .emptyIcon:
            return "The icon field cannot be empty."
        case .emptyColorHex:
            return "The color hex code cannot be empty."
        }
    }
}
