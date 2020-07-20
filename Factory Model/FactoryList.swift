//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct FactoryList: View {
    //    @EnvironmentObject var persistence: PersistenceManager
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Factory.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Factory.name_, ascending: true),
        ]
    ) var factories: FetchedResults<Factory>
    
    @State private var showDeleteAction = false
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(factories, id: \.self) { factory in
                    NavigationLink(
                        destination: FactoryView(factory)
                    ) {
                        ListRow(title: factory.name, subtitle: factory.note, icon: "gearshape")
                            .contextMenu {
                                Button {
                                    showDeleteAction = true
                                } label: {
                                    Image(systemName: "trash.circle")
                                    Text("Delete")
                                }
                            }
                            .actionSheet(isPresented: $showDeleteAction) {
                                ActionSheet(
                                    title: Text("Delete?".uppercased()),
                                    message: Text("Do you really want to delete '\(factory.name)'?\nThis cannot be undone."),
                                    buttons: [
                                        .destructive(Text("Yes, delete")) { delete(factory) },
                                        .cancel()
                                    ]
                                )
                            }
                    }
                }
                .onDelete(perform: removeFactories)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Factories")
            .navigationBarItems(
                trailing: HStack {
                    plusSampleButton
                    plusButton
                }
            )
        }
    }
    
    private func removeFactories(at offsets: IndexSet) {
        for index in offsets {
            let language = factories[index]
            managedObjectContext.delete(language)
        }
        
        save()
    }
    
    private func delete(_ factory: Factory) {
        managedObjectContext.delete(factory)
        save()
    }

    private var plusButton: some View {
        Button {
            //  MARK: FINISH THIS
            let factory = Factory(context: managedObjectContext)
            factory.name = "New Factory"
            factory.note = "Some note regarding the factory"
            
            save()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
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
    
    private var plusSampleButton: some View {
        Button {
            //  MARK: FINISH THIS
            let factory = Factory(context: managedObjectContext)
            factory.name = "Сыроварня"
            factory.note = "Тестовый проект"
            
            let product1 = Product(context: managedObjectContext)
            product1.name = "Сулугуни 1 кг"
            product1.note = "Первый продукт"
            product1.code = "1001"
            product1.group = "Сыры"
            product1.weightNetto = 1000
            
            let feedstock1 = Feedstock(context: managedObjectContext)
            feedstock1.name = "Молоко"
            //feedstock1.price = 30.0
            feedstock1.qty = 1
            
            let feedstock2 = Feedstock(context: managedObjectContext)
            feedstock2.name = "Сухое молоко"
            feedstock2.qty = 1
            
            product1.feedstock = [feedstock1, feedstock2]
            
            let product2 = Product(context: managedObjectContext)
            product2.name = "Сулугуни 0.5 кг"
            product2.code = "1002"
            product2.group = "Сыры"
            
            let product3 = Product(context: managedObjectContext)
            product3.name = "Творог"
            product3.code = "2001"
            product3.group = "Творог"
            
            factory.products = [product1, product2, product3]
            
            let staff1 = Staff(context: managedObjectContext)
            staff1.division = "Производство"
            staff1.department = "Технологии"
            staff1.position = "Главный технолог"
            staff1.salary = 60_000
            
            let staff2 = Staff(context: managedObjectContext)
            staff2.division = "Производство"
            staff2.department = "Производственный цех"
            staff2.position = "Старший сыродел"
            staff2.salary = 45_000
            
            let staff3 = Staff(context: managedObjectContext)
            staff3.division = "Производство"
            staff3.department = "Производственный цех"
            staff3.position = "Сыродел"
            staff3.salary = 35_000
            
            let staff4 = Staff(context: managedObjectContext)
            staff4.division = "Продажи"
            staff4.department = "Отдел логистики"
            staff4.position = "Водитель"
            staff4.salary = 35_000
            
            let staff5 = Staff(context: managedObjectContext)
            staff5.division = "Администрация"
            staff5.department = "Администрация"
            staff5.position = "Директор + закупки"
            staff5.salary = 60_000
            
            let staff6 = Staff(context: managedObjectContext)
            staff6.division = "Администрация"
            staff6.department = "Бухгалтерия"
            staff6.position = "Главный бухгалтер"
            staff6.salary = 30_000
            
            factory.staff = [staff1, staff2, staff3, staff4, staff5, staff6]
            factory.expenses = []
            factory.equipment = []
            save()
        } label: {
            Image(systemName: "plus.square")
                .padding([.leading, .vertical])
        }
    }
}

struct FactoryList_Previews: PreviewProvider {
    static var previews: some View {
        FactoryList()
            //            .environmentObject(PersistenceManager())
            .environment(\.managedObjectContext, PersistenceManager().persistentContainer.viewContext)
            .preferredColorScheme(.dark)
    }
}
