//
//  PeriodPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.08.2020.
//

import SwiftUI

struct PeriodPicker: View {
    var icon: String = "clock"
    var title: String = "Period"
    @Binding var period: Period
    
    @State private var showTable = false
    
    var body: some View {
        Button {
            showTable = true
        } label: {
            HStack {
                Label(title, systemImage: icon)
                Spacer()
                Text(period.short)
            }
        }
        .sheet(isPresented: $showTable) {
            PeriodPickerTable($period)
        }
    }
}


fileprivate struct PeriodPickerTable: View {
    @Environment(\.presentationMode) var presentation
    
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
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    header: header,
                    footer: footer
                ) {
                    //Text(calculatedPeriod?.short ?? "ERROR")
                    
                    Picker("Period", selection: $periodStr) {
                        ForEach(Period.allCases, id: \.self) { periodStr in
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
    
    private var doneButton: some View {
        Button("Done") {
            guard let calculatedPeriod = calculatedPeriod else { return }
            
            period = calculatedPeriod
            presentation.wrappedValue.dismiss()
        }
        .disabled(calculatedPeriod == nil)
    }
}

fileprivate struct PeriodPicker_Previews: PreviewProvider {
    @State static var period: Period = .month()
    
    static var previews: some View {
        Group {
            NavigationView {
                PeriodPicker(title: "Period", period: $period)
            }
            
            PeriodPickerTable($period)
        }
        .preferredColorScheme(.dark)
    }
}
