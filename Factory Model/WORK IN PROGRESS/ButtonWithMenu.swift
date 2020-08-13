//
//  ButtonWithMenu.swift
//  Factory Model
//
//  Created by Igor Malyarov on 13.08.2020.
//

import SwiftUI

struct ButtonWithMenu: View {
    @State private var showModal = false
    
    var body: some View {
        NavigationView {
            List {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(trailing:
                                    Menu {
                Button(action: {
                    showModal = true
                }) {
                    Label("Create a file", systemImage: "doc")
                }
                .sheet(isPresented: $showModal) {
                    NavigationView {
                        Text("Modal")
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Save") {}
                                }
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancel") {}
                                }
                            }
                    }
                }
                
                Button(action: {}) {
                    Label("Create a folder", systemImage: "folder")
                }
                
                Section(header: Text("Secondary actions")) {
                    Button(action: {}) {
                        Label("Remove old files", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                    Button("Filter") {}
                }
            }
            label: {
                Image(systemName: "plus")
            })
//                .toolbar {
//                    ToolbarItem(placement: .primaryAction) {
//                        HStack(spacing: 16) {
//                            Button(action: {}) {
//                                Label("Create a folder", systemImage: "folder")
//                            }
//                            Menu {
//                                Button(action: {
//                                    showModal = true
//                                }) {
//                                    Label("Create a file", systemImage: "doc")
//                                }
//                                .sheet(isPresented: $showModal) {
//                                    NavigationView {
//                                        Text("Modal")
//                                            .toolbar {
//                                                ToolbarItem(placement: .confirmationAction) {
//                                                    Button("Save") {}
//                                                }
//                                                ToolbarItem(placement: .cancellationAction) {
//                                                    Button("Cancel") {}
//                                                }
//                                            }
//                                    }
//                                }
//
//                                Button(action: {}) {
//                                    Label("Create a folder", systemImage: "folder")
//                                }
//
//                                Section(header: Text("Secondary actions")) {
//                                    Button(action: {}) {
//                                        Label("Remove old files", systemImage: "trash")
//                                            .foregroundColor(.red)
//                                    }
//                                    Button("Filter") {}
//                                }
//                            }
//                            label: {
//                                Label("Add", systemImage: "plus")
//                            }
//                        }
//                    }
//                }
        }
    }
}

struct ButtonWithMenu_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWithMenu()
            .preferredColorScheme(.dark)
    }
}
