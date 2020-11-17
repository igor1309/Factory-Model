//
//  SettingsView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 05.11.2020.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @EnvironmentObject private var persistence: PersistenceManager
    @EnvironmentObject private var settings: Settings
    
    @State private var showConfirmation = false
    @State private var showAction = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Period")) {
                    PeriodPicker(icon: "deskclock", title: "Period", period: $settings.period)
                }
                
                Section(
                    header: Text("Example Factories"),
                    footer: Text("Add example factories to play and get familiar with app.")
                ) {
                    createFactory1Button()
                    createFactory2Button()
                }
                
                Section(
                    header: Text("Stack View"),
                    footer: Text("In some views data rows could be presented in a Stack for more compact view.")
                ) {
                    Toggle("Show as Stack", isOn: $settings.asStack)
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
    
    private func createFactory1Button() -> some View {
        Button {
            withAnimation {
                let _ = Factory.createFactory1(in: context)
                context.saveContext()
                presentation.wrappedValue.dismiss()
            }
        } label: {
            Label("Сыроварня", systemImage: "plus")
        }
    }
    
    private func createFactory2Button() -> some View {
        Button {
            withAnimation {
                let _ = Factory.createFactory2(in: context)
                context.saveContext()
                presentation.wrappedValue.dismiss()
            }
        } label: {
            Label("Полуфабрикаты", systemImage: "plus")
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
        presentation.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environment(\.managedObjectContext, PersistenceManager.previewContext)
            .environment(\.managedObjectContext, PersistenceManager.previewContext)
            .environmentObject(PersistenceManager.preview)
            .environmentObject(Settings())
            .environment(\.colorScheme, .dark)
    }
}
