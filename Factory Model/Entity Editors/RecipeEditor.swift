//
//  RecipeEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct RecipeEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @EnvironmentObject private var settings: Settings
    
    @Binding var isPresented: Bool
    
    let recipeToEdit: Recipe?
    let title: String
    
    init(isPresented: Binding<Bool>, base: Base? = nil, ingredient: Ingredient? = nil) {
        _isPresented = isPresented
        
        recipeToEdit = nil
        
        _base = State(initialValue: base)
        _ingredient = State(initialValue: ingredient)
        _qty = State(initialValue: 0)
        _coefficientToParentUnit = State(initialValue: 1)
        
        title = "New Recipe"
    }
    
    init(_ recipe: Recipe) {
        _isPresented = .constant(true)
        
        recipeToEdit = recipe
        
        _base = State(initialValue: recipe.base)
        _ingredient = State(initialValue: recipe.ingredient)
        _qty = State(initialValue: recipe.qty)
        _coefficientToParentUnit = State(initialValue: recipe.coefficientToParentUnit)
        
        title = "Edit Recipe"
    }
    
    @State private var base: Base?
    @State private var ingredient: Ingredient?
    @State private var qty: Double
    @State private var coefficientToParentUnit: Double
    
    var body: some View {
        List {
            EntityPickerSection(selection: $ingredient, period: settings.period)
            
            Section {
                AmountPicker(systemName: "square", title: "Ingredient Qty", navigationTitle: "Ingredient Qty", scale: .small, amount: $qty)
                    .foregroundColor(qty > 0 ? .accentColor : .systemRed)
                
                HStack {
                    Label("Unit", systemImage: "rectangle.3.offgrid")
                    
                    Spacer()
                    
                    ChildUnitStringPicker(coefficientToParentUnit: $coefficientToParentUnit, parentUnit: ingredient?.customUnit)
                }
                .foregroundColor(.accentColor)
            }
            
            EntityPickerSection(selection: $base, period: settings.period)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let haptics = Haptics()
            haptics.haptic()
            
            withAnimation {
                let recipe: Recipe
                
                if let recipeToEdit = recipeToEdit {
                    recipe = recipeToEdit
                    recipe.objectWillChange.send()
                } else {
                    recipe = Recipe(context: context)
                }
                
                recipe.base?.objectWillChange.send()
                recipe.ingredient?.objectWillChange.send()
                
                recipe.base = base
                recipe.ingredient = ingredient
                recipe.qty = qty
                recipe.coefficientToParentUnit = coefficientToParentUnit
                
                context.saveContext()
                
                isPresented = false
                presentation.wrappedValue.dismiss()
            }
        }
        .disabled(base == nil || ingredient == nil || qty == 0)
    }
}

struct RecipeEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    RecipeEditor(isPresented: .constant(true))
                }
            }
            .previewLayout(.fixed(width: 345, height: 420))
            
            NavigationView {
                VStack {
                    RecipeEditor(Recipe.example)
                }
            }
            .previewLayout(.fixed(width: 345, height: 420))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
