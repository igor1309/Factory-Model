//
//  Issues.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import Foundation

extension Factory {
    //  MARK: - hasIssues - kinda integrity checker
    //  MARK: - FINISH THIS TO WORK IT NEEDS FETCHING!!!!
    var hasIssues: Bool {
        //  MARK: - FINISH THIS
        expensesHasIssues || equipmentsHasIssues || divisionsHasIssues || departmentsHasIssues || employeesHasIssues || basesHasIssues || buyersHasIssues || ingredientsHasIssues || salesHasIssues || packagingsHasIssues
    }
    var expensesHasIssues: Bool {
        !expenses.allSatisfy { $0.isValid == true }
    }
    var equipmentsHasIssues: Bool {
        !equipments.allSatisfy { $0.isValid == true }
    }
    var divisionsHasIssues: Bool {
        !divisions.allSatisfy { $0.isValid == true }
    }
    var departmentsHasIssues: Bool {
        !divisions
            .flatMap { $0.departments }
            .allSatisfy { $0.isValid == true }
    }
    var employeesHasIssues: Bool {
        !employees.allSatisfy { $0.isValid == true }
    }
    var basesHasIssues: Bool {
        !bases.allSatisfy { $0.isValid == true }
    }
    var buyersHasIssues: Bool {
        !buyers.allSatisfy { $0.isValid == true }
    }
    var ingredientsHasIssues: Bool {
        !ingredients.allSatisfy { $0.isValid == true }
    }
    var salesHasIssues: Bool {
        !sales.allSatisfy { $0.isValid == true }
    }
    var packagingsHasIssues: Bool {
        !packagings.allSatisfy { $0.isValid == true }
    }
}
