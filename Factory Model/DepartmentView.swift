//
//  WorkerRowWithList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI

struct DepartmentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var department: Department
    
    init(for department: Department) {
        self.department = department
    }
    
    var body: some View {
        ListWithDashboard(
            title: department.name,
            parent: department,
            keyPath: \Department.workers_,
            
            //  MARK: - FINISH THIS
            //  should be `default` predicate
            //            format: "%K == %@", #keyPath(Product.base.factory), factory
            
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Worker.department), department
                )
            
            
            
        ) {
            CreateChildButton(
                systemName: "person.badge.plus",
                childType: Worker.self,
                parent: department,
                keyPath: \Department.workers_
            )
        } dashboard: {
            Section(
                header: Text("Department")
            ) {
                Group {
                    TextField("Department Name", text: $department.name)
                        .foregroundColor(.accentColor)
                    
                    Picker("Type", selection: $department.type) {
                        ForEach(Department.DepartmentType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                        //                    .pickerStyle(SegmentedPickerStyle())
                    }
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                }
            }
            
            Section(
                header: Text("Division"),
                footer: Text("Division could be changed.")
            ) {
                Group {
                    EntityPicker(
                        //                        context: _moc,
                        selection: $department.division,
                        //icon: <#T##String?#>,
                        /// fetching all `Divisions` for factory starting search from department
                        /// department <<--> division <<--> factory
                        /// factory <-->> division <-->> department
                        predicate:
                            {
                                return nil
                                
                                //                                let p = NSPredicate(
                                //                                    format: "%K.division.factory.divisions_ == %@", department
                                //                                )
                                //
                                //                                let factoryPredicate = NSPredicate(format: "SUBQUERY(divisions_, $division, ANY $division.departments == %@).@count > 0", department)
                                //                                return NSPredicate(format: "factory IN \(factoryPredicate)")
                                //                                let divisionsPredicate =
                                //                                   return NSPredicate(format: "SUBQUERY(divisions_, $division, $division.department == %@).@count > 0", department)
                                //                                return NSPredicate(format: "SUBQUERY(factories, $factory, $factory.division IN \(divisionsPredicate)).@count > 0")
                                
                                //                            NSPredicate(
                                //                            format: "SUBQUERY()", department
                                //format: "ANY %K.factory == %@", #keyPath(Division), department.division_
                                //                        )
                            }()
                    )
                }
                //  .foregroundColor(.secondary) not .foregroundColor(.accentColor) to hide (diminish possibility of changing Department
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section {
                Group {
                    LabelWithDetail("person.crop.rectangle", "Total Headcount", "TBD")
                    
                    LabelWithDetail("dollarsign.square", "Total Salary incl taxes", "TBD")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
        } editor: { (worker: Worker) in
                WorkerView(worker)
            }
        }
}
