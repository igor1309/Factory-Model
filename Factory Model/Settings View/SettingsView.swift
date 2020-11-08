//
//  SettingsView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 05.11.2020.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var persistence: PersistenceManager
    @EnvironmentObject var settings: Settings
    
    @State private var showConfirmation = false
    @State private var showAction = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Period")) {
                    PeriodPicker(icon: "deskclock", title: "Period", period: $settings.period)
                }
                
                Section(
                    header: Text("Delete"),
                    footer: Text("Delete all entities: all Factories, Products, etc. Use with care - data would be wiped out for good.")
                        .foregroundColor(.red)
                ) {
                    Text(persistence.entitiesList)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Button {
                        showConfirmation = true
                    } label: {
                        Label("Delete all entities".uppercased(), systemImage: "trash.circle")
                    }
                    .accentColor(.red)
                }
                .disabled(persistence.isEmpty)
                .actionSheet(isPresented: $showConfirmation, content: confirmation)
            }
            .listStyle(InsetGroupedListStyle())
            .actionSheet(isPresented: $showAction, content: deleteAction)
            .navigationTitle("Settings")
            .navigationBarItems(
                trailing: Button("Done") {
                    presentation.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func confirmation() -> ActionSheet {
        ActionSheet(
            title: Text("Delete all".uppercased()),
            message: Text("Are you sure you want to delete everything?\nThis cannot be undone."),
            buttons: [
                .destructive(Text("Yes, delete everything")) {
                    showAction = true
                },
                .cancel()
            ]
        )
    }
    
    private func deleteAction() -> ActionSheet {
        ActionSheet(
            title: Text("Delete all".uppercased()),
            message: Text("Are you absolutely certain you want to delete everything?\n\nThis cannot be undone.".uppercased()),
            buttons: [
                .destructive(Text("Yes, delete everything".uppercased()), action: delete),
                .cancel()
            ]
        )
    }
    
    private func delete() {
        persistence.deleteAll()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environment(\.managedObjectContext, PersistenceManager.previewContext)
            .environmentObject(PersistenceManager.preview)
            .environmentObject(Settings())
            .environment(\.colorScheme, .dark)
    }
}
