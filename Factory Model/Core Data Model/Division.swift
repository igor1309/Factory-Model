//
//  Division.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import Foundation
import CoreData

extension Division: Comparable {
    var departments: [Department] {
        get { (departments_ as? Set<Department> ?? []).sorted() }
        set { departments_ = Set(newValue) as NSSet }
    }
    
    var departmentNames: String {
        departments.map { $0.name }.joined(separator: ", ")
    }
    
    var headcount: Int { departments.reduce(0, { $0 + $1.headcount }) }
    
    var totalSalary: Double {
        departments
            .flatMap { $0.workers }
            .map { $0.salary}
            .reduce(0, +)
    }
    var totalSalaryWithTax: Double {
        departments
            .flatMap { $0.workers }
            .map { $0.salaryWithTax}
            .reduce(0, +)
    }

    public static func < (lhs: Division, rhs: Division) -> Bool {
        lhs.name < rhs.name
    }
    
    static func createDivisions(in context: NSManagedObjectContext) -> [Division] {
        //  MARK: - Divisions
        
        let divisionProduction = Division(context: context)
        divisionProduction.name = "Производство"
        
        let divisionSales = Division(context: context)
        divisionSales.name = "Продажи"
        
        let divisionHQ = Division(context: context)
        divisionHQ.name = "Администрация"
        
        //  MARK: - Departments
        
        let department1 = Department(context: context)
        department1.name = "Технологии"
        department1.division = divisionProduction
        department1.type = .production
        
        let worker1 = Worker(context: context)
        worker1.position = "Главный технолог"
        worker1.name = "Гурам Галихадзе"
        worker1.salary = 60_000
        
        department1.addToWorkers_(worker1)
        
        let department2 = Department(context: context)
        department1.name = "Производственный цех"
        department1.division = divisionProduction//"Производство"
        department2.type = .production
        
        let worker2 = Worker(context: context)
        worker2.position = "Старший сыродел"
        worker2.name = "Мамука Гелашвили"
        worker2.salary = 45_000
        
        department2.addToWorkers_(worker2)
        
        let worker3 = Worker(context: context)
        worker3.position = "Сыродел"
        worker3.name = "Василий Васильев"
        worker3.salary = 35_000
        
        department2.addToWorkers_(worker3)
        
        let department3 = Department(context: context)
        department3.division = divisionSales
        department3.name = "Отдел логистики"
        department3.type = .sales
        
        let worker4 = Worker(context: context)
        worker4.position = "Водитель"
        worker4.name = "Иван Иванов"
        worker4.salary = 35_000
        
        department3.addToWorkers_(worker4)
        
        let department4 = Department(context: context)
        department4.division = divisionHQ
        department4.name = "Администрация"
        department4.type = .management
        
        let worker5 = Worker(context: context)
        worker5.position = "Директор + закупки"
        worker5.name = "Петр Петров"
        worker5.salary = 60_000
        
        department4.addToWorkers_(worker5)
        
        let department5 = Department(context: context)
        department5.division = divisionHQ// "Администрация"
        department5.name = "Бухгалтерия"
        department5.type = .management
        
        let worker6 = Worker(context: context)
        worker6.position = "Главный бухгалтер"
        worker6.name = "Мальвина Петровна"
        worker6.salary = 30_000
        
        department5.addToWorkers_(worker6)
        
        return [divisionProduction, divisionSales, divisionHQ]
    }
}
