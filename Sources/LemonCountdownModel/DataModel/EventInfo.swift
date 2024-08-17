//
//  EventInfo.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation
import SwiftMovable
import SwiftUI
import ColorKit

struct FontNameAndSize {
    let fontName: String
    let fontSize: CGFloat
}

func getPreferredLocale() -> Locale {
    guard let preferredIdentifier = Locale.preferredLanguages.first else {
        return Locale.current
    }
    return Locale(identifier: preferredIdentifier)
}

// 关于事件的信息
enum EventInfoKind: Int, Codable, CaseIterable {
    // 距离事件开始还有多少天
    case daysUntilEvent
    // 事件已经过去多少天
    case daysSinceEvent
    // 距离事件开始还有多久
    case timeUntilEventStart
    // 距离事件结束还有多久
    case timeUntilEventEnd
    // 事件目标日期
    case eventStartDate
    // 事件标题
    case eventTitle
    // 今天星期几
    case currentWeekDay

    var description: LocalizedStringKey {
        switch self {
        case .daysUntilEvent: return "距离目标日期还有多少天"
        case .eventStartDate: return "目标日期"
        case .eventTitle: return "标题"
        case .currentWeekDay: return "今天星期几"
        case .daysSinceEvent: return "已经过去多少天"
        case .timeUntilEventStart: return "距离开始时间还有多久"
        case .timeUntilEventEnd: return "距离结束时间还有多久"
        }
    }

    // 根据阶段返回可用的 case
    static func getAvailableCasesFor(kind: PhaseTimeKind) -> [EventInfoKind] {
        switch kind {
        case .taskStartDateBefore:
            return [.daysUntilEvent, .eventStartDate, .eventTitle, .currentWeekDay]
        case .taskStartDateAndStartTimeDuring:
            return [.eventStartDate, .eventTitle, .currentWeekDay, .timeUntilEventStart]
        case .taskStartTimeAndEndTimeDuring:
            return [.eventStartDate, .eventTitle, .currentWeekDay, .timeUntilEventEnd]
        case .endTimeAndTaskEndDateDuring:
            return [.eventStartDate, .eventTitle, .currentWeekDay]
        case .taskEndDateAfter:
            return [.eventStartDate, .eventTitle, .currentWeekDay, .daysSinceEvent]
        }
    }

    var defaultFont: FontNameAndSize {
        switch self {
        case .daysUntilEvent:
            return FontNameAndSize(fontName: "", fontSize: 0)
        case .timeUntilEventStart:
            return FontNameAndSize(fontName: "", fontSize: 0)

        case .timeUntilEventEnd:
            return FontNameAndSize(fontName: "", fontSize: 0)

        case .eventStartDate:
            return FontNameAndSize(fontName: "", fontSize: 0)

        case .eventTitle:
            return FontNameAndSize(fontName: "", fontSize: 0)

        case .currentWeekDay:
            return FontNameAndSize(fontName: "", fontSize: 0)

        case .daysSinceEvent:
            return FontNameAndSize(fontName: "", fontSize: 0)
        }
    }
}

extension EventInfoKind: Identifiable {
    var id: Self { self }
}

@Observable
class EventInfo: MovableObject, Hashable {
    static func == (lhs: EventInfo, rhs: EventInfo) -> Bool {
        return lhs.id == rhs.id && lhs.pos == rhs.pos && lhs.rotationDegree == rhs.rotationDegree && lhs.zIndex == rhs.zIndex
//        && lhs.scale == rhs.scale
    }

    var eventInfoType: EventInfoKind

//    private var dateFormatPrefixPadding: String?

    var fontName: String?
    var fontSize: CGFloat = 20.0
    var colorHex = "#2f261e"

    var color: Color {

        return Color(uiColor: UIColor(hex: colorHex) ?? .clear)
    }

    @ObservationIgnored private var eventInfoProvider: EventInfoProvider?

    func setEventInfoProvider(_ eventInfoProvider: EventInfoProvider?) {
        self.eventInfoProvider = eventInfoProvider
    }

    func getEventInfoProvider() -> EventInfoProvider? {
        eventInfoProvider
    }

    enum CodingKeys: String, CodingKey {
        case eventInfoType, event, fontName, fontSize, colorHex
    }

    init(eventInfo: EventInfoKind,
         eventInfoProvider: EventInfoProvider?,
         position: CGPoint = .zero,
         colorHex: String = "#2f261e",
         rotationDegree: CGFloat = .zero,
         fontName: String? = nil,
         fontSize: CGFloat = 20.0) {
        eventInfoType = eventInfo
        self.eventInfoProvider = eventInfoProvider
        self.fontName = fontName
        self.fontSize = fontSize
        self.colorHex = colorHex
        super.init(pos: position, rotationDegree: rotationDegree)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventInfoType = try container.decode(EventInfoKind.self, forKey: .eventInfoType)
        fontName = try container.decodeIfPresent(String.self, forKey: .fontName)
        fontSize = try container.decode(CGFloat.self, forKey: .fontSize)
        colorHex = try container.decode(String.self, forKey: .colorHex)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventInfoType, forKey: .eventInfoType)
        try container.encodeIfPresent(fontName, forKey: .fontName)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(colorHex, forKey: .colorHex)
        try super.encode(to: encoder)
    }
}

extension EventInfo {
    func deepCopy() -> EventInfo {
        let copy = EventInfo(eventInfo: eventInfoType, eventInfoProvider: eventInfoProvider)
        copy.id = UUID() // UUID 是结构体，自动进行值拷贝
        copy.pos = pos // CGPoint 是结构体，自动进行值拷贝
        copy.offset = offset // CGPoint 是结构体，自动进行值拷贝
        copy.rotationDegree = rotationDegree // CGFloat 是基本数据类型，自动进行值拷贝
        copy.zIndex = zIndex // Double 是基本数据类型，自动进行值拷贝
//        copy.scale = scale // CGFloat 是基本数据类型，自动进行值拷贝

        // EventInfo specific properties
//        copy.event = event // 这里假设 EventInfoProvider 是不可变的或不需要深拷贝
        copy.fontName = fontName // Optional<String> 也是值类型，自动进行值拷贝
        copy.fontSize = fontSize // CGFloat 是基本数据类型，自动进行值拷贝
        copy.colorHex = colorHex // String 是值类型，自动进行值拷贝
//        copy.dateFormatPrefixPadding = dateFormatPrefixPadding // Optional<String> 也是值类型，自动进行值拷贝

        return copy
    }
}

extension EventInfo: CustomStringConvertible {
    var description: String {
        return "\(eventInfoType.description) fontSize: \(fontSize)"
    }
}
