//
//  PackagingPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 25.07.2020.
//

import SwiftUI
import CoreData

struct PackagingPicker: View {
    @Environment(\.managedObjectContext) var moc
    
    @Binding var packaging: Packaging?
    
    var product: Product
    var factory: Factory
    
    @State private var showPicker = false
    
    var body: some View {
        
        //        NavigationLink(
        //            destination: PackagingPickerTable(packaging: $packaging, for: product, at: factory)
        //        ) {
        //            if packaging == nil {
        //                Text("No Packaging")
        //                    .foregroundColor(.systemRed)
        //            } else {
        //                Text(packaging!.title)
        //            }
        //        }
        //        .foregroundColor(.accentColor)
        
        
        Button {
            showPicker = true
        } label: {
            if packaging == nil {
                Text("No Packaging")
                    .foregroundColor(.systemRed)
            } else {
                Text(packaging!.title)
            }
        }
        .sheet(isPresented: $showPicker, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
            PackagingPickerTable(packaging: $packaging, for: product, at: factory)
                .environment(\.managedObjectContext, moc)
        }
        
    }
}

fileprivate struct PackagingPickerTable: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @Binding var packaging: Packaging?
    
    @FetchRequest private var orphans: FetchedResults<Packaging>
    
    var product: Product
    var factory: Factory
    
    init(
        packaging: Binding<Packaging?>,
        for product: Product,
        at factory: Factory
    ) {
        _packaging = packaging
        self.product = product
        self.factory = factory
        
        let predicate = NSPredicate(
            format: "ANY %K = nil", #keyPath(Packaging.products_)
        )
        _orphans = Packaging.defaultFetchRequest(with: predicate)
    }
    
    @State private var showActionSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(factory.packagingTypes, id: \.self) { type in
                    Section(
                        header: Text(type)
                    ) {
                        ForEach(factory.packagingsForType(type), id: \.objectID) { packaging in
                            selectingButton(packaging)
                                .contextMenu {
                                    Button {
                                        //  MARK: - FINISH THIS
                                        
                                    } label: {
                                        Label("TBD: Edit", systemImage: "square.and.pencil")
                                    }
                                }
                        }
                    }
                }
                
                if !orphans.isEmpty {
                    Section(
                        header: Text("Orphaned")
                    ) {
                        ForEach(orphans, id: \.objectID) { packaging in
                            selectingButton(packaging)
                        }
                        .onDelete(perform: removeOrphans)
                        
                        Button("Delete all orphaned") {
                            self.showActionSheet = true
                        }
                        .actionSheet(isPresented: $showActionSheet) {
                            deleteActionSheet
                        }
                        .foregroundColor(.systemRed)
                        .font(.subheadline)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Packaging")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: PlusButton(type: Packaging.self))
        }
    }
    
    private var deleteActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Delete all orphaned?".uppercased()),
            message: Text("Are you sure? This cannot be undone."),
            buttons: [
                .destructive(Text("Yes, delete!"), action: removeAllOrphans),
                .cancel()
            ]
        )
    }
    
    private func selectingButton(_ packaging: Packaging) -> some View {
        Button {
            self.packaging = packaging
            presentation.wrappedValue.dismiss()
        } label: {
            ListRow(packaging).tag(packaging)
        }
    }
    
    private func removeAllOrphans() {
        for orphan in orphans {
            moc.delete(orphan)
        }
        moc.saveContext()
    }
    
    private func removeOrphans(at offsets: IndexSet) {
        for index in offsets {
            let orphan = orphans[index]
            moc.delete(orphan)
        }
        moc.saveContext()
    }
}
