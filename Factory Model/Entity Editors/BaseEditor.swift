//
//  BaseEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI
import CoreData

struct BaseEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @EnvironmentObject var settings: Settings
    
    @Binding var isPresented: Bool
    
    let baseToEdit: Base?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        baseToEdit = nil
        
        _factory = State(initialValue: nil)
        _name = State(initialValue: "")
        _unitString_ = State(initialValue: "")
        _code = State(initialValue: "")
        _group = State(initialValue: "")
        _note = State(initialValue: "")
        _initialInventory = State(initialValue: 0)
        _weightNetto = State(initialValue: 0)
        _complexity = State(initialValue: 1)
        
        title = "New Base"
    }
    
    init(_ base: Base) {
        _isPresented = .constant(true)
        
        baseToEdit = base
        
        _factory = State(initialValue: base.factory)
        _name = State(initialValue: base.name)
        _unitString_ = State(initialValue: base.unitString_ ?? "")
        _code = State(initialValue: base.code)
        _group = State(initialValue: base.group)
        _note = State(initialValue: base.note)
        _initialInventory = State(initialValue: base.initialInventory)
        _weightNetto = State(initialValue: base.weightNetto)
        _complexity = State(initialValue: base.complexity)
        
        title = "Edit Base"
    }
    
    @State private var factory: Factory?
    @State private var name: String
    @State private var group: String
    @State private var code: String
    @State private var note: String
    @State private var unitString_: String
    @State private var initialInventory: Double
    @State private var weightNetto: Double
    @State private var complexity: Double
    
    @State private var isNewDraftActive = false
    @State private var recipeDrafts = [RecipeDraft]()
        
    var body: some View {
        NavigationLink(
            destination: CreateRecipe(recipeDrafts: $recipeDrafts, period: settings.period),
            isActive: $isNewDraftActive
        ) {
            EmptyView()
        }
        .hidden()
        
        List {
            NameGroupCodeNoteStringEditorSection(name: $name, group: $group, code: $code, note: $note)
            
            Section(
                header: Text("Unit")
            ) {
                ParentUnitStringPicker(unitString: $unitString_)
            }
            
            Section(
                header: Text("Complexity"),
                footer: Text("Complexity is used to calculate Labor Cost of Base Product. Consider 100% as most used or ideal base.")
            ) {
                ComplexityView(complexity: $complexity)
                    .padding(.top, 6)
            }
            
            Section(
                // header: Text("Initial Inventory")
            ) {
                AmountPicker(systemName: "building.2.crop.circle.fill", title: "Initial Inventory", navigationTitle: "Initial Inventory", scale: .large, amount: $initialInventory)
            }
            
            Section(
                // header: Text("Weight Netto")
            ) {
                AmountPicker(systemName: "scalemass", title: "Weight Netto, g", navigationTitle: "Weight", scale: .small, amount: $weightNetto)
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(weightNetto > 0 ? .accentColor : .systemRed)
            }
            
            EntityPickerSection(selection: $factory, period: settings.period)
            
            DraftSection<Ingredient, RecipeDraft>(isNewDraftActive: $isNewDraftActive, drafts: $recipeDrafts)
            
            if let base = baseToEdit,
               !base.recipes.isEmpty {
                GenericListSection(
                    header: "Existing Ingredients",
                    type: Recipe.self,
                    predicate: NSPredicate(format: "%K == %@", #keyPath(Recipe.base), base)
                ) { (recipe: Recipe) in
                    RecipeEditor(recipe)
                }
            }
            
            if let base = baseToEdit,
               !base.products.isEmpty {
                GenericListSection(
                    header: "Used in Products",
                    type: Product.self,
                    predicate: NSPredicate(format: "%K == %@", #keyPath(Product.base), base)
                ) { product in
                    ProductView(product)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let base: Base
            if let baseToEdit = baseToEdit {
                base = baseToEdit
            } else {
                base = Base(context: context)
            }
            
            base.factory = factory
            base.name = name
            base.unitString_ = unitString_
            base.code = code
            base.code = code
            base.group = group
            base.note = note
            base.initialInventory = initialInventory
            base.weightNetto = weightNetto
            base.complexity = complexity
            
            for draft in recipeDrafts {
                let recipe = Recipe(context: context)
                recipe.ingredient = draft.ingredient
                recipe.qty = draft.qty
                recipe.coefficientToParentUnit = draft.coefficientToParentUnit
                base.addToRecipes_(recipe)
            }
            
            context.saveContext()
            
            isPresented = false
            presentation.wrappedValue.dismiss()
        }
        .disabled(factory == nil || name.isEmpty || unitString_.isEmpty || weightNetto == 0)
    }
}

fileprivate struct CreateRecipe: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var recipeDrafts: [RecipeDraft]
    
    let period: Period
    
    @State private var ingredient: Ingredient?
    @State private var qty: Double = 0
    @State private var coefficientToParentUnit: Double = 1
    
    var body: some View {
        List {
            HStack {
                EntityPicker(selection: $ingredient, icon: Ingredient.icon, period: period)
                    .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                AmountPicker(navigationTitle: "Qty", scale: .small, amount: $qty)
                    .buttonStyle(PlainButtonStyle())
                
                ChildUnitStringPicker(coefficientToParentUnit: $coefficientToParentUnit, parentUnit: ingredient?.customUnit)
                
            }
            .foregroundColor(.accentColor)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Add Ingredient")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    if let ingredient = ingredient {
                        recipeDrafts.append(
                            RecipeDraft(
                                ingredient: ingredient,
                                qty: qty,
                                coefficientToParentUnit: coefficientToParentUnit
                            )
                        )
                    }
                    
                    presentation.wrappedValue.dismiss()
                }
                .disabled(ingredient == nil || qty == 0)
            }
        }
    }
}

struct BaseEditor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                BaseEditor(Base.example)
            }
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
