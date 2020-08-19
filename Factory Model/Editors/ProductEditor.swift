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
    
    init(product: Product) {
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
    
    var body: some View {
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
            
            Section(
                header: Text("Packaging")
            ) {
                EntityPicker(selection: $packaging, icon: "shippingbox", predicate: nil)
                }
            .foregroundColor(packaging == nil ? .systemRed : .accentColor)
            
            Section(
                header: Text("VAT (\(vat.formattedPercentageWith1Decimal))")
            ) {
                Group {
                    AmountPicker(systemName: "scissors", title: "VAT", navigationTitle: "VAT", scale: .percent, amount: $vat)
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
                    
                    context.saveContext()
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || baseQty == 0 || productionQty == 0 || vat == 0 || base == nil || packaging == nil)
            }
        }
    }
}