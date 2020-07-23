//
//  ExpensesRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

struct ExpensesRow: View {
    let expenses: Expenses
    let useSmallerFont: Bool
    
    init(
        _ expenses: Expenses,
        useSmallerFont: Bool = true
    ) {
        self.expenses = expenses
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        ListRow(
            title: expenses.name,
            subtitle: expenses.amount.formattedGrouped,
            detail: expenses.note,
            icon: "dollarsign.circle",
            useSmallerFont: useSmallerFont
        )
    }
}
