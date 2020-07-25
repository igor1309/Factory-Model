//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct FactoryList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Factory.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Factory.name_, ascending: true),
        ]
    ) private var factories: FetchedResults<Factory>
    
    @State private var showDeleteAction = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(factories, id: \.objectID) { factory in
                    NavigationLink(
                        destination: FactoryView(factory)
                    ) {
                        ListRow(
                            title: factory.name,
                            subtitle: factory.note,
                            icon: "gearshape",
                            useSmallerFont: false
                        )
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
        
        managedObjectContext.saveContext()
    }
    
    private func delete(_ factory: Factory) {
        managedObjectContext.delete(factory)
        managedObjectContext.saveContext()
    }
    
    private var plusButton: some View {
        Button {
            //  MARK: FINISH THIS
            let factory = Factory(context: managedObjectContext)
            factory.name = "New Factory"
            factory.note = "Some note regarding the factory"
            
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private var plusSampleButton: some View {
        Button {
            //  MARK: - Factory 1
            
            let factory1 = Factory(context: managedObjectContext)
            factory1.name = "Сыроварня"
            factory1.note = "Тестовый проект"
            
            let base1_1 = createBase1_1()
            
            let sales1_1 = Sales(context: managedObjectContext)
            sales1_1.buyer = "Speelo Group"
            sales1_1.priceExVAT = 300
            sales1_1.qty = 1_000
                        
            let packaging1_1 = Packaging(context: managedObjectContext)
            packaging1_1.code = "У001"
            packaging1_1.name = "Ведёрко 1 кг"
            packaging1_1.note = "..."
            packaging1_1.baseQty = 1_000
            packaging1_1.base = base1_1
            packaging1_1.type = "Ведёрко"
            packaging1_1.vat = 10/100

            packaging1_1.addToSales_(sales1_1)

            factory1.addToPackagings_(packaging1_1)
            
            let production1 = Production(context: managedObjectContext)
            production1.qty = 3_000
            production1.packaging = packaging1_1
            
            let utility1 = Utility(context: managedObjectContext)
            utility1.name = "Электроэнергия"
            utility1.priceExVAT = 10
            
            base1_1.utilities = [utility1]
            
            
            let packaging1_2 = Packaging(context: managedObjectContext)
            packaging1_2.code = "У002"
            packaging1_2.name = "Вакуум"
            packaging1_2.note = "..."
            packaging1_2.baseQty = 750
            packaging1_2.base = base1_1
            packaging1_2.type = "Вакуум"
            packaging1_2.vat = 10/100
            
            factory1.addToPackagings_(packaging1_2)
            
            let base2 = createBase1_2()
            factory1.addToBases_(base2)
            
            let base3 = Base(context: managedObjectContext)
            base3.name = "Творог"
            base3.code = "2001"
            base3.group = "Твороги"
                        
            factory1.staff = createStaff1()
            
            factory1.expenses = createExpenses1()
            
            let equipment = Equipment(context: managedObjectContext)
            equipment.name = "Сырная линия"
            equipment.note = "Основная производственная линия"
            equipment.price = 7_000_000
            equipment.lifetime = 7
            
            factory1.equipments = [equipment]
            
            //  MARK: - Factory 2
            
            let factory2 = Factory(context: managedObjectContext)
            factory2.name = "Фабрика Полуфабрикатов"
            factory2.note = "Заморозка и прочее"
            
            let base2_1 = createBase2_1()
            
            let sales2_1_1 = Sales(context: managedObjectContext)
            sales2_1_1.buyer = "METRO"
            sales2_1_1.qty = 1_000
            sales2_1_1.priceExVAT = 230
            
            let packaging2_1 = Packaging(context: managedObjectContext)
            packaging2_1.name = "Хинкали, 12 шт"
            packaging2_1.baseQty = 12
            packaging2_1.type = "Контейнер"
            packaging2_1.vat = 10/100
            
            packaging2_1.sales = [sales2_1_1]
            packaging2_1.base = base2_1
            
            factory2.addToPackagings_(packaging2_1)
            
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus.square")
                .padding([.leading, .vertical])
        }
    }
    
    private func createBase1_1() -> Base {
        let base1 = Base(context: managedObjectContext)
        base1.name = "Сулугуни"
        base1.note = "Первый продукт"
        base1.code = "1001"
        base1.group = "Сыры"
        base1.unit = .weight
        base1.weightNetto = 1_000
        
        let feedstock1 = Feedstock(context: managedObjectContext)
        feedstock1.name = "Молоко натуральное"
        feedstock1.priceExVAT = 30.0
        feedstock1.qty = 1
        
        let feedstock2 = Feedstock(context: managedObjectContext)
        feedstock2.name = "Сухое молоко"
        feedstock2.priceExVAT = 70
        feedstock2.qty = 1
        
        let feedstock3 = Feedstock(context: managedObjectContext)
        feedstock3.name = "Хлористый кальций"
        
        let feedstock4 = Feedstock(context: managedObjectContext)
        feedstock4.name = "Бактериальная заправка"
        
        let feedstock5 = Feedstock(context: managedObjectContext)
        feedstock5.name = "Сычужная заправка (?)"
        feedstock5.priceExVAT = 8000
        feedstock5.qty = 0.5 / 1000
        
        let feedstock6 = Feedstock(context: managedObjectContext)
        feedstock6.name = "Пепсин"
        
        let feedstock7 = Feedstock(context: managedObjectContext)
        feedstock7.name = "Соль"
        feedstock7.priceExVAT = 20
        feedstock7.qty = 1.5
        
        let feedstock8 = Feedstock(context: managedObjectContext)
        feedstock8.name = "Вода"
        feedstock8.priceExVAT = 1
        feedstock8.qty = 1
        
        base1.feedstocks = [feedstock1, feedstock2, feedstock3, feedstock4, feedstock5, feedstock6, feedstock7, feedstock8]
        
        return base1
    }
    
    private func createBase1_2() -> Base {
        let base2 = Base(context: managedObjectContext)
        base2.name = "Имеретинский"
        base2.code = "1002"
        base2.group = "Сыры"
        
        let feedstock21 = Feedstock(context: managedObjectContext)
        feedstock21.name = "Вода"
        feedstock21.qty = 2
        feedstock21.priceExVAT = 1
        
        base2.feedstocks = [feedstock21]
        
        return base2
    }
    
    private func createStaff1() -> [Staff] {
        let staff1 = Staff(context: managedObjectContext)
        staff1.division = "Производство"
        staff1.department = "Технологии"
        staff1.position = "Главный технолог"
        staff1.name = "Гурам Галихадзе"
        staff1.salary = 60_000
        
        let staff2 = Staff(context: managedObjectContext)
        staff2.division = "Производство"
        staff2.department = "Производственный цех"
        staff2.position = "Старший сыродел"
        staff2.name = "Мамука Гелашвили"
        staff2.salary = 45_000
        
        let staff3 = Staff(context: managedObjectContext)
        staff3.division = "Производство"
        staff3.department = "Производственный цех"
        staff3.position = "Сыродел"
        staff3.name = "Василий Васильев"
        staff3.salary = 35_000
        
        let staff4 = Staff(context: managedObjectContext)
        staff4.division = "Продажи"
        staff4.department = "Отдел логистики"
        staff4.position = "Водитель"
        staff4.name = "Иван Иванов"
        staff4.salary = 35_000
        
        let staff5 = Staff(context: managedObjectContext)
        staff5.division = "Администрация"
        staff5.department = "Администрация"
        staff5.position = "Директор + закупки"
        staff5.name = "Петр Петров"
        staff5.salary = 60_000
        
        let staff6 = Staff(context: managedObjectContext)
        staff6.division = "Администрация"
        staff6.department = "Бухгалтерия"
        staff6.position = "Главный бухгалтер"
        staff6.name = "Мальвина Петровна"
        staff6.salary = 30_000
        
        return [staff1, staff2, staff3, staff4, staff5, staff6]
    }
    
    private func createExpenses1() -> [Expenses] {
        let expenses1 = Expenses(context: managedObjectContext)
        expenses1.name = "Связь"
        expenses1.amount = 15_000
        
        let expenses2 = Expenses(context: managedObjectContext)
        expenses2.name = "Потери, брак"
        expenses2.amount = 50_000
        
        let expenses3 = Expenses(context: managedObjectContext)
        expenses3.name = "СЭС (анализы и др.)"
        expenses3.amount = 5_000
        
        let expenses4 = Expenses(context: managedObjectContext)
        expenses4.name = "Текущий  ремонт и обслуживание основных средств"
        expenses4.amount = 20_000
        
        let expenses5 = Expenses(context: managedObjectContext)
        expenses5.name = "Банковские услуги"
        expenses5.amount = 5_000
        
        let expenses6 = Expenses(context: managedObjectContext)
        expenses6.name = "Офисные и другие расходы"
        expenses6.amount = 10_000
        
        let expenses7 = Expenses(context: managedObjectContext)
        expenses7.name = "Аренда"
        expenses7.amount = 50_000
        
        return [expenses1, expenses2, expenses3, expenses4, expenses5, expenses6, expenses7]
    }
    
    private func createBase2_1() -> Base {
        let base = Base(context: managedObjectContext)
        base.name = "Хинкали"
        base.group = "Заморозка"
        base.unit_ = "piece"
        base.weightNetto = 60
        
        let feedstock1 = Feedstock(context: managedObjectContext)
        feedstock1.name = "Мука"
        
        let feedstock2 = Feedstock(context: managedObjectContext)
        feedstock2.name = "Мясо"
        
        base.feedstocks = [feedstock1, feedstock2]
        
        return base
    }
}

struct FactoryList_Previews: PreviewProvider {
    static var previews: some View {
        FactoryList()
            //            .environmentObject(PersistenceManager())
            .environment(\.managedObjectContext, PersistenceManager(containerName: "Preview").viewContext)
            .preferredColorScheme(.dark)
    }
}
