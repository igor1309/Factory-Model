//
//  ProductList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ProductGroupList: View {
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
            Section(header: Text("Group Totals")) {
                Group {
                    LabelWithDetail("Production", "TBD")
                    
                    LabelWithDetail("Revenue, ex VAT", factory.revenueExVAT(for: group).formattedGroupedWith1Decimal)
                }
                .font(.subheadline)
                .padding(.vertical, 3)
            }
            
            Section(header: Text("Products")) {
                ForEach(products, id: \.self) { product in
                    NavigationLink(
                        destination: ProductView(product)
                    ) {
                        ListRow(title: product.name, subtitle: product.note, detail: product.group + ": " + product.code, icon: "bag")
                    }
                }
                .onDelete(perform: removeProduct)
                
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(group)
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let product = Product(context: managedObjectContext)
            product.name = " New Product"
//            product.note = "Some note for product"
            // product.code = "1001"
            product.group = group
            factory.addToProducts_(product)
            managedObjectContext.saveContext()
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
        
        managedObjectContext.saveContext()
    }
}

//struct ProductList_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductList(group: <#String#>, at: <#Factory#>)
//    }
//}
