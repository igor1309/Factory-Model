import SwiftUI

call: 

NavigationLink(
    destination: NameEditor(entity: T(context: context)),
    isPresented: isPresented) {
        EmptyView()
        или
        Button("New") {
            isPresented = true
        }
    }


struct NameEditor<T: NSManagedObject & Namable>: View {
    @ObservedObject var entity: T
    
    var body {
        TextField("Name", $entity.name)
    }
}