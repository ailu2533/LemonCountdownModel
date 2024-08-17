//
//  EventNotification.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation

// 通知类型
enum EventNotification: Int, CaseIterable, Identifiable, Codable {
    case none = 0 // 无提醒
    case start = 1 // 日程开始时
    case inAdvanced5m = 2 // 提前 5 分钟
    case inAdvanced10m = 3 // 提前 10 分钟
    case inAdvanced15m = 4 // 提前 15 分钟
    case inAdvanced25m = 5 // 提前 25 分钟
    case inAdvanced30m = 6 // 提前 30 分钟
    case inAdvanced1h = 7 // 提前 1 小时
    case inAdvanced2h = 8 // 提前 2 小时
    case inAdvanced1d = 9 // 提前 1 天
    case inAdvanced2d = 10 // 提前 2 天
    case inAdvanced1w = 11 // 提前 1 周

    case atDay9AM = 12 // 日程当天 9 点
    case dayBefore9AM = 13 // 前一天 9 点
    case twoDaysBefore9AM = 14 // 前两天 9 点
    case weekBefore9AM = 15 // 前一周 9 点

    var id: Self {
        self
    }

    var time: TimeInterval {
        switch self {
        case .none:
            return 0
        case .start:
            return 0
        case .inAdvanced5m:
            return -5 * 60
        case .inAdvanced10m:
            return -10 * 60
        case .inAdvanced15m:
            return -15 * 60
        case .inAdvanced25m:
            return -25 * 60
        case .inAdvanced30m:
            return -30 * 60
        case .inAdvanced1h:
            return -60 * 60
        case .inAdvanced2h:
            return -2 * 60 * 60
        case .inAdvanced1d:
            return -24 * 60 * 60
        case .inAdvanced2d:
            return -2 * 24 * 60 * 60
        case .inAdvanced1w:
            return -7 * 24 * 60 * 60

        // 这是个指定具体日期和时间的通知，需要单独处理
        // 时间开始时间是当天的 0 点
        case .atDay9AM:
            return 9 * 60 * 60
        case .dayBefore9AM:
            return (-24 + 9) * 60 * 60
        case .twoDaysBefore9AM:
            return (-24 * 2 + 9) * 60 * 60
        case .weekBefore9AM:
            return (-24 * 7 + 9) * 60 * 60
        }
    }

    var text: String {
        switch self {
        case .none:
            return String(localized: "无")
        case .start:
            return String(localized: "事件开始")
        case .inAdvanced5m:
            return String(localized: "提前 5 分钟")
        case .inAdvanced10m:
            return String(localized: "提前 10 分钟")
        case .inAdvanced15m:
            return String(localized: "提前 15 分钟")
        case .inAdvanced25m:
            return String(localized: "提前 25 分钟")
        case .inAdvanced30m:
            return String(localized: "提前 30 分钟")
        case .inAdvanced1h:
            return String(localized: "提前 1 小时")
        case .inAdvanced2h:
            return String(localized: "提前 2 小时")
        case .inAdvanced1d:
            return String(localized: "提前 1 天")
        case .inAdvanced2d:
            return String(localized: "提前 2 天")
        case .inAdvanced1w:
            return String(localized: "提前 1 周")
        case .atDay9AM:
            return String(localized: "日程当天 (09:00)")
        case .dayBefore9AM:
            return String(localized: "1天前 (09:00)")
        case .twoDaysBefore9AM:
            return String(localized: "2天前 (09:00)")
        case .weekBefore9AM:
            return String(localized: "1周前 (09:00)")
        }
    }
}
