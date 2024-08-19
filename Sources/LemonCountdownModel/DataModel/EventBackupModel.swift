//
//  EventBackupModel.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import Foundation
import LemonDateUtils
// import LemonUtils
import SwiftData

@Model
public class EventBackupModel: Identifiable, RecurringEvent {
    // MARK: - Identifiers

    public var id: UUID

    // MARK: - Basic Event Details

    public var title: String
    public var startDate: Date
    public var endDate: Date
    public var isAllDayEvent = true
    public var isEnabled = true

    // MARK: - Recurrence Settings

    public var recurrenceType = RecurrenceType.singleCycle
    public var isRepeatEnabled = false
    public var repeatPeriod = RepeatPeriod.daily
    public var repeatInterval = 1
    public var repeatEndDate: Date?
    // Bit array for custom weekly repeat (e.g., 15 means Mon to Thu)
    public var repeatCustomWeekly: UInt8 = 0

    // 上次更新缓存的时间，如果缓存隔天了，则需要重新更新
    @Transient public var lastCacheUpdateDate: Date?
    @Transient public var nextStartDateCache: Date?

    public var createDate: Date
    public var updateDate: Date

    // MARK: - Initialization

    public init(title: String, startDate: Date, endDate: Date, isAllDayEvent: Bool, isEnabled: Bool, recurrenceType: RecurrenceType, isRepeatEnabled: Bool, repeatPeriod: RepeatPeriod, repeatInterval: Int, repeatEndDate: Date? = nil, repeatCustomWeekly: UInt8) {
        id = UUID()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.isAllDayEvent = isAllDayEvent
        self.isEnabled = isEnabled
        self.recurrenceType = recurrenceType
        self.isRepeatEnabled = isRepeatEnabled
        self.repeatPeriod = repeatPeriod
        self.repeatInterval = repeatInterval
        self.repeatEndDate = repeatEndDate
        self.repeatCustomWeekly = repeatCustomWeekly
        createDate = .now
        updateDate = .now
    }
}

extension EventBackupModel: Equatable {
    static func equal(lhs: EventBackupModel, rhs: EventModel) -> Bool {
        return lhs.title == rhs.title &&
            lhs.startDate == rhs.startDate &&
            lhs.endDate == rhs.endDate &&
            lhs.isAllDayEvent == rhs.isAllDayEvent &&
            lhs.isEnabled == rhs.isEnabled &&
            lhs.recurrenceType == rhs.recurrenceType &&
            lhs.isRepeatEnabled == rhs.isRepeatEnabled &&
            lhs.repeatPeriod == rhs.repeatPeriod &&
            lhs.repeatInterval == rhs.repeatInterval &&
            lhs.repeatEndDate == rhs.repeatEndDate &&
            lhs.repeatCustomWeekly == rhs.repeatCustomWeekly
    }
}

extension EventBackupModel: CustomStringConvertible {
    public var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // 设置日期显示为中等长度
        dateFormatter.timeStyle = .short // 设置时间显示为短格式

        let formattedStartDate = dateFormatter.string(from: startDate)
        let formattedEndDate = dateFormatter.string(from: endDate)
        let formattedCreateDate = dateFormatter.string(from: createDate)
        let formattedUpdateDate = dateFormatter.string(from: updateDate)
        let formattedRepeatEndDate = repeatEndDate != nil ? dateFormatter.string(from: repeatEndDate!) : "nil"
        let formattedLastCacheUpdateDate = lastCacheUpdateDate != nil ? dateFormatter.string(from: lastCacheUpdateDate!) : "nil"
        let formattedNextStartDateCache = nextStartDateCache != nil ? dateFormatter.string(from: nextStartDateCache!) : "nil"

        return """
        EventBackupModel(
            id: \(id),
            title: \(title),
            startDate: \(formattedStartDate),
            endDate: \(formattedEndDate),
            isAllDayEvent: \(isAllDayEvent),
            isEnabled: \(isEnabled),
            recurrenceType: \(recurrenceType),
            isRepeatEnabled: \(isRepeatEnabled),
            repeatPeriod: \(repeatPeriod),
            repeatInterval: \(repeatInterval),
            repeatEndDate: \(formattedRepeatEndDate),
            repeatCustomWeekly: \(repeatCustomWeekly),
            createDate: \(formattedCreateDate),
            updateDate: \(formattedUpdateDate),
            lastCacheUpdateDate: \(formattedLastCacheUpdateDate),
            nextStartDateCache: \(formattedNextStartDateCache)
        )
        """
    }
}

extension EventBackupModel: EventInfoProvider {
    public var widgetTitle: String {
        ""
    }

    public var eventTitle: String {
        title
    }

    public var daysUntilNextStart: Int {
        Calendar.current.numberOfDaysBetween(Date(), and: nextStartDate)
    }

    public var nextStartDate: Date {
        Date()
    }

    public var nextEndDate: Date {
        Date()
    }
}
