//
//  Logging.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/10.
//

import Foundation
import OSLog

class Logging {
    static let shared = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LemonEvent")

    static let widgetPreview = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "widgetPreview")

    static let widget = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "widget")
    // adjustTranslation

    static let eventInfo = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "eventInfo")

    static let adjustTranslation = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "adjustTranslation")

    // MembershipManager

    static let membershipManager = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "MembershipManager")

    static let widgetEntries = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "widgetEntries")

    static let widgetMeta = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "widgetMeta")

    static let provider = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "provider")

    static let bg = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "bg")

    static let openUrl = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "openUrl")
}
