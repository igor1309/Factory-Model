//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct FactoryList: View {
    @Environment(\.managedObjectContext) var moc
    
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
                        ListRow(factory, useSmallerFont: false)
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
            let factory = factories[index]
            moc.delete(factory)
        }
        
        moc.saveContext()
    }
    
    private func delete(_ factory: Factory) {
        moc.delete(factory)
        moc.saveContext()
    }
    
    private var plusButton: some View {
        Button {
            //  MARK: FINISH THIS
            let factory = Factory(context: moc)
            factory.name = "New Factory"
            factory.note = "Some note regarding the factory"
            
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private var plusSampleButton: some View {
        Button {
            //  MARK: - Factory 1
            
            let factory1 = Factory(context: moc)
            factory1.name = "Сыроварня"
            factory1.note = "Тестовый проект"
            
            let base1_1 = createBase1_1()
            base1_1.factory = factory1
            
            let sales1_1 = Sales(context: moc)
            sales1_1.buyer = "Speelo Group"
            sales1_1.priceExVAT = 300
            sales1_1.qty = 1_000
            
            let product1_1 = Product(context: moc)
            product1_1.code = "У001"
            product1_1.name = "Ведёрко 1 кг"
            product1_1.note = "..."
            product1_1.baseQty = 1_000
            product1_1.base = base1_1
            product1_1.group = "Ведёрко"
            product1_1.vat = 10/100
            
            product1_1.addToSales_(sales1_1)
            
            //            factory1.addToBases_(base1_1)
            
            product1_1.productionQty = 3_000
            
            let utility1 = Utility(context: moc)
            utility1.name = "Электроэнергия"
            utility1.priceExVAT = 10
            
            base1_1.utilities = [utility1]
            
            let product1_2 = Product(context: moc)
            product1_2.code = "У002"
            product1_2.name = "Вакуум"
            product1_2.note = "..."
            product1_2.baseQty = 750
            product1_2.base = base1_1
            product1_2.group = "Вакуум"
            product1_2.vat = 10/100
            
            //            factory1.addToProducts_(product1_2)
            
            let base2 = createBase1_2()
            base2.factory = factory1
            
            let base3 = Base(context: moc)
            base3.name = "Творог"
            base3.code = "2001"
            base3.group = "Твороги"
            base3.factory = factory1
            
            let departments = createDepartments1()
            for department in departments {
                factory1.addToDepartments_(department)
            }
            
            factory1.expenses = createExpenses1()
            
            let equipment = Equipment(context: moc)
            equipment.name = "Сырная линия"
            equipment.note = "Основная производственная линия"
            equipment.price = 7_000_000
            equipment.lifetime = 7
            
            factory1.equipments = [equipment]
            
            //  MARK: - Factory 2
            
            let factory2 = Factory(context: moc)
            factory2.name = "Полуфабрикаты"
            factory2.note = "Фабрика Полуфабрикатов: заморозка и прочее"
            
            let base2_1 = createBase2_1()
            base2_1.factory = factory2
            
            let sales2_1_1 = Sales(context: moc)
            sales2_1_1.buyer = "METRO"
            sales2_1_1.qty = 1_000
            sales2_1_1.priceExVAT = 230
            
            let product2_1 = Product(context: moc)
            product2_1.name = "Настоящие"
            product2_1.baseQty = 12
            product2_1.group = "Контейнер"
            product2_1.vat = 10/100
            
            product2_1.sales = [sales2_1_1]
            product2_1.base = base2_1
            
            //            factory2.addToProducts_(product2_1)
            
            moc.saveContext()
        } label: {
            Image(systemName: "plus.square")
                .padding([.leading, .vertical])
        }
    }
    
    private func createBase1_1() -> Base {
        let base1 = Base(context: moc)
        base1.name = "Сулугуни"
        base1.note = "Первый продукт"
        base1.code = "1001"
        base1.group = "Сыры"
        base1.unit = .weight
        base1.weightNetto = 1_000
        
        let feedstock1 = Feedstock(context: moc)
        feedstock1.name = "Молоко натуральное"
        feedstock1.priceExVAT = 30.0
        feedstock1.qty = 1
        
        let feedstock2 = Feedstock(context: moc)
        feedstock2.name = "Сухое молоко"
        feedstock2.priceExVAT = 70
        feedstock2.qty = 1
        
        let feedstock3 = Feedstock(context: moc)
        feedstock3.name = "Хлористый кальций"
        
        let feedstock4 = Feedstock(context: moc)
        feedstock4.name = "Бактериальная заправка"
        
        let feedstock5 = Feedstock(context: moc)
        feedstock5.name = "Сычужная заправка (?)"
        feedstock5.priceExVAT = 8000
        feedstock5.qty = 0.5 / 1000
        
        let feedstock6 = Feedstock(context: moc)
        feedstock6.name = "Пепсин"
        
        let feedstock7 = Feedstock(context: moc)
        feedstock7.name = "Соль"
        feedstock7.priceExVAT = 20
        feedstock7.qty = 1.5
        
        let feedstock8 = Feedstock(context: moc)
        feedstock8.name = "Вода"
        feedstock8.priceExVAT = 1
        feedstock8.qty = 1
        
        base1.feedstocks = [feedstock1, feedstock2, feedstock3, feedstock4, feedstock5, feedstock6, feedstock7, feedstock8]
        
        return base1
    }
    
    private func createBase1_2() -> Base {
        let base2 = Base(context: moc)
        base2.name = "Имеретинский"
        base2.code = "1002"
        base2.group = "Сыры"
        
        let feedstock21 = Feedstock(context: moc)
        feedstock21.name = "Вода"
        feedstock21.qty = 2
        feedstock21.priceExVAT = 1
        
        base2.feedstocks = [feedstock21]
        
        return base2
    }
    
    private func createDepartments1() -> [Department] {
        let department1 = Department(context: moc)
        department1.name = "Технологии"
        department1.division = "Производство"
        department1.type = .production
        
        let staff1 = Staff(context: moc)
        staff1.position = "Главный технолог"
        staff1.name = "Гурам Галихадзе"
        staff1.salary = 60_000
        
        department1.addToStaffs_(staff1)
        
        let department2 = Department(context: moc)
        department1.name = "Производственный цех"
        department1.division = "Производство"
        department2.type = .production
        
        let staff2 = Staff(context: moc)
        staff2.position = "Старший сыродел"
        staff2.name = "Мамука Гелашвили"
        staff2.salary = 45_000
        
        department2.addToStaffs_(staff2)
        
        let staff3 = Staff(context: moc)
        staff3.position = "Сыродел"
        staff3.name = "Василий Васильев"
        staff3.salary = 35_000
        
        department2.addToStaffs_(staff3)
        
        let department3 = Department(context: moc)
        department3.division = "Продажи"
        department3.name = "Отдел логистики"
        department3.type = .sales
        
        let staff4 = Staff(context: moc)
        staff4.position = "Водитель"
        staff4.name = "Иван Иванов"
        staff4.salary = 35_000
        
        department3.addToStaffs_(staff4)
        
        let department4 = Department(context: moc)
        department4.division = "Администрация"
        department4.name = "Администрация"
        department4.type = .management
        
        let staff5 = Staff(context: moc)
        staff5.position = "Директор + закупки"
        staff5.name = "Петр Петров"
        staff5.salary = 60_000
        
        department4.addToStaffs_(staff5)
        
        let department5 = Department(context: moc)
        department5.division = "Администрация"
        department5.name = "Бухгалтерия"
        department5.type = .management
        
        let staff6 = Staff(context: moc)
        staff6.position = "Главный бухгалтер"
        staff6.name = "Мальвина Петровна"
        staff6.salary = 30_000
        
        department5.addToStaffs_(staff6)
        
        return [department1, department2, department3, department4, department5]
    }
    
    private func createExpenses1() -> [Expenses] {
        let expenses1 = Expenses(context: moc)
        expenses1.name = "Связь"
        expenses1.amount = 15_000
        
        let expenses2 = Expenses(context: moc)
        expenses2.name = "Потери, брак"
        expenses2.amount = 50_000
        
        let expenses3 = Expenses(context: moc)
        expenses3.name = "СЭС (анализы и др.)"
        expenses3.amount = 5_000
        
        let expenses4 = Expenses(context: moc)
        expenses4.name = "Текущий  ремонт и обслуживание основных средств"
        expenses4.amount = 20_000
        
        let expenses5 = Expenses(context: moc)
        expenses5.name = "Банковские услуги"
        expenses5.amount = 5_000
        
        let expenses6 = Expenses(context: moc)
        expenses6.name = "Офисные и другие расходы"
        expenses6.amount = 10_000
        
        let expenses7 = Expenses(context: moc)
        expenses7.name = "Аренда"
        expenses7.amount = 50_000
        
        return [expenses1, expenses2, expenses3, expenses4, expenses5, expenses6, expenses7]
    }
    
    private func createBase2_1() -> Base {
        let base = Base(context: moc)
        base.name = "Хинкали"
        base.group = "Заморозка"
        base.unit_ = "piece"
        base.weightNetto = 60
        
        let feedstock1 = Feedstock(context: moc)
        feedstock1.name = "Мука"
        
        let feedstock2 = Feedstock(context: moc)
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
