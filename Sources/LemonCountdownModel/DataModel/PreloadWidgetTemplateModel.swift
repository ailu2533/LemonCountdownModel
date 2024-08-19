//
//  PreloadWidgetTemplateModel.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/28.
//

import Foundation
import SwiftData

@MainActor
public func preloadWidgetTemplateModel(modelContext: ModelContext, templateTitle: String, templateDataPath: String, size: WidgetSize) {
    // 从 本地mediumTemplateModel.json中读取数据，然后存入数据库中
    let builtin = DataModelType.builtin.rawValue
    do {
        let fetchDescriptor = FetchDescriptor<WidgetTemplateModel>(predicate: #Predicate {
            $0.dataModelType == builtin && $0.title == templateTitle
        })
        let count = try modelContext.fetchCount(fetchDescriptor)

        if count > 0 {
            return
        }

        guard let fileURL = Bundle.main.url(forResource: templateDataPath, withExtension: nil) else {
            return
        }

        let data = try Data(contentsOf: fileURL)
        guard let jsonData = String(data: data, encoding: .utf8) else {
            return
        }

        let widgetTemplateModel = WidgetTemplateModel(title: templateTitle, jsonData: jsonData, size: size, templateKind: .baseTemplate, event: nil, eventBackup: nil)
        widgetTemplateModel.dataModelType = builtin

        modelContext.insert(widgetTemplateModel)
    } catch {
        Logging.shared.error("Error loading or inserting template data: \(error)")
    }
}
