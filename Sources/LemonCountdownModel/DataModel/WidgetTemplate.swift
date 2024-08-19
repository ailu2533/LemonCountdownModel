//
//  WidgetTemplate.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation

@Observable
public class WidgetTemplate: Identifiable, Codable {
    public var id = UUID()

    @ObservationIgnored private var widgetTempletModel: WidgetTemplateModel?

    public func setWidgetTemplateModel(_ widgetTemplatemodel: WidgetTemplateModel) {
        widgetTempletModel = widgetTemplatemodel
        if widgetTemplatemodel.templateKind == WidgetTemplateKind.widgetInstance.rawValue {
            phases.forEach { $0.setEventInfoProvider(widgetTemplatemodel.eventBackup) }
            phasesBeforeStartDate.forEach { $0.setEventInfoProvider(widgetTemplatemodel.eventBackup) }
            phasesAfterStartDate.forEach { $0.setEventInfoProvider(widgetTemplatemodel.eventBackup) }
            phasesBetweenStartAndStartTime.forEach { $0.setEventInfoProvider(widgetTemplatemodel.eventBackup) }
            phasesBetweenEndTimeAndEndDate.forEach { $0.setEventInfoProvider(widgetTemplatemodel.eventBackup) }
        }
    }

    public func getWidgetTemplateModel() -> WidgetTemplateModel? {
        if widgetTempletModel == nil {
            fatalError()
        }

        return widgetTempletModel
    }

    public func deleteWidgetPhase(_ phase: WidgetPhase) {
        phases.removeAll { $0.id == phase.id }

        phases.last?.phaseTimeRule.endTimeOffset_.isMax = true

//        phasesBeforeStartDate.removeAll { $0.id == phase.id }
//        phasesAfterStartDate.removeAll { $0.id == phase.id }
//        phasesBetweenStartAndStartTime.removeAll { $0.id == phase.id }
//        phasesBetweenEndTimeAndEndDate.removeAll { $0.id == phase.id }
    }

    // check  whether phase can be deleted
    public func checkCanBeDeleted(phase: WidgetPhase) -> Bool {
        switch phase.kind {
        case .taskStartDateBefore:
            return phasesBeforeStartDate.count > 1
        case .taskStartDateAndStartTimeDuring:
            return phasesBetweenStartAndStartTime.count > 1
        case .taskStartTimeAndEndTimeDuring:
            return phases.count > 1
        case .endTimeAndTaskEndDateDuring:
            return phasesBetweenEndTimeAndEndDate.count > 1
        case .taskEndDateAfter:
            return phasesAfterStartDate.count > 1
        }
    }

    // TODO:
    public let size = WidgetSize.small

    public var background: String
    // 开始时间和结束时间的阶段
    public var phases: [WidgetPhase] = []
    // 开始日期之前的阶段
    public var phasesBeforeStartDate: [WidgetPhase] = []
    // 开始日期之后的阶段
    public var phasesAfterStartDate: [WidgetPhase] = []
    // 开始日期和开始时间之间的阶段
    public var phasesBetweenStartAndStartTime: [WidgetPhase] = []
    // 结束时间和结束日期之间的阶段
    public var phasesBetweenEndTimeAndEndDate: [WidgetPhase] = []

    enum CodingKeys: String, CodingKey {
        case widgetTempletModel, background, phases, phasesBeforeStartDate, phasesAfterStartDate, phasesBetweenStartAndStartTime, phasesBetweenEndTimeAndEndDate
    }

    public init(phases: [WidgetPhase] = [], background: String = "#efeeef") {
        self.phases = phases
        self.background = background

        Logging.openUrl.debug("init WidgetTemplate: \(background) phases: \(phases.debugDescription)")
    }

    public func updateFromModel(_ model: WidgetTemplateModel) {
        let wt = model.toWidgetTemplate()
        background = wt.background
        phases = wt.phases
        phasesAfterStartDate = wt.phasesAfterStartDate
        phasesBeforeStartDate = wt.phasesBeforeStartDate
        phasesBetweenStartAndStartTime = wt.phasesBetweenStartAndStartTime
        phasesBetweenEndTimeAndEndDate = wt.phasesBetweenEndTimeAndEndDate
        setWidgetTemplateModel(model)
//        self.objectWillChange.send()
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        background = try container.decode(String.self, forKey: .background)
        phases = try container.decode([WidgetPhase].self, forKey: .phases)
        phasesBeforeStartDate = try container.decode([WidgetPhase].self, forKey: .phasesBeforeStartDate)
        phasesAfterStartDate = try container.decode([WidgetPhase].self, forKey: .phasesAfterStartDate)
        phasesBetweenStartAndStartTime = try container.decode([WidgetPhase].self, forKey: .phasesBetweenStartAndStartTime)
        phasesBetweenEndTimeAndEndDate = try container.decode([WidgetPhase].self, forKey: .phasesBetweenEndTimeAndEndDate)

//        phases.forEach { $0.parentWidgetTemplate = self }
//        phasesBeforeStartDate.forEach { $0.parentWidgetTemplate = self }
//        phasesAfterStartDate.forEach { $0.parentWidgetTemplate = self }
//        phasesBetweenStartAndStartTime.forEach { $0.parentWidgetTemplate = self }
//        phasesBetweenEndTimeAndEndDate.forEach { $0.parentWidgetTemplate = self }

//        Logging.eventInfo.debug("phase \(phases[0].description)")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(background, forKey: .background)
        try container.encode(phases, forKey: .phases)
        try container.encode(phasesBeforeStartDate, forKey: .phasesBeforeStartDate)
        try container.encode(phasesAfterStartDate, forKey: .phasesAfterStartDate)
        try container.encode(phasesBetweenStartAndStartTime, forKey: .phasesBetweenStartAndStartTime)
        try container.encode(phasesBetweenEndTimeAndEndDate, forKey: .phasesBetweenEndTimeAndEndDate)
    }

    deinit {
        Logging.widgetPreview.debug("WidgetTemplate deinit")
    }
}

extension WidgetTemplate: Hashable {
    public static func == (lhs: WidgetTemplate, rhs: WidgetTemplate) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(phases)
        hasher.combine(background)
        hasher.combine(phasesBeforeStartDate)
        hasher.combine(phasesAfterStartDate)
        hasher.combine(phasesBetweenStartAndStartTime)
        hasher.combine(phasesBetweenEndTimeAndEndDate)
        if let model = widgetTempletModel {
            hasher.combine(model)
        }
    }
}
