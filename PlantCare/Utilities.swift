//
//  Utilities.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-23.
//

import Foundation

func getDateString(date: Date) -> String {
    return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
}

