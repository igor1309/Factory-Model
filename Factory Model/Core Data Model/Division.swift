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
        departments.map(\.name).joined(separator: ", ")
    }
    
    var headcount: Int {
        departments.reduce(0) { $0 + $1.headcount }
    }
    
    var salary: Double {
        departments.reduce(0) { $0 + $1.salary}
    }
    var salaryWithTax: Double {
        departments.reduce(0) { $0 + $1.salaryWithTax}
    }
    
    public static func < (lhs: Division, rhs: Division) -> Bool {
        lhs.name < rhs.name
    }
}

extension Division {
    static func createSampleDivisions(in context: NSManagedObjectContext) -> [Division] {
        
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
        
        let department2 = Department(context: context)
        department2.name = "Производственный цех"
        department2.division = divisionProduction//"Производство"
        department2.type = .production
        
        let department3 = Department(context: context)
        department3.division = divisionSales
        department3.name = "Отдел логистики"
        department3.type = .sales
        
        let department4 = Department(context: context)
        department4.division = divisionHQ
        department4.name = "Администрация"
        department4.type = .management
        
        let department5 = Department(context: context)
        department5.division = divisionHQ// "Администрация"
        department5.name = "Бухгалтерия"
        department5.type = .management
        
        //  MARK: - Employees
        
        let employee1 = Employee(context: context)
        employee1.position = "Главный технолог"
        employee1.department = department1
        employee1.name = "Гурам Галихадзе"
        employee1.salary = 60_000
        employee1.workHours = 168
        
        let employee2 = Employee(context: context)
        employee2.position = "Старший сыродел"
        employee2.department = department2
        employee2.name = "Мамука Гелашвили"
        employee2.salary = 45_000
        employee2.workHours = 168
        
        let employee3 = Employee(context: context)
        employee3.position = "Сыродел"
        employee3.department = department2
        employee3.name = "Василий Васильев"
        employee3.salary = 35_000
        employee3.workHours = 168
        
        let employee4 = Employee(context: context)
        employee4.position = "Водитель"
        employee4.department = department3
        employee4.name = "Иван Иванов"
        employee4.salary = 35_000
        employee4.workHours = 168
        
        let employee5 = Employee(context: context)
        employee5.position = "Директор + закупки"
        employee5.department = department4
        employee5.name = "Петр Петров"
        employee5.salary = 60_000
        employee5.workHours = 168
        
        let employee6 = Employee(context: context)
        employee6.position = "Главный бухгалтер"
        employee6.department = department5
        employee6.name = "Мальвина Петровна"
        employee6.salary = 30_000
        employee6.workHours = 168
        
        return [divisionProduction, divisionSales, divisionHQ]
    }
}
