//
//  GenericList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI
import CoreData

typealias Listable = Creatable & Managed & Monikerable & Summarizable & Viewable

struct GenericListSection<T: Listable>: View where T.ManagedType == T {
    
    @Environment(\.managedObjectContext) private var context
    
    @EnvironmentObject private var settings: Settings
    
    let smallFont: Bool
    let header: String
    
    init(
        header: String? = T.plural,
        fetchRequest: FetchRequest<T>,
        smallFont: Bool = true
    ) {
        self.header = header ?? T.plural
        _fetchRequest = fetchRequest
        self.smallFont = smallFont
    }
    
    init(
        header: String? = T.plural,
        type: T.Type,
        predicate: NSPredicate?,
        smallFont: Bool = true
    ) {
        self.header = header ?? T.plural
        self.smallFont = smallFont
        _fetchRequest = T.defaultFetchRequest(with: predicate)
    }
    
    @FetchRequest private var fetchRequest: FetchedResults<T>
    
    var body: some View {
        Section(
            header: Text(header)
        ) {
            if fetchRequest.isEmpty {
                Text("No data to list")
                    .foregroundColor(.systemTeal)
                    .font(.subheadline)
            } else {
                ForEach(fetchRequest, id: \.objectID) { entity in
                    NavigationLink(
                        destination: entity.viewer()
                    ) {
                        EntityRowWithAction(entity, smallFont: smallFont, in: settings.period)
                    }
                }
            }
        }
        //  MARK: - FINISH THIS удаление не-сиротских объектов лучше не допускать без подтверждения
        //        .onDelete(perform: remove)
        .onDisappear {
            context.saveContext()
        }
    }
    
    private func remove(at offsets: IndexSet) {
        //  MARK: - FINISH THIS удаление не-сиротских объектов лучше не допускать без подтверждения
        for index in offsets {
            let item = fetchRequest[index]
            context.delete(item)
        }
        context.saveContext()
    }
}

fileprivate struct EntityRowWithAction<T: Listable>: View {

    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var entity: T
    
    let smallFont: Bool
    let period: Period
    
    init(_ entity: T, smallFont: Bool = true, in period: Period) {
        self.entity = entity
        self.smallFont = smallFont
        self.period = period
    }
    
    @State private var showDeleteAction = false
    
    var body: some View {
        EntityRow(entity, smallFont: smallFont)
            .contextMenu {
                Button {
                    showDeleteAction = true
                } label: {
                    Label("Delete", systemImage: "trash.circle")
                }
            }
            .actionSheet(isPresented: $showDeleteAction) {
                ActionSheet(
                    title: Text("Delete?".uppercased()),
                    message: Text("Do you really want to delete '\(entity.title(in: period))'?\nThis cannot be undone."),
                    buttons: [
                        .destructive(Text("Yes, delete")) { delete(entity) },
                        .cancel()
                    ]
                )
            }
    }
    
    private func delete(_ entity: T) {
        let haptics = Haptics()
        haptics.feedback()
        
        withAnimation {
            context.delete(entity)
            context.saveContext()
        }
    }
}

struct GenericListSection_Previews: PreviewProvider {
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(
            format: "ANY %K.base == %@", #keyPath(Ingredient.recipes_), Base.example
        )
    ) static private var ingredients: FetchedResults<Ingredient>
    
    static var previews: some View {
        NavigationView {
            List {
                GenericListSection(fetchRequest: _ingredients)
                
                GenericListSection(type: Buyer.self, predicate: nil)
                
                GenericListSection(type: Base.self, predicate: nil)
                
                GenericListSection<Base>(fetchRequest: FetchRequest(entity: Base.entity(), sortDescriptors: []))
                
                GenericListSection(type: Factory.self, predicate: nil)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("GenericListSection", displayMode: .inline)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 1200))
    }
}
