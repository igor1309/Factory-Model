import SwiftUI
import CoreData

@objc(ProfileData)
public class ProfileData: NSManagedObject, Identifiable {
    public let id = UUID()
}


extension ProfileData {
    
    
    @NSManaged public var name: String?
    public var wrappedName: String{
        get{name ?? "NoName"}
        set{name = newValue}
    }
    @NSManaged public var surname: String?
    public var wrappedSurname: String{
        get{surname ?? "NoSurname"}
        set{surname = newValue}
    }
}

struct ProfileView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @Environment(\.managedObjectContext) private var moc: NSManagedObjectContext // it will need you to add new examples of youre entities and save all changes
    @FetchRequest(
        entity: ProfileData.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ProfileData.name, ascending: true),
            NSSortDescriptor(keyPath: \ProfileData.surname, ascending: true),
            
        ]
    ) var profileList: FetchedResults<ProfileData>
    //fetchRequest is a list of all objects off type ProfileData - saved and unsaved
    
    var body: some View {
        NavigationView{
            
            List{
                ForEach(profileList){profile in
                    NavigationLink(destination: profileUpdateView(profile: profile)){
                        Text("\(profile.wrappedName) \(profile.wrappedSurname) ")
                    }
                }
                HStack{
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .imageScale(.large)
                    Button("add a new profile"){
                        let newProfile = ProfileData(context: self.moc)
                        newProfile.wrappedName = "Name"
                        newProfile.wrappedSurname = "Surname"
                    }
                    
                }
            }
            
            .navigationBarTitle(Text("Profile"))
            .navigationBarItems(trailing: Button("save"){
                if self.moc.hasChanges{
                    do{try self.moc.save()}
                    catch{print("Cant save changes: \(error)")}
                }
            })
            
        }
    }
}
struct profileUpdateView: View {
    @ObservedObject var profile: ProfileData
    var body: some View{
        VStack {
            HStack {
                Text("Meno:")
                    .font(.headline)
                    .padding()
                TextField("Zadajte meno", text: $profile.wrappedName)
            }
            HStack {
                Text("Priezvisko:")
                    .font(.headline)
                    .padding()
                TextField("Zadajte priezvisko", text: $profile.wrappedSurname)
            }
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let newProfile = ProfileData(context: context)
//        newProfile.wrappedName = "Name"
//        newProfile.wrappedSurname = "Surname"
//        return ProfileView().environment(\.managedObjectContext, context)
//    }
//}
