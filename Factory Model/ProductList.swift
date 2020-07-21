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
    let group: String
    
    init(group: String, at factory: Factory) {
        self.factory = factory
        self.group = group
        _products = FetchRequest(
            entity: Product.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Product.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "factory = %@ and group_ = %@", factory, group
            )
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Products".uppercased())) {
                ForEach(products, id: \.self) { product in
                    NavigationLink(
                        destination: ProductView(product)
                    ) {
                        ListRow(title: product.name, subtitle: product.note, detail: product.group + ": " + product.code, icon: "bag")
                    }
                }
                .onDelete(perform: removeProduct)
                
                VStack(spacing: 4) {
                    HStack {
                        Text("Total production")
                        Spacer()
                        Text("TBD")
                    }
                    
                    HStack {
                        Text("Total revenue")
                        Spacer()
                        Text("TBD")
                    }
                }
                .font(.subheadline)
                .padding(.vertical, 3)
                
                Button("Add Product") {
                    let product = Product(context: managedObjectContext)
                    product.name = "New Product"
                    product.note = "Some note for product"
                    // product.code = "1001"
                    product.group = group
                    factory.addToProducts_(product)
                    save()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(group)
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
//        ProductList(group: <#String#>, at: <#Factory#>)
//    }
//}
