//
//  ProductList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ProductList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var products: FetchedResults<Product>
    
    var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
        _products = FetchRequest(
            entity: Product.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Product.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "factory = %@", factory
            )
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Totals")) {
                Group {
                    VStack {
                        HStack {
                            Text("Total Production Cost**")
                            Spacer()
                            Text("\(factory.totalCost, specifier: "%.f")")
                        }
                        Text("ЕЩЕ не совсем кост — не всё учтено!!!")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    HStack {
                        Text("Total Revenue")
                        Spacer()
                        Text("\(factory.revenueExVAT, specifier: "%.f")")
                    }
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(header: Text("Product Groups")) {
                ForEach(factory.productGroups) { productGroup in
                    NavigationLink(
                        destination: ProductGropuList(group: productGroup.title, at: factory)
                    ) {
                        ListRow(productGroup)
                    }
                }
            }
            
            Section(header: Text("Products")) {
                ForEach(products, id: \.self) { product in
                    NavigationLink(
                        destination: ProductView(product)
                    ) {
                        ListRow(
                            title: product.name,
                                subtitle: product.note,
                                detail: product.group + ": " + product.code,
                                icon: "bag",
                            useSmallerFont: true
                        )
                    }
                }
                .onDelete(perform: removeProduct)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Products")
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let product = Product(context: managedObjectContext)
            product.name = " New Product"
            factory.addToProducts_(product)
            save()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeProduct(at offsets: IndexSet) {
        for index in offsets {
            let product = products[index]
            managedObjectContext.delete(product)
        }
        
        save()
    }
    
    private func save() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // handle the Core Data error
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//struct ProductList_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductList()
//    }
//}
