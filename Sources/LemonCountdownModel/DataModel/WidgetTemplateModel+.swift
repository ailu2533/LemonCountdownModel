//
//  WidgetTemplateModel+.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/6.
//

import Foundation
import LemonDateUtils
// import LemonUtils

extension WidgetTemplateModel {
    static func createWidgetTemplateModel(title: String, size: WidgetSize) -> WidgetTemplateModel {
        let wt = WidgetTemplate()
        let phase = WidgetPhase(kind: .taskStartTimeAndEndTimeDuring, eventInfoProvider: nil)
        phase.phaseTimeRule.endTimeOffset_ = TimeOffset(isMax: true)
        wt.phases.append(phase)
        wt.phasesBeforeStartDate.append(WidgetPhase(kind: .taskStartDateBefore, eventInfoProvider: nil))
        wt.phasesAfterStartDate.append(WidgetPhase(kind: .taskEndDateAfter, eventInfoProvider: nil))
        wt.phasesBetweenStartAndStartTime.append(WidgetPhase(kind: .taskStartDateAndStartTimeDuring, eventInfoProvider: nil))
        wt.phasesBetweenEndTimeAndEndDate.append(WidgetPhase(kind: .endTimeAndTaskEndDateDuring, eventInfoProvider: nil))

        let json = encodeWidgetTemplate(wt)
        return WidgetTemplateModel(title: title, jsonData: json, size: size, event: nil, eventBackup: nil)
    }
}
