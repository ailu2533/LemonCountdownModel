//
//  PhaseTimeRule.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/10.
//

import Foundation
import LemonDateUtils
// import LemonUtils
import SwiftUI

public enum PhaseTimeKind: Int, Codable, CaseIterable, Comparable, Identifiable {
    // 事件开始日期前
    // 事件开始日期和事件开始具体时间之间
    // 事件中 任务开始具体时间和事件结束具体时间 之间
    // 事件结束具体时间和事件结束日期之间
    // 事件结束日期之后

    case taskStartDateBefore = 1
    case taskStartDateAndStartTimeDuring = 2
    case taskStartTimeAndEndTimeDuring = 3
    case endTimeAndTaskEndDateDuring = 4
    case taskEndDateAfter = 5

    public var id: Int {
        return rawValue
    }

    public var text: String {
        switch self {
        case .taskStartDateBefore:
            String(localized: "事件开始日期前")
        case .taskStartDateAndStartTimeDuring:
            String(localized: "事件开始当天, 开始时间之前")
        case .taskStartTimeAndEndTimeDuring:
            String(localized: "事件进行中")
        case .endTimeAndTaskEndDateDuring:
            String(localized: "事件结束当天, 结束时间之后")
        case .taskEndDateAfter:
            String(localized: "事件结束日期后")
        }
    }

    public static func < (lhs: PhaseTimeKind, rhs: PhaseTimeKind) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

public struct PhaseTimeRule: Codable, Hashable {
    public var phaseTimeKind: PhaseTimeKind
    // 只有kind 是 taskStartTimeAndEndTimeDuring 时，beginTimeOffset 和 endTimeOffset，weekday 才有效
    public var beginTimeOffset: TimeInterval {
        beginTimeOffset_.toTimeInterval()
    }

    public var endTimeOffset: TimeInterval {
        endTimeOffset_.toTimeInterval()
    }

    public var beginTimeOffset_ = TimeOffset()
    public var endTimeOffset_ = TimeOffset()
    public var weekday: Int?
}

extension PhaseTimeRule: Comparable {
    public static func < (lhs: PhaseTimeRule, rhs: PhaseTimeRule) -> Bool {
        if lhs.phaseTimeKind != rhs.phaseTimeKind {
            return lhs.phaseTimeKind < rhs.phaseTimeKind
        }
        return lhs.beginTimeOffset < rhs.beginTimeOffset
    }
}

// 根据当前时间和任务开始日期和结束日期和 PhaseTimeRule 计算当前时间是否在 beginTimeOffset 和 endTimeOffset 之间
func isCurrentTimeWithinPhase(currentTime: Date, phaseTimeRule: PhaseTimeRule, taskStartTime: Date, taskEndTime: Date) -> Bool {
    // 首先根据 currentTime 和 taskStartTime 计算当前时间的 kind
    let taskStartDate = taskStartTime.adjust(for: .startOfDay)!
    if currentTime < taskStartDate {
        return phaseTimeRule.phaseTimeKind == .taskStartDateBefore
    }
    let taskEndDate = taskEndTime.adjust(for: .startOfDay)!
    if currentTime > taskEndDate {
        return phaseTimeRule.phaseTimeKind == .taskEndDateAfter
    }
    if currentTime >= taskStartDate && currentTime < taskStartTime {
        return phaseTimeRule.phaseTimeKind == .taskStartDateAndStartTimeDuring
    }
    if currentTime >= taskStartTime && currentTime < taskEndTime {
        let effectiveStart = taskStartTime.addingTimeInterval(phaseTimeRule.beginTimeOffset)
        let effectiveEnd = taskStartTime.addingTimeInterval(phaseTimeRule.endTimeOffset)
        return currentTime >= effectiveStart && currentTime <= effectiveEnd
    }
    if currentTime >= taskEndTime && currentTime <= taskEndDate {
        return phaseTimeRule.phaseTimeKind == .endTimeAndTaskEndDateDuring
    }
    return false
}
