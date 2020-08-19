//
//  ProductEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct ProductEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let productToEdit: Product?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        productToEdit = nil
        
        _name = State(initialValue: "")
        _baseQty = State(initialValue: 0)
        _code = State(initialValue: "")
        _coefficientToParentUnit = State(initialValue: 1)
        _group = State(initialValue: "")
        _note = State(initialValue: "")
        _productionQty = State(initialValue: 0)
        _vat = State(initialValue: 10/100)
        _base = State(initialValue: nil)
        _packaging = State(initialValue: nil)
        
        title = "New Product"
    }
    
    init(_ product: Product) {
        _isPresented = .constant(true)
        
        productToEdit = product
        
        _name = State(initialValue: product.name)
        _baseQty = State(initialValue: product.baseQty)
        _code = State(initialValue: product.code)
        _coefficientToParentUnit = State(initialValue: product.coefficientToParentUnit)
        _group = State(initialValue: product.group)
        _note = State(initialValue: product.note)
        _productionQty = State(initialValue: product.productionQty)
        _vat = State(initialValue: product.vat)
        _base = State(initialValue: product.base)
        _packaging = State(initialValue: product.packaging)
        
        title = "Edit Product"
    }
    
    @State private var name: String
    @State private var baseQty: Double
    @State private var code: String
    @State private var coefficientToParentUnit: Double
    @State private var group: String
    @State private var note: String
    @State private var productionQty: Double
    @State private var vat: Double
    @State private var base: Base?
    @State private var packaging: Packaging?
    
    @State private var isNewDraftActive = false
    @State private var salesDrafts = [SalesDraft]()
    
    var body: some View {
        NavigationLink(
            destination: CreateSales(salesDrafts: $salesDrafts, kind: .forProduct),
            isActive: $isNewDraftActive
        ) {
            EmptyView()
        }
        
        List {
            NameGroupCodeNoteStringEditorSection(name: $name, group: $group, code: $code, note: $note)
            
            EntityPickerSection(selection: $base)
            
            Section(
                header: Text("Base Product Qty")
            ) {
                Group {
                    HStack {
                        AmountPicker(systemName: "square.grid.3x3.middleright.fill", title: "Base Qty", navigationTitle: "Qty", scale: .medium, amount: $baseQty)
                            .foregroundColor(baseQty <= 0 ? .systemRed : .accentColor)
                            .buttonStyle(PlainButtonStyle())
                        ChildUnitStringPicker(coefficientToParentUnit: $coefficientToParentUnit, parentUnit: base?.customUnit)
                            .buttonStyle(PlainButtonStyle())
                    }
                    .foregroundColor(.accentColor)
                }
            }
            
            EntityPickerSection(selection: $packaging)            
            
            Section(
                header: Text("Production Qty")
            ) {
                Group {
                    AmountPicker(systemName: "scissors", title: "Production Qty", navigationTitle: "Production Qty", scale: .medium, amount: $productionQty)
                        .foregroundColor(productionQty > 0 ? .accentColor : .systemRed)
                }
            }
            
            Section(
                header: Text("VAT")
            ) {
                Group {
                    AmountPicker(systemName: "scissors", title: "VAT", navigationTitle: "VAT", scale: .percent, amount: $vat)
                }
            }
            
            DraftSection<Sales, SalesDraft>(isNewDraftActive: $isNewDraftActive, drafts: $salesDrafts)

            if let product = productToEdit,
               !product.sales.isEmpty {
                GenericListSection(
                    header: "Existing Sales",
                    type: Sales.self,
                    predicate: NSPredicate(format: "%K == %@", #keyPath(Sales.product), product)
                ) { (sales: Sales) in
                    SalesEditor(sales)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let product: Product
                    if let productToEdit = productToEdit {
                        product = productToEdit
                    } else {
                        product = Product(context: context)
                    }
                    
                    product.name = name
                    product.baseQty = baseQty
                    product.code = code
                    product.coefficientToParentUnit = coefficientToParentUnit
                    product.group = group
                    product.note = note
                    product.productionQty = productionQty
                    product.vat = vat
                    product.base = base
                    product.packaging = packaging
                    
                    for draft in salesDrafts {
                        let sales = Sales(context: context)
                        sales.priceExVAT = draft.priceExVAT
                        sales.qty = draft.qty
                        sales.buyer = draft.buyer
                        product.addToSales_(sales)
                    }
                    
                    context.saveContext()
                    
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || baseQty == 0 || productionQty == 0 || vat == 0 || base == nil || packaging == nil)
            }
        }
    }
}
