//
//  StaffRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

struct StaffRow: View {
    @ObservedObject var staff: Staff
    let useSmallerFont: Bool
    
    init(
        _ staff: Staff,
        useSmallerFont: Bool = true
    ) {
        self.staff = staff
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        ListRow(title: staff.name,
                subtitle: staff.salary.formattedGrouped,
                detail: staff.idd,
                icon: "person")
    }
}
