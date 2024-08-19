//
//  CalendarUtils.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/4.
//

import EventKit
import Foundation
// import LemonUtils
import Shift

public class CalendarUtils {
    // 删除事件
    public static func deleteEventById(_ id: String) async {
        do {
            try await Shift.shared.deleteEvent(identifier: id, span: .futureEvents)
        } catch {
            print(error)
        }
    }

    // 原来没有提醒
    public static func addNotification(_ newModel: EventModel) async {
        if newModel.isNotificationEnabled {
            do {
                var event: EKEvent

                if let eventIdentifier = newModel.eventIdentifier, !eventIdentifier.isEmpty, let ev = Shift.shared.eventStore.event(withIdentifier: eventIdentifier) {
                    event = ev
                } else {
                    event = try await Shift.shared.createEvent(newModel.title, startDate: newModel.startDate, endDate: newModel.endDate, isAllDay: newModel.isAllDayEvent)
                }

                // 保存事件id
                newModel.eventIdentifier = event.eventIdentifier

                // 新增提醒
                if newModel.firstNotification != .none {
                    event.addAlarm(.init(relativeOffset: newModel.firstNotification.time))
                }

                if newModel.secondNotification != .none {
                    event.addAlarm(.init(relativeOffset: newModel.secondNotification.time))
                }

                // 重复
                if newModel.isRepeatEnabled {
                    guard let freq = EKRecurrenceFrequency(rawValue: newModel.repeatPeriod.rawValue) else {
                        return
                    }

                    var repeatEnd: EKRecurrenceEnd?
                    if let repeatEndDate = newModel.repeatEndDate {
                        repeatEnd = .init(end: repeatEndDate)
                    }

                    // 根据重复类型创建重复规则
                    switch newModel.recurrenceType {
                    case .singleCycle:
                        // 创建基本的重复规则

                        if freq == .monthly {
                            let rules = createAdaptiveMonthlyRecurrenceRule(startDate: newModel.startDate, repeatEnd: repeatEnd, interval: newModel.repeatInterval)

                            rules.forEach { rule in
                                event.addRecurrenceRule(rule)
                            }
                        } else if freq == .yearly {
                            let rules = createAdaptiveYearlyRecurrenceRule(startDate: newModel.startDate, repeatEnd: repeatEnd, interval: newModel.repeatInterval)

                            rules.forEach { rule in
                                event.addRecurrenceRule(rule)
                            }
                        } else {
                            event.addRecurrenceRule(EKRecurrenceRule(recurrenceWith: freq, interval: newModel.repeatInterval, end: repeatEnd))
                        }

                    case .customWeekly:
                        // 创建自定义每周重复规则
                        let customRule = createWeeklyRecurrenceRule(repeatCustomWeekly: newModel.repeatCustomWeekly, repeatEndDate: newModel.repeatEndDate)
                        event.addRecurrenceRule(customRule)
                    }
                }

                try Shift.shared.eventStore.save(event, span: .futureEvents)
            } catch {
                print(error)
            }
        }
    }

    public static func modifyNotification(origin: EventModel, modified: EventModel, cb: EventBuilder) async {
        guard let eventIdentifier = modified.eventIdentifier,
              let event = Shift.shared.eventStore.event(withIdentifier: eventIdentifier) else {
            if modified.isNotificationEnabled {
                await addNotification(modified)
            }
            return
        }

        updateEventDetails(event, with: modified)
        await updateAlarms(for: event, with: modified)
        await updateRecurrenceRules(for: event, with: modified)

        do {
            try Shift.shared.eventStore.save(event, span: .futureEvents)
            print("保存成功")
        } catch {
            // 打印日志
            Logging.shared.error("Failed to save event changes: \(error.localizedDescription)  modified: \(modified)")
        }
    }

    private static func updateEventDetails(_ event: EKEvent, with model: EventModel) {
        event.startDate = model.startDate
        event.endDate = model.endDate
        event.isAllDay = model.isAllDayEvent
        event.title = model.title
    }

    private static func updateAlarms(for event: EKEvent, with model: EventModel) async {
        // 如果模型中未启用通知，则移除所有现有的闹钟
        guard model.isNotificationEnabled else {
            event.alarms?.forEach(event.removeAlarm)
            return
        }

        // 收集需要设置的新闹钟
        var notifications = [EventNotification]()
        if model.firstNotification != .none {
            notifications.append(model.firstNotification)
        }
        if model.secondNotification != .none {
            notifications.append(model.secondNotification)
        }
        let newAlarms = notifications.map { EKAlarm(relativeOffset: $0.time) }

        // 检查现有闹钟是否与新闹钟相同，如果相同则不进行更新
        if let existingAlarms = event.alarms, Set(newAlarms.map(\.relativeOffset)) == Set(existingAlarms.map(\.relativeOffset)) {
            return // 闹钟无变化
        }

        // 移除所有现有的闹钟并设置新的闹钟
        event.alarms?.forEach(event.removeAlarm)
        newAlarms.forEach(event.addAlarm)
    }

    // 更新事件的重复规则
    private static func updateRecurrenceRules(for event: EKEvent, with model: EventModel) async {
        // 打印日志，表明正在更新重复规则
        print("updateRecurrenceRules")

        // 检查是否启用了重复，并尝试从模型中获取重复频率
        guard model.isRepeatEnabled, let frequency = EKRecurrenceFrequency(rawValue: model.repeatPeriod.rawValue) else {
            // 如果未启用重复或频率无效，则移除所有现有的重复规则
            event.recurrenceRules?.forEach(event.removeRecurrenceRule)
            print("remove all old recurrence rules")
            return
        }

        // 准备一个数组来存储新的重复规则
        var newRules: [EKRecurrenceRule] = []

        // 根据重复类型决定如何创建新的重复规则
        switch model.recurrenceType {
        case .singleCycle:
            // 处理单周期重复
            if frequency == .monthly {
                // 如果是按月重复，创建适应不同月份天数的重复规则
                newRules = createAdaptiveMonthlyRecurrenceRule(startDate: model.startDate, repeatEnd: model.repeatEndDate.map(EKRecurrenceEnd.init), interval: model.repeatInterval)
            } else if frequency == .yearly {
                // 如果是按年重复，创建适应特定年份的重复规则
                newRules = createAdaptiveYearlyRecurrenceRule(startDate: model.startDate, repeatEnd: model.repeatEndDate.map(EKRecurrenceEnd.init), interval: model.repeatInterval)
            } else {
                // 对于其他频率，创建标准的重复规则
                let newRule = EKRecurrenceRule(recurrenceWith: frequency, interval: model.repeatInterval, end: model.repeatEndDate.map(EKRecurrenceEnd.init))
                newRules.append(newRule)
            }

        case .customWeekly:
            // 处理自定义周重复
            let newRule = createWeeklyRecurrenceRule(repeatCustomWeekly: model.repeatCustomWeekly, repeatEndDate: model.repeatEndDate)
            newRules.append(newRule)
        }

        // 移除事件的所有现有重复规则
        event.recurrenceRules?.forEach(event.removeRecurrenceRule)
        print("remove old recurrence rules")

        // 添加所有新的重复规则到事件中
        newRules.forEach { rule in
            event.addRecurrenceRule(rule)
        }
    }

    // 创建一个重复规则
    private static func createWeeklyRecurrenceRule(repeatCustomWeekly: UInt8, repeatEndDate: Date?) -> EKRecurrenceRule {
        // 定义一周的每一天，从周一开始
        let daysOfWeek = [
            EKRecurrenceDayOfWeek(.monday),
            EKRecurrenceDayOfWeek(.tuesday),
            EKRecurrenceDayOfWeek(.wednesday),
            EKRecurrenceDayOfWeek(.thursday),
            EKRecurrenceDayOfWeek(.friday),
            EKRecurrenceDayOfWeek(.saturday),
            EKRecurrenceDayOfWeek(.sunday)
        ]

        // 解析 repeatCustomWeekly 来确定哪些天是活动的
        var activeDays: [EKRecurrenceDayOfWeek] = []
        for i in 0 ..< 7 {
            if (repeatCustomWeekly & (1 << i)) != 0 {
                activeDays.append(daysOfWeek[i])
            }
        }

        // 创建重复规则，每周重复，只在指定的日子重复
        return EKRecurrenceRule(
            recurrenceWith: .weekly, // 周期类型为周重复
            interval: 1, // 每1周重复一次
            daysOfTheWeek: activeDays, // 动态设置重复的日子
            daysOfTheMonth: nil,
            monthsOfTheYear: nil,
            weeksOfTheYear: nil,
            daysOfTheYear: nil,
            setPositions: nil,
            end: repeatEndDate.map(EKRecurrenceEnd.init) // 可以设置结束日期，如果不设置则永久重复
        )
    }

    // 创建一个按月重复，适应不同月份天数的重复规则
    private static func createAdaptiveMonthlyRecurrenceRule(startDate: Date, repeatEnd: EKRecurrenceEnd?, interval: Int) -> [EKRecurrenceRule] {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
        let day = startComponents.day!
        var rules = [EKRecurrenceRule]()

        if day == 29 {
            rules.append(EKRecurrenceRule(
                recurrenceWith: .monthly,
                interval: interval,
                daysOfTheWeek: nil,
                daysOfTheMonth: [28, 29],
                monthsOfTheYear: [2], // 仅在2月
                weeksOfTheYear: nil,
                daysOfTheYear: nil,
                setPositions: [-1], // 指定为每月的最后一天
                end: repeatEnd
            ))
        } else if day == 30 {
            // 为2月添加最后一天重复的规则
            rules.append(EKRecurrenceRule(
                recurrenceWith: .monthly,
                interval: interval,
                daysOfTheWeek: nil,
                daysOfTheMonth: [29, 30],
                monthsOfTheYear: [2], // 仅在2月
                weeksOfTheYear: nil,
                daysOfTheYear: nil,
                setPositions: [-1], // 指定为每月的最后一天
                end: repeatEnd
            ))
        } else if day == 31 {
            // 为所有月份添加最后一天重复的规则
            rules.append(EKRecurrenceRule(
                recurrenceWith: .monthly,
                interval: interval,
                daysOfTheWeek: nil,
                daysOfTheMonth: [28, 29, 30, 31],
                monthsOfTheYear: nil,
                weeksOfTheYear: nil,
                daysOfTheYear: nil,
                setPositions: [-1],
                end: repeatEnd
            ))
        } else {
            // 创建一个普通的按月重复规则
            rules.append(EKRecurrenceRule(
                recurrenceWith: .monthly,
                interval: interval,
                end: repeatEnd
            ))
        }

        return rules
    }

    static func createAdaptiveYearlyRecurrenceRule(startDate: Date, repeatEnd: EKRecurrenceEnd?, interval: Int) -> [EKRecurrenceRule] {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
        let month = startComponents.month
        let day = startComponents.day!

        var rules = [EKRecurrenceRule]()

        if month == 2 && day == 29 {
            rules.append(EKRecurrenceRule(
                recurrenceWith: .yearly, // 每年重复
                interval: interval, // 每1年重复一次
                daysOfTheWeek: nil,
                daysOfTheMonth: [28, 29],
                monthsOfTheYear: [2], // 仅在2月
                weeksOfTheYear: nil,
                daysOfTheYear: nil,
                setPositions: [-1], // 指定为每月的最后一天
                end: repeatEnd // 可以设置结束日期，如果不设置则永久重复
            ))
        } else {
            rules.append(EKRecurrenceRule(
                recurrenceWith: .yearly, // 每年重复
                interval: interval, // 每1年重复一次
                end: repeatEnd // 可以设置结束日期，如果不设置则永久重复
            ))
        }

        return rules
    }
}
