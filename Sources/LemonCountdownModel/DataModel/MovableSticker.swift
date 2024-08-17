//
//  File.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation
// import LemonUtils
import SwiftMovable

class MovableSticker: MovableObject, Hashable, CustomStringConvertible {
    var stickerName: String

    enum CodingKeys: String, CodingKey {
        case stickerName
    }

    init(stickerName: String, pos: CGPoint = .zero) {
        self.stickerName = stickerName
        super.init(pos: pos)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stickerName = try container.decode(String.self, forKey: .stickerName)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stickerName, forKey: .stickerName)
        try super.encode(to: encoder)
    }

    var description: String {
        return "MovableSticker(name: \(stickerName))"
    }

    static func == (lhs: MovableSticker, rhs: MovableSticker) -> Bool {
        return lhs.id == rhs.id && lhs.pos == rhs.pos && lhs.rotationDegree == rhs.rotationDegree && lhs.zIndex == rhs.zIndex
//        && lhs.scale == rhs.scale
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(pos.x)
        hasher.combine(pos.y)
        hasher.combine(rotationDegree)
        hasher.combine(zIndex)
//        hasher.combine(scale)
    }
}

extension MovableSticker {
    public func deepCopy() -> MovableSticker {
        let copy = MovableSticker(stickerName: stickerName, pos: pos)
        copy.id = UUID() // UUID 是结构体，自动进行值拷贝
        copy.offset = offset // CGPoint 是结构体，自动进行值拷贝
        copy.rotationDegree = rotationDegree // CGFloat 是基本数据类型，自动进行值拷贝
        copy.zIndex = zIndex // Double 是基本数据类型，自动进行值拷贝
//        copy.scale = scale // CGFloat 是基本数据类型，自动进行值拷贝

        return copy
    }
}
