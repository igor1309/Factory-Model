//
//  StringPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

struct StringPicker: View {
    let title: String
    let items: [String]
    @Binding var selection: String
    @State private var showPicker = false
    
    var body: some View {
        Button(title) {
            showPicker = true
        }
        .sheet(isPresented: $showPicker) {
            StringPickerTable(items: items, selection: $selection)
        }
    }
}

fileprivate struct StringPickerTable: View {
    @Environment(\.presentationMode) private var presentation
    
    let items: [String]
    @Binding var selection: String
    
    @State private var showDraft = false
    @State private var draft = ""
    
    var body: some View {
        NavigationView {
            List {
                if showDraft {
                    HStack {
                        TextField("New", text: $draft)
                        Spacer()
                        Button("Create") {
                            selection = draft
                            presentation.wrappedValue.dismiss()
                        }
                    }
                }
                
                ForEach(items, id: \.self) { item in
                    Button {
                        selection = item
                        presentation.wrappedValue.dismiss()
                    } label: {
                        Text(item)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: plusButton)
        }
    }
    
    private var plusButton: some View {
        Button {
            withAnimation {
                showDraft = true
            }
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
