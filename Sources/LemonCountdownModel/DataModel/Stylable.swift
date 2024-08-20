//
//  File.swift
//  
//
//  Created by Lu Ai on 2024/8/20.
//

import Foundation

import Foundation
import SwiftUI

// 定义一个开放的协议 `Stylable`，用于描述具有可样式化文本属性的对象。
// `open` 关键字表示这个协议可以被其他模块中的类或结构体实现和继承。
public protocol Stylable {
    // 文本内容属性，类型为 `String`。
    // `{ get set }` 表示这个属性是可读写的。
    var text: String { get set }

    // 文本颜色属性，类型为 `Color`。
    // `{ get set }` 表示这个属性是可读写的。
    var colorHex: String { get set }

    // 字体名称属性，类型为可选的 `String`。
    // 可选类型（`String?`）表示这个属性可以是一个字符串或者是 `nil`。
    // `{ get set }` 表示这个属性是可读写的。
    var fontName: String? { get set }

    // 字体大小属性，类型为 `CGFloat`。
    // `{ get set }` 表示这个属性是可读写的。
    var fontSize: CGFloat { get set }

    // 可编辑属性，类型为 `Bool`。
    // 表示文本是否可编辑。
    var editable: Bool { get }
}
