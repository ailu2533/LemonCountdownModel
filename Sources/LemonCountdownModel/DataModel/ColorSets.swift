//
//  File.swift
//
//
//  Created by ailu on 2024/4/18.
//

import Foundation
import UIKit

// 通用色彩集
public struct ColorSets {
    // 彩虹色
    public static let rainbow = [
        "#ffb3ba",
        "#ffdfba",
        "#ffffba",
        "#baffc9",
        "#bae1ff",
        "#130c0e",
        "#F8F8FF",
        "#DC143C"
    ]

    // 莫兰迪色
    public static let morandiColors = [
        "#FFFDF0", "#D3D2D0", "#E6D6D9", "#BFEF9A", "#FEECD8", "#F4D1D7", "#16E6E2", "#72CEDC", "#686789", "#CFD3A9", "#E8D3C0", "#AEA9A6", "#9AA690", "#9FABB9", "#91A0A5", "#88878D", "#99857E", "#7D7465", "#B4746B", "#AB545A", "#676662", "#724E52", "#BCA295", "#CEB797", "#9A7549", "#BCA289", "#D89C7A", "#D6C38B", "#849B91", "#D4BAAD", "#B77F70", "#E1CCAF", "#B0B1B6", "#979771", "#91ADB6", "#A79A89", "#8A95A9", "#B57C82"]

    // 24 节气
    // 立春
    // 黄白游 255 247 153
    // 松花 255 238 111
    // 236 212 82
    // 苍黄 182 160 146

    // macaron 马卡龙色系
    public static let macaronColors = [
        "#C4EBF0",
        "#D7D2B4", "#D5B87C",
        "#FB6571", "#EDCFB3",
        "#F4B0A5",
        "#1FC6B2", "#B8F0D3",
        "#94CCC3", "#A8EFE9",
        "#928AD3", "#E4C994",
        "#DD8DB0", "#A2BFE1",
        "#D8979B", "#CBDF9A",
        "#D194A3", "#DC95BF",
        "#D6E19C", "#C199E0",
        "#A0D0DC", "#D9939B",
        "#D7B399", "#B2D1D3",
        "#DA949C"
    ]

    // 彩虹色
    public static let textColors = [
//        "#ffb3ba",
//        "#ffdfba",
//        "#ffffba",
//        "#baffc9",
//        "#bae1ff",
//        "#130c0e",
//        "#F8F8FF",

        "#2f261e",
        "#ffffff",
        "#ae2121",
        "#ffff00",
        "#00bfff",
        "#088743",
        "#876c94",
        "#ff7e38"
    ]
}

public struct CommonColors {
    public static let colorHexStrings: [String: String] = [
        // 基本颜色
        "black": "#000000",
        "white": "#FFFFFF",
        "red": "#FF0000",
        "green": "#00FF00",
        "blue": "#0000FF",
        "yellow": "#FFFF00",
        "cyan": "#00FFFF",
        "magenta": "#FF00FF",

        // 灰度
        "lightGray": "#D3D3D3",
        "gray": "#808080",
        "darkGray": "#A9A9A9",

        // 暖色调
        "orange": "#FFA500",
        "coral": "#FF7F50",
        "pink": "#FFC0CB",
        "salmon": "#FA8072",
        "gold": "#FFD700",

        // 冷色调
        "skyBlue": "#87CEEB",
        "turquoise": "#40E0D0",
        "indigo": "#4B0082",
        "violet": "#EE82EE",
        "lavender": "#E6E6FA",

        // 自然色
        "brown": "#A52A2A",
        "tan": "#D2B48C",
        "olive": "#808000",
        "forestGreen": "#228B22",
        "seaGreen": "#2E8B57",

        // 柔和色
        "beige": "#F5F5DC",
        "ivory": "#FFFFF0",
        "mintCream": "#F5FFFA",
        "mistyRose": "#FFE4E1",
        "lavenderBlush": "#FFF0F5",

        // 深色
        "maroon": "#800000",
        "navy": "#000080",
        "purple": "#800080",
        "teal": "#008080",

        // 亮色
        "lime": "#00FF00",
        "aqua": "#00FFFF",
        "fuchsia": "#FF00FF",

        // 其他常用色
        "silver": "#C0C0C0",
        "khaki": "#F0E68C",
        "plum": "#DDA0DD",
        "crimson": "#DC143C",
        "royalBlue": "#4169E1"
    ]

    static func getHexString(for colorName: String) -> String? {
        return colorHexStrings[colorName.lowercased()]
    }
}
