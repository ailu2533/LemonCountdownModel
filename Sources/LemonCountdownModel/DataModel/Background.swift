//
//  Background.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/27.
//

import Foundation
// import LemonUtils
import SwiftUI

public enum BackgroundKind: Int, CaseIterable, Codable, Identifiable {
    case linearGredient
    case morandiColors
    case macaronColors

//    case image

    public var id: Self {
        self
    }

    var text: LocalizedStringKey {
        switch self {
        case .morandiColors:
            return "莫兰迪色"
        case .macaronColors:
            return "马卡龙色"
        case .linearGredient:
            return "渐变色"
        }
    }
}

@Observable
public final class Background: Identifiable, Codable {
    public var id = UUID()
    public var kind: BackgroundKind
    public var backgroundColor: String?
    public var backgroundImage: String?
    public var linearGradient: [String]?

    enum CodingKeys: String, CodingKey {
        case id, kind, backgroundColor, backgroundImage, linearGradient
    }

    public init(kind: BackgroundKind = .macaronColors, backgroundColor: String? = ColorSets.morandiColors.first!, backgroundImage: String? = nil, linearGradient: [String]? = nil) {
        self.kind = kind
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.linearGradient = linearGradient
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        kind = try container.decode(BackgroundKind.self, forKey: .kind)
        backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        backgroundImage = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
        linearGradient = try container.decodeIfPresent([String].self, forKey: .linearGradient)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(kind, forKey: .kind)
        try container.encodeIfPresent(backgroundColor, forKey: .backgroundColor)
        try container.encodeIfPresent(backgroundImage, forKey: .backgroundImage)
        try container.encodeIfPresent(linearGradient, forKey: .linearGradient)
    }

    var gradient: LinearGradient {
        if kind == .linearGredient, let linearGradient, !linearGradient.isEmpty {
            return colorHexArrToLinearGredient(arr: linearGradient)
        }
        return LinearGradient(colors: [Color.blue, Color.cyan], startPoint: .topLeading, endPoint: .topTrailing)
    }

    func colorHexArrToLinearGredient(arr: [String]) -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: arr.map { Color(uiColor: UIColor(hex: $0) ?? .clear) }), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    @ViewBuilder
    public func backgroundView(widgetSize: CGSize) -> some View {
        switch kind {
        case .morandiColors, .macaronColors:
            if let backgroundColor {
                Color(uiColor: UIColor(hex: backgroundColor) ?? .clear)
            }
        case .linearGredient:
            if let linearGradient, !linearGradient.isEmpty {
                colorHexArrToLinearGredient(arr: linearGradient)
            }
        }
    }
}

extension Background: Hashable {
    public static func == (lhs: Background, rhs: Background) -> Bool {
        return lhs.id == rhs.id &&
            lhs.kind == rhs.kind &&
            lhs.backgroundColor == rhs.backgroundColor &&
            lhs.backgroundImage == rhs.backgroundImage &&
            lhs.linearGradient == rhs.linearGradient
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(kind)
        hasher.combine(backgroundColor)
        hasher.combine(backgroundImage)
        hasher.combine(linearGradient)
    }
}

extension Background {
    public func deepCopy() -> Background {
        return Background(kind: kind, backgroundColor: backgroundColor, backgroundImage: backgroundImage, linearGradient: linearGradient != nil ? Array(linearGradient!) : nil)
    }
}
