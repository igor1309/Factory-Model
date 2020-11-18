//
//  PeriodPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.08.2020.
//

import SwiftUI

struct PeriodPicker: View {
    @Binding var period: Period
    
    let icon: String
    let title: String
    let compact: Bool
    
    init(
        icon: String? = nil,
        title: String? = nil,
        period: Binding<Period>,
        compact: Bool? = nil
    ) {
        self.icon = icon ?? "clock"
        self.title = title ?? "Period"
        self.compact = compact ?? false
        _period = period
    }
    
    @State private var showTable = false
    
    var body: some View {
        Button {
            showTable = true
        } label: {
            if compact {
                Image(systemName: icon)
            } else {
                HStack {
                    Label(title, systemImage: icon)
                    Spacer()
                    Text(period.short)
                }
            }
        }
        .sheet(isPresented: $showTable) {
            PeriodPickerTable($period)
        }
    }
}


fileprivate struct PeriodPickerTable: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var period: Period
    
    init(_ period: Binding<Period>) {
        _period = period
        _periodStr = State(initialValue: period.wrappedValue.periodStr)
        _days = State(initialValue: period.wrappedValue.days)
        _hoursPerDay = State(initialValue: period.wrappedValue.hoursPerDay)
    }
    
    @State private var periodStr: String
    @State private var days: Int
    @State private var hoursPerDay: Double
    
    private var calculatedPeriod: Period? {
        Period(periodStr, days: days, hoursPerDay: hoursPerDay)
    }
    
    var body: some View {
        let periodString = Binding<String>(
            get: {
                switch periodStr {
                    case "hour":    return "H"
                    case "shift":   return "shift"
                    case "day":     return "D"
                    case "week":    return "W"
                    case "month":   return "M"
                    case "year":    return "Y"
                    default:        return "month"
                }
            },
            set: {
                switch $0 {
                    case "H":       periodStr = "hour"
                    case "shift":   periodStr = "shift"
                    case "D":       periodStr = "day"
                    case "W":       periodStr = "week"
                    case "M":       periodStr = "month"
                    case "Y":       periodStr = "year"
                    default:        periodStr = "month"
                }
            }
        )
        
        return NavigationView {
            Form {
                Section(
                    header: header,
                    footer: footer
                ) {
                    //Text(calculatedPeriod?.short ?? "ERROR")
                    
                    Picker("Period", selection: periodString) {
                        ForEach(Period.allCasesShort, id: \.self) { periodStr in
                            Text(periodStr)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if periodStr == "week" {
                        Picker("Days: \(days)", selection: $days) {
                            ForEach([3, 4, 5, 6, 7], id: \.self) { item in
                                Text("\(item)")
                            }
                        }
                    }
                    
                    if periodStr == "month" {
                        Picker("Days: \(days)", selection: $days) {
                            ForEach([14, 21, 24, 30], id: \.self) { item in
                                Text("\(item)")
                            }
                        }
                    }
                    
                    if periodStr == "year" {
                        Picker("Days: \(days)", selection: $days) {
                            ForEach([247, 300, 360], id: \.self) { item in
                                Text("\(item)")
                            }
                        }
                    }
                    
                    if periodStr != "hour" {
                        Picker("Hours: \(String(format: "%g", hoursPerDay))", selection: $hoursPerDay) {
                            ForEach([4.0, 6, 8, 10, 12, 16, 20, 24], id: \.self) { item in
                                Text("\(String(format: "%g", item))")
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Period")
            .navigationBarItems(trailing: doneButton)
        }
    }
    
    @ViewBuilder
    private var header: some View {
        if let footerStr = calculatedPeriod?.short {
            Text(footerStr)
        } else {
            Text("Error.")
                .foregroundColor(.systemRed)
        }
    }
    
    @ViewBuilder
    private var footer: some View {
        if let footerStr = calculatedPeriod?.summary {
            Text(footerStr)
        } else {
            Text("Error creating period. Check all parameters.")
                .foregroundColor(.systemRed)
        }
    }
        
    private var doneButton: some View {
        Button("Done") {
            guard let calculatedPeriod = calculatedPeriod else { return }
            
            period = calculatedPeriod
            presentation.wrappedValue.dismiss()
        }
        .disabled(calculatedPeriod == nil)
    }
}

struct PeriodPicker_Previews: PreviewProvider {
    @State static var period: Period = .month()
    
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    PeriodPicker(title: "Period", period: $period)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/375.0/*@END_MENU_TOKEN@*/, height: 200.0))
            
            PeriodPickerTable($period)
                .previewLayout(.fixed(width: 375, height: 350))
        }
        .preferredColorScheme(.dark)
    }
}
