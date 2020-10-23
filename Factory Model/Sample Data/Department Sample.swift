//
//  Department Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.10.2020.
//

import CoreData

extension Department {
    
    //  MARK: - Departments
    
    //  Production
    
    static func createDepartment1(in context: NSManagedObjectContext) -> Department {
        let department1 = Department(context: context)
        department1.name = "Технологии"
        department1.type = .production
        department1.addToEmployees_(Employee.createEmployee1(in: context))
        
        context.saveContext()
        
        return department1
    }
    
    static func createDepartment2(in context: NSManagedObjectContext) -> Department {
        let department2 = Department(context: context)
        department2.name = "Производственный цех"
        department2.type = .production
        department2.addToEmployees_(Employee.createEmployee2(in: context))
        department2.addToEmployees_(Employee.createEmployee3(in: context))
        
        context.saveContext()
        
        return department2
    }
    
    
    //  Sales
    
    static func createDepartment3(in context: NSManagedObjectContext) -> Department {
        let department3 = Department(context: context)
        department3.name = "Отдел логистики"
        department3.type = .sales
        department3.addToEmployees_(Employee.createEmployee4(in: context))
        
        context.saveContext()
        
        return department3
    }
    
    
    //  Management
    
    static func createDepartment4(in context: NSManagedObjectContext) -> Department {
        let department4 = Department(context: context)
        department4.name = "Администрация"
        department4.type = .management
        department4.addToEmployees_(Employee.createEmployee5(in: context))
        
        context.saveContext()
        
        return department4
    }
    
    static func createDepartment5(in context: NSManagedObjectContext) -> Department {
        let department5 = Department(context: context)
        department5.name = "Бухгалтерия"
        department5.type = .management
        department5.addToEmployees_(Employee.createEmployee6(in: context))
        
        context.saveContext()
        
        return department5
    }
    
}


