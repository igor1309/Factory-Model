//
//  IngredientView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct IngredientView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var ingredient: Ingredient
    
    var body: some View {
        
        List {
            Section(
                header: Text("Ingredient Detail")
            ) {
                FeedstockPicker(feedstock: $ingredient.feedstock)
                
                QtyPicker(title: "Qty", qty: $ingredient.qty)
            }
            
            
        }
        .onDisappear {
            moc.saveContext()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(ingredient.title)
    }
}

import CoreData

struct FeedstockPicker: View {
    @Environment(\.managedObjectContext) var moc
    
    @Binding var feedstock: Feedstock?
    
    @State private var showPicker = false
    
    var body: some View {
        Button {
            showPicker = true
        } label: {
            if feedstock == nil {
                Text("No Feedstock")
                    .foregroundColor(.systemRed)
            } else {
                Text(feedstock!.title)
            }
        }
        //        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showPicker, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
            FeedstockPickerTable(feedstock: $feedstock)
                .environment(\.managedObjectContext, moc)
        }
    }
}

fileprivate struct FeedstockPickerTable: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @Binding var feedstock: Feedstock?
    
    @FetchRequest private var feedstocks: FetchedResults<Feedstock>
    
    init(feedstock: Binding<Feedstock?>) {
        _feedstock = feedstock
        
        _feedstocks = FetchRequest(
            entity: Feedstock.entity(),
            sortDescriptors: [
                NSSortDescriptor(
                    keyPath: \Feedstock.name_, ascending: true
                )
            ],
            predicate: nil
        )
    }
    
    @State private var showEditor = false
    
    var body: some View {
        NavigationView {
            List {
                Text("TBD: can't use GenericSection until ListRow as parameter")
                    .foregroundColor(.systemRed)
                    .font(.subheadline)
                
                Section {
                    ForEach(feedstocks, id: \.objectID) { feedstock in
                        Button {
                            self.feedstock = feedstock
                            presentation.wrappedValue.dismiss()
                        } label: {
                            ListRow(feedstock).tag(feedstock)
                                .contextMenu {
                                    Button {
                                        //  MARK: - FINISH THIS
                                        showEditor = true
                                    } label: {
                                        Label("Edit", systemImage: "square.and.pencil")
                                    }
                                }
                                .sheet(isPresented: $showEditor) {
                                    NavigationView {
                                        FeedstockView(feedstock: feedstock)
                                            .navigationBarTitleDisplayMode(.inline)
                                            .environment(\.managedObjectContext, moc)
                                    }
                                }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Feedstock")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: plusButton)
        }
    }
    
    private var plusButton: some View {
        Button {
            let feedstock = Feedstock(context: moc)
            feedstock.name = " New Feedstock"
            //            factory.addToFeedstocks_(feedstock)
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
