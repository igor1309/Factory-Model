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
        _workHours = State(initialValue: 0)
        
        _unitsHours = State(initialValue: .unitsPerHour)
        
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
        _workHours = State(initialValue: base.workHours)
        
        _unitsHours = State(
            initialValue: {
                switch base.workHours {
                    case 0, 1...:    return .hoursPerUnit
                    case ...1: return .unitsPerHour
                    default:   return .hoursPerUnit
                }
            }()
        )

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
    @State private var workHours: Double

    @State private var isNewDraftActive = false
    @State private var recipeDrafts = [RecipeDraft]()
    
    enum UnitsHours: String, CaseIterable {
        case unitsPerHour = "Units per Hour"
        case hoursPerUnit = "Hours per Unit"
        
        var icon: String {
            switch self {
                case .unitsPerHour: return "cylinder.split.1x2"
                case .hoursPerUnit: return "clock.arrow.circlepath"
            }
        }
        
        var headline: String {
            switch self {
                case .unitsPerHour: return "Units of Base Product produced in 1 Work Hour."
                case .hoursPerUnit: return "Work Hours to produce 1 Unit of Base Product."
            }
        }
        
        func workHours(for value: Double) -> Double {
            switch self {
                case .unitsPerHour: return value > 0 ? 1 / value : 0
                case .hoursPerUnit: return value
            }
        }
    }
    
    @State private var unitsHours: UnitsHours// = .unitsPerHour
    
    var body: some View {
        let unitsHoursValue = Binding<Double>(
            get: { unitsHours.workHours(for: workHours) },
            set: { workHours = unitsHours.workHours(for: $0) }
        )
        
        NavigationLink(
            destination: CreateRecipe(recipeDrafts: $recipeDrafts),
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
                header: Text("Work Hours"),
                footer: Text("\(unitsHours.headline) \(String(format: "%g", workHours)) hours per unit.").lineLimit(nil)
            ) {
                Picker(
                    selection: $unitsHours,
                    label: AmountPicker(systemName: unitsHours.icon, navigationTitle: unitsHours.rawValue, scale: .extraSmall, amount: unitsHoursValue).buttonStyle(PlainButtonStyle()).foregroundColor(unitsHoursValue.wrappedValue < 1 ? .systemRed : .accentColor)
                ) {
                    ForEach(UnitsHours.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }
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
            
            EntityPickerSection(selection: $factory)
            
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
            base.workHours = workHours
            
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
        .disabled(factory == nil || name.isEmpty || unitString_.isEmpty || weightNetto == 0 || workHours == 0)
    }
}

fileprivate struct CreateRecipe: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var recipeDrafts: [RecipeDraft]
    
    @State private var ingredient: Ingredient?
    @State private var qty: Double = 0
    @State private var coefficientToParentUnit: Double = 1
    
    var body: some View {
        List {
            HStack {
                EntityPicker(selection: $ingredient, icon: Ingredient.icon)
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
