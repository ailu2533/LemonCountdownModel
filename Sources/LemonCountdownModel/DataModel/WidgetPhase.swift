//
//  WidgetPhase.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation
import LemonDateUtils
// import LemonUtils
import SwiftMovable
import SwiftUI

@Observable
public class WidgetPhase: Identifiable, Codable {
    public var id = UUID()

    // 出现的时间
    public var timeOffset = TimeOffset()
    public var phaseTimeRule = PhaseTimeRule(phaseTimeKind: .taskStartDateBefore)

    // 时机
    public var kind: PhaseTimeKind = .taskStartDateBefore

    // 画面相关数据
    public var stickers: [MovableSticker] = []
    public var texts: [TextItem] = []
    public var eventInfo: [EventInfo] = []
    public var background = Background()

    // 绑定的事件
    @ObservationIgnored private var eventInfoProvider: EventInfoProvider?

    public func setEventInfoProvider(_ eventInfoProvider: EventInfoProvider?) {
        self.eventInfoProvider = eventInfoProvider
        eventInfo.forEach {
            $0.setEventInfoProvider(eventInfoProvider)
        }
    }

    public func getEventInfoProvider() -> EventInfoProvider? {
        eventInfoProvider
    }

    @ObservationIgnored var canBeDeleted = false

    enum CodingKeys: String, CodingKey {
        case id, phaseTimeRule, stickers, texts, eventInfo, background, kind
    }

    public init(kind: PhaseTimeKind, eventInfoProvider: EventInfoProvider?, stickers: [MovableSticker] = [], texts: [TextItem] = [], eventInfo: [EventInfo] = [], background: Background = Background()) {
        self.stickers = stickers
        self.texts = texts
        self.eventInfo = eventInfo
        self.background = background
        self.kind = kind

        eventInfo.forEach {
            $0.setEventInfoProvider(eventInfoProvider)
        }
        self.eventInfoProvider = eventInfoProvider
    }

    enum DecodingError: Error {
        case missingMandatoryField(String)
        case dataCorruption(String)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try container.decode(UUID.self, forKey: .id)
            phaseTimeRule = try container.decode(PhaseTimeRule.self, forKey: .phaseTimeRule)
            stickers = try container.decode([MovableSticker].self, forKey: .stickers)
            texts = try container.decode([TextItem].self, forKey: .texts)
            eventInfo = try container.decode([EventInfo].self, forKey: .eventInfo)
            background = try container.decode(Background.self, forKey: .background)
            kind = try container.decode(PhaseTimeKind.self, forKey: .kind)
        } catch {
            throw error
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)
            try container.encode(phaseTimeRule, forKey: .phaseTimeRule)
            try container.encode(stickers, forKey: .stickers)
            try container.encode(texts, forKey: .texts)
            try container.encode(eventInfo, forKey: .eventInfo)
            try container.encode(background, forKey: .background)
            try container.encode(kind, forKey: .kind)
        } catch {
            throw error // You can also customize this to throw more specific errors
        }
    }

    func bindEvent(_ event: EventInfoProvider) {
        eventInfoProvider = event

        eventInfo.forEach {
            $0.setEventInfoProvider(event)
        }
    }
}

extension WidgetPhase: Hashable {
    public static func == (lhs: WidgetPhase, rhs: WidgetPhase) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(stickers)
        hasher.combine(texts)
        hasher.combine(phaseTimeRule)
        hasher.combine(eventInfo)
        hasher.combine(background)
    }
}

extension WidgetPhase: CustomStringConvertible {
    public var description: String {
        return """
        WidgetPhase(
        id: \(id),
        timeOffset: \(timeOffset),
        phaseTimeRule: \(phaseTimeRule),
        kind: \(kind),
        eventInfo: \(eventInfo.map { $0.description }.joined(separator: ", ")),
        )
        """
    }
}

extension WidgetPhase {
    func deepCopy() -> WidgetPhase {
        let copy = WidgetPhase(kind: kind, eventInfoProvider: eventInfoProvider)
        // import 要生成新的 uuid
        copy.id = UUID() // UUID 是结构体，自动进行值拷贝
        copy.timeOffset = timeOffset // 假设 TimeOffset 也有 deepCopy 方法
        copy.phaseTimeRule = phaseTimeRule // 假设 PhaseTimeRule 有 deepCopy 方法
        copy.kind = kind // 枚举类型，自动进行值拷贝

        // 对于数组和其中的对象，需要进行元素级的深拷贝
        copy.stickers = stickers.map { $0.deepCopy() } // 假设 MovableSticker 有 deepCopy 方法
        copy.texts = texts.map { $0.deepCopy() } // 假设 TextItem 有 deepCopy 方法
        copy.eventInfo = eventInfo.map { $0.deepCopy() } // 假设 EventInfo 有 deepCopy 方法
        copy.background = background.deepCopy() // 假设 Background 有 deepCopy 方法

        return copy
    }
}
