//
//  Settings.swift
//  Factory Model
//
//  Created by Igor Malyarov on 05.11.2020.
//

import SwiftUI

final class Settings: ObservableObject {
    @Published var period: Period = .month()
}
