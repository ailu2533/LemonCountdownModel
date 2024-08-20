//
//  File.swift
//
//
//  Created by Lu Ai on 2024/8/20.
//

import ColorKit
import Foundation
import SwiftUI
import SwiftMovable

extension TextItem: Stylable {
    public var editable: Bool {
        true
    }
}

// extension TextItem: Stylable {
// }

@Observable
public final class TextItem: MovableObject, Hashable {
    public var text: String
    public var fontName: String?
    public var fontSize: CGFloat = 20.0
    public var colorHex: String = "#FFFFFF"

//    public var color: Color {
//        Color(hex: colorHex) ?? Color.clear
//    }

    enum CodingKeys: String, CodingKey {
        case text
        case colorHex
        case fontName
        case fontSize
    }

    public init(text: String, pos: CGPoint = .zero, colorHex: String = "#FFFFFF", fontName: String? = nil, fontSize: CGFloat = 20, rotationDegree: CGFloat = .zero) {
        self.text = text
        if let fontName {
            self.fontName = fontName
        }
        self.fontSize = fontSize
        self.colorHex = colorHex
        super.init(pos: pos, rotationDegree: rotationDegree)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        colorHex = try container.decode(String.self, forKey: .colorHex)
        fontName = try container.decodeIfPresent(String.self, forKey: .fontName)
        fontSize = try container.decode(CGFloat.self, forKey: .fontSize)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(colorHex, forKey: .colorHex)
        try container.encodeIfPresent(fontName, forKey: .fontName)
        try container.encode(fontSize, forKey: .fontSize)
        try super.encode(to: encoder)
    }

    public static func == (lhs: TextItem, rhs: TextItem) -> Bool {
        return lhs.text == rhs.text &&
            lhs.colorHex == rhs.colorHex &&
            lhs.fontName == rhs.fontName &&
            lhs.fontSize == rhs.fontSize
    }

    @ViewBuilder
    public func view() -> some View {
        Text(text)
            .foregroundStyle(Color(uiColor: UIColor(hex: colorHex) ?? .black))
            .font(fontName == nil ? .system(size: fontSize) : .custom(fontName!, size: fontSize))
    }
}

extension TextItem {
    public func deepCopy() -> TextItem {
        let copy = TextItem(text: text, pos: pos, rotationDegree: rotationDegree)
        copy.id = id // UUID 是结构体，自动进行值拷贝
        copy.pos = pos // CGPoint 是结构体，自动进行值拷贝
        copy.offset = offset // CGPoint 是结构体，自动进行值拷贝
        copy.rotationDegree = rotationDegree // CGFloat 是基本数据类型，自动进行值拷贝
        copy.zIndex = zIndex // Double 是基本数据类型，自动进行值拷贝
//        copy.scale = scale // CGFloat 是基本数据类型，自动进行值拷贝

        // TextItem specific properties
        copy.text = text // String 是值类型，自动进行值拷贝
        copy.fontName = fontName // Optional<String> 也是值类型，自动进行值拷贝
        copy.fontSize = fontSize // CGFloat 是基本数据类型，自动进行值拷贝
        copy.colorHex = colorHex // String 是值类型，自动进行值拷贝

        return copy
    }
}
