import SwiftUI

struct NameEditor<T: NSManagedObject & Namable>: View {
    @ObservedObject var entity: T
    
    var body {
        TextField("Name", $entity.name)
    }
}