//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

enum EntityButtonKind { case card, label, bar }

struct CreateNewEntityButton<T: Listable>: View where T.ManagedType == T {
    
    @Environment(\.managedObjectContext) private var context
    
    @EnvironmentObject private var settings: Settings
    
    /// used to close CreateEntityPicker sheet or navigate back from Entitity Editors
    let isPresented: Binding<Bool>
    let factory: Factory?
    let kind: EntityButtonKind
    let useSheet: Bool
    
    /// create buttons for Bar Items or as Labels (in a List for example)
    /// - Parameters:
    ///   - factory: optional Factory, as parent
    ///   - kind: label or bar, for card use another init
    ///   - useSheet: use navigation or sheet, default is navigation
    init(factory: Factory? = nil, kind: EntityButtonKind = .bar, useSheet: Bool = false) {
        self.isPresented = .constant(true)
        self.factory = factory
        self.kind = kind
        self.useSheet = useSheet
    }
    
    /// for use with CreateEntityPicker with cards
    /// - Parameters:
    ///   - isPresented: used to close CreateEntityPicker sheet or navigate back from Entitity Editors
    ///   - factory: optional Factory, as parent
    init(isPresented: Binding<Bool>, factory: Factory? = nil) {
        self.isPresented = isPresented
        self.factory = factory
        self.kind = .card
        self.useSheet = true
    }
    
    @State private var isActive = false
    
    var body: some View {
        switch kind {
            case .card:
                VStack(spacing: 16) {
                    Image(systemName: T.icon)
                        .foregroundColor(T.color)
                        .font(.system(size: 52, weight: .ultraLight, design: .default))
                        .padding(.top, 6)
                    
                    Text(T.headline)
                        .font(.subheadline)
                    
                    button()
                }
                .simpleCardify()
                
            case .label, .bar: button()
        }
    }
    
    @ViewBuilder
    private func button() -> some View {
        if useSheet {
            innerButton()
                .sheet(isPresented: $isActive) {
                    NavigationView {
                        destination()
                    }
                    .environment(\.managedObjectContext, context)
                    .environmentObject(settings)
                }
        } else {
            NavigationLink(
                destination: destination(),
                isActive: $isActive
            ) {
                innerButton()
            }
        }
    }
    
    private func innerButton() -> some View {
        Button {
            let haptics = Haptics()
            haptics.haptic()

            withAnimation {
                isActive = true
            }
        } label: {
            switch kind {
                case .card:
                    Text("Create \(T.entityName)")
                        .frame(maxWidth: .infinity)
                        .accentColor(.white)
                        .simpleCardify(cornerRadius: 6, background: T.color)
                    
                case .label:
                    Label("Create \(T.entityName)", systemImage: T.plusButtonIcon)
                        .foregroundColor(T.color)
                    
                case .bar:
                    Image(systemName: T.plusButtonIcon)
                        .foregroundColor(T.color)
            }
        }
    }
    
    private func destination() -> some View {
        T.creator(isPresented: isPresented, factory: factory)
    }
}

struct CreateNewEntityButton_Previews: PreviewProvider {
    @State private static var isPresented = false
    
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    Section(header: Text("Sheet")) {
                        CreateNewEntityButton<Packaging>(kind: .label, useSheet: true)
                        CreateNewEntityButton<Base>(kind: .label, useSheet: true)
                    }
                    
                    Section(header: Text("Navigation")) {
                        CreateNewEntityButton<Packaging>(kind: .label)
                        CreateNewEntityButton<Base>(kind: .label)
                        CreateNewEntityButton<Product>(kind: .label)
                        CreateNewEntityButton<Ingredient>(kind: .label)
                        CreateNewEntityButton<Employee>(kind: .label)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("CreateNewEntityButton", displayMode: .inline)
                .navigationBarItems(
                    leading: CreateEntityPickerButton(factory: nil, isTabItem: true),
                    trailing: HStack {
                        CreateNewEntityButton<Packaging>(useSheet: true)
                        CreateNewEntityButton<Packaging>(useSheet: false)
                        CreateNewEntityButton<Employee>()
                    }
                )
            }
            .previewLayout(.fixed(width: 350, height: 600))
            
            NavigationView {
                ScrollView {
                    VStack {
                        CreateNewEntityButton<Base>(kind: .label)
                        Divider()
                        CreateNewEntityButton<Base>(isPresented: $isPresented)
                        CreateNewEntityButton<Packaging>(isPresented: $isPresented)
                        CreateNewEntityButton<Utility>(isPresented: $isPresented)
                    }
                    .padding(.horizontal)
                    .navigationBarTitle("CreateNewEntityButton", displayMode: .inline)
                    .navigationBarItems(
                        leading: CreateEntityPickerButton(factory: nil, isTabItem: true),
                        trailing:
                            HStack {
                                CreateNewEntityButton<Base>()
                                CreateNewEntityButton<Utility>()
                            }
                    )
                }
            }
            .previewLayout(.fixed(width: 350, height: 720))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
