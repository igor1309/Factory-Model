//
//  WorkerView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct WorkerView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var worker: Worker
    
    //    @FetchRequest private var factoryWorker: FetchedResults<Worker>
    
    init(_ worker: Worker) {
        self.worker = worker
        //        _factoryWorker = FetchRequest(
        //            entity: Worker.entity(),
        //            sortDescriptors: [
        //                //                NSSortDescriptor(keyPath: \Worker.division_, ascending: true),
        //                //                NSSortDescriptor(keyPath: \Worker.department_, ascending: true),
        //                //                NSSortDescriptor(keyPath: \Worker.position_, ascending: true)
        //            ],
        //            predicate: NSPredicate(
        //                format: "ANY %K == %@", #keyPath(Worker.factory.worker_), worker
        //            )
        //        )
    }
    
    //    var positions: [String] {
    //        factoryWorker
    //            .map { $0.position }
    //            .removingDuplicates()
    //    }
    //
    //    var departments: [String] {
    //        factoryWorker
    //            .map { $0.department ??  }
    //            .removingDuplicates()
    //    }
    //
    //    var divisions: [String] {
    //        factoryWorker
    //            .map { $0.division }
    //            .removingDuplicates()
    //    }
    
    var body: some View {
        List {
            Section(
                header: Text("Person")
            ) {
                Group {
                    TextField("Name", text: $worker.name)
                    TextField("Note", text: $worker.note)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Position")
            ) {
                Group {
                    PickerWithTextField(selection: $worker.position, name: "", values: ["TBD"])
                    //                    StringPicker(title: worker.position, items: positions, selection: $worker.position)
                    //
                    //                    StringPicker(title: worker.department, items: departments, selection: $worker.department)
                    //
                    //                    StringPicker(title: worker.division, items: divisions, selection: $worker.division)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Salary")
            ) {
                Group {
                    AmountPicker(
                        systemName: "dollarsign.circle",
                        title: "Salary ex taxes",
                        navigationTitle: "Salary",
                        scale: .extraLarge,
                        qty: $worker.salary
                    )
                    .foregroundColor(.accentColor)
                    
                    LabelWithDetail("dollarsign.circle", "Salary with tax", worker.salaryWithTax.formattedGrouped)
                        .foregroundColor(.secondary)
                }
                .font(.subheadline)
            }
            
            Section(
                header: Text("Department"),
                footer: Text("Department could be changed.")
            ) {
                Group {
                    EntityPicker(
                        selection: $worker.department
                    )
                }
                //  .foregroundColor(.secondary) not .foregroundColor(.accentColor) to hide (diminish possibility of changing Department
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(worker.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

//struct WorkerView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkerView()
//    }
//}
