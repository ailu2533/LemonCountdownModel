//
//  EventModel+.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/5.
//

import Foundation
import LemonDateUtils
// import LemonUtils

extension RecurringEvent {
    // var daysUntilNextStart: Int {
    //     return 0
    // }

    // 计算事件的下一次开始时间
    var nextStartDate: Date {
        // 不重复，不需要缓存
        if !isRepeatEnabled {
            // 如果不重复，直接返回原始开始日期
            return startDate
        }

        let date = calcNextStartDate()
        let components = Calendar.current.dateComponents([.hour, .minute], from: startDate)
        return Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: date)!
    }

    // 昂贵的计算操作
    func calcNextStartDate() -> Date {
//        Logging.shared.debug("calcNextStartDate \(title)")
        // 重复
        if Calendar.current.isDateInToday(startDate) {
            // 如果是今天，返回0天
            return startDate
        }

        // 获取当前日期
        let currentDate = Date()

        // 倒计时还没有到
        if startDate >= currentDate {
            return startDate
        }

        // 检查当前时间是否已经超过了事件的重复结束日期
        if let repeatEndDate, currentDate > repeatEndDate {
            // 如果超过了重复结束日期，返回从当前日期到开始日期的天数差
            return startDate
        }

        // 计算到下一个重复日期的天数
        let daysToNextRepeat = calculateNearestRepeatDate(startDate: startDate, currentDate: currentDate, repeatPeriod: repeatPeriod, interval: repeatInterval, recurrenceType: recurrenceType, customWeek: repeatCustomWeekly)

        // 计算下一次的开始日期
        let nextStartDate = currentDate.offset(.day, value: daysToNextRepeat)!

        // 检查下一次的开始日期是否大于事件的重复结束日期
        if let repeatEndDate, nextStartDate > repeatEndDate {
            // 如果是，返回从当前日期到开始日期的天数差
            return startDate
        }

        return nextStartDate
    }

    // TODO: 实现 就是下一次开始日期
    var nextEndDate: Date {
        let components = Calendar.current.dateComponents([.hour, .minute], from: endDate)
        let date = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: nextStartDate)
        return date!
    }
}

extension EventModel {
    func updateFrom(builder cb: EventBuilder) {
        title = cb.title
        startDate = cb.startDate
        endDate = cb.endDate
        colorHex = cb.colorHex
        icon = cb.icon

        recurrenceType = cb.recurrenceType
        repeatCustomWeekly = cb.repeatCustomWeekly
        isRepeatEnabled = cb.isRepeatEnabled
        repeatPeriod = cb.repeatPeriod
        repeatInterval = cb.repeatInterval
        repeatEndDate = cb.repeatEndDate
        isRepeatEnabled = cb.isRepeatEnabled

        isNotificationEnabled = cb.isNotificationEnabled
        firstNotification = cb.firstNotification
        secondNotification = cb.secondNotification

//        widgetTemplateModel = cb.widgetTemplateModel
//        widgetTemplateModelMedium = cb.widgetTemplateModelMedium
//        widgetTemplateModelLarge = cb.widgetTemplateModelLarge
        tag = cb.tag

        isAllDayEvent = cb.isAllDayEvent

        if !cb.hasRepeatEndDate {
            repeatEndDate = nil
        }
    }

    func invalidateCache() {
        lastCacheUpdateDate = nil
        nextStartDateCache = nil
    }
}
