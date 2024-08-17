//
//  EventInfoProvider.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/14.
//

import Foundation

protocol EventInfoProvider {
    var id: UUID { get set }
    var widgetTitle: String { get }
    var eventTitle: String { get }
    var endDate: Date { get }
    var nextStartDate: Date { get }
    var nextEndDate: Date { get }
    var daysUntilNextStart: Int { get }
}
