//
//  Division Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 25.08.2020.
//

import CoreData

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
        
        //  Production
        
        let department1 = Department.createDepartment1(in: context)
        department1.division = divisionProduction
        
        let department2 = Department.createDepartment2(in: context)
        department2.division = divisionProduction//"Производство"
        
        
        //  Sales
        
        let department3 = Department.createDepartment3(in: context)
        department3.division = divisionSales
        
        
        //  Management
        
        let department4 = Department.createDepartment4(in: context)
        department4.division = divisionHQ
        
        let department5 = Department.createDepartment5(in: context)
        department5.division = divisionHQ// "Администрация"
                
        context.saveContext()
        
        return [divisionProduction, divisionSales, divisionHQ]
    }
}
