//
//  AppMetricaService.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 28.01.2025.
//

import Foundation
import AppMetricaCore

final class AppMetricaService {
    
    func activate() {
        let configuration = AppMetricaConfiguration(apiKey: Constants.apiKey)
        AppMetrica.activate(with: configuration!)
    }
    
    func report(event: AnalyticsModel.Event, screen: AnalyticsModel.Screen, item: AnalyticsModel.Item? = nil ) {
        var eventParams: [String: Any] = ["event": event.rawValue, "screen": screen.rawValue]
        
        if let item = item {
            eventParams["item"] = item.rawValue
        }
        
        AppMetrica.reportEvent(name: event.rawValue, parameters: eventParams, onFailure: { (error) in
            print("DID FAIL TO REPORT EVENT: %@", event)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

extension AppMetricaService {
    enum Constants {
        static let apiKey = "0634b81a-502e-4548-8002-8fd1bf6853ad"
    }
}
