//
//  IssuesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI

struct IssuesList: View {
    
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            //  MARK: - FINISH THIS hasIssues does not work - need to use fetch
            
            Group {
                //            if factory.basesHasIssues {
                GenericListSection(type: Base.self, predicate: Base.orphanPredicate)
                //            }
                //            if factory.buyersHasIssues {
                GenericListSection(type: Buyer.self, predicate: Buyer.orphanPredicate)
                //            }
                //            if factory.departmentsHasIssues {
                GenericListSection(type: Department.self, predicate: Department.orphanPredicate)
                //            }
                
                //                if factory.departmentsHasIssues {
                GenericListSection(type: Division.self, predicate: Division.orphanPredicate)
                //                }
                
                //            if factory.equipmentsHasIssues {
                GenericListSection(type: Equipment.self, predicate: Equipment.orphanPredicate)
                //            }
                
                //            if factory.expensesHasIssues {
                GenericListSection(type: Expenses.self, predicate: Expenses.orphanPredicate)
                //            }
                
                //            if factory.ingredientsHasIssues {
                GenericListSection(type: Ingredient.self, predicate: Ingredient.orphanPredicate)
                //            }
            }
            
            Group {
                //            if factory.recipesHasIssues {
                GenericListSection(type: Recipe.self, predicate: Recipe.orphanPredicate)
                //            }
                
                //            if factory.packagingsHasIssues {
                GenericListSection(type: Packaging.self, predicate: Packaging.orphanPredicate)
                //            }
                
                //            if factory.packagingsHasIssues {
                GenericListSection(type: Product.self, predicate: Product.orphanPredicate)
                //            }
                //            if factory.salesHasIssues {
                GenericListSection(type: Sales.self, predicate: Sales.orphanPredicate)
                //            }
                
                //            if factory.utilitiesHasIssues {
                GenericListSection(type: Utility.self, predicate: Utility.orphanPredicate)
                //            }
                
                //            if factory.employeesHasIssues {
                GenericListSection(type: Employee.self, predicate: Employee.orphanPredicate)
                //            }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Issues")
    }
}

struct IssuesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IssuesList(for: Factory.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
