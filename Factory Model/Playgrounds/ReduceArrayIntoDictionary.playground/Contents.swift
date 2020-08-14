import UIKit

struct Product: Hashable {
    var name: String
    var group: String
}

let products: [Product] = [
    Product(name: "product 1", group: "group 1"),
    Product(name: "product 2", group: "group 1"),
    Product(name: "product 4", group: "group 1"),
    Product(name: "product 3", group: "group 2")
]

let groups =
    Dictionary(grouping: products, by: \.group)
    .mapValues {
        $0.map(\.name).joined(separator: ", ")        
    }

let gr = groups.map { "\($0): \($1)" }.sorted()
print(gr)
