//
//  DataPoint.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import Foundation

struct DataPoint: Identifiable {
    let id = UUID()
    var title: String
    var value: Double
}

struct DataPointWithShare: Identifiable {
    let id = UUID()
    var title: String
    var value: String
    var percentage: String
}

struct DataBlock {
    var icon: String
    var title: String
    var value: String
    var data: [DataPointWithShare]
}

extension DataBlock {
    static var example: DataBlock {
        let value = DataPointWithShare.examples.compactMap { Double($0.value) }.reduce(0, +)
        
        return DataBlock(
            icon: "dial.max",
            title: "title",
            value: value.formattedGrouped,
            data: DataPointWithShare.examples
        )
    }
}

extension DataPointWithShare {
    static var example: DataPointWithShare {
        DataPointWithShare(
            title: "Test (incorrect percentage)",
            value: "\(1_224)",//1_224.formattedGrouped,
            percentage: 0.12.formattedPercentage
        )
    }
    
    static var examples: [DataPointWithShare] {
        [
            DataPointWithShare.example,
            DataPointWithShare(title: "Title 1", value: "10", percentage: "15%"),
            DataPointWithShare(title: "Title 2", value: "20", percentage: "30%")
        ]
    }
}
