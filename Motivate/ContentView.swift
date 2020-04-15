//
//  ContentView.swift
//  Motivate
//
//  Created by Sohan Shingade on 4/12/20.
//  Copyright © 2020 Sohan Shingade. All rights reserved.
//

import SwiftUI

struct ContentView: View {
var body: some View{
TabView {
    TodoView()
        .tabItem {
            Image(systemName: "list.dash")
            Text("Todos")
        }

    GoalView()
        .tabItem {
           /* Image("target")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)*/
            Text("Goals")
        }
}
}
}


struct TodoView: View {
@FetchRequest(entity: Todo.entity(), sortDescriptors: []) var todos : FetchedResults<Todo>
@Environment(\.managedObjectContext) var moc
@State var isChecked:Bool = false

init() {
   
    UINavigationBar.appearance().largeTitleTextAttributes = [
        .font : UIFont(name: "Futura", size: 30)!]
    
    // To remove only extra separators below the list:
    UITableView.appearance().tableFooterView = UIView()

    
}
var body: some View {
    VStack{
    NavigationView {
        
        //lists out each todo from coredata
        List{
            ForEach(todos, id: \.title) {todo in
                HStack {
                    Button(action: {
                        self.toggleCheck(todo: todo)
                    }){
                    HStack{
                        Image(systemName: todo.completed  ? "checkmark.square": "square")
                        }
                    }
                
                        
                        VStack(alignment: .leading){
                        Text(todo.title ?? "")
                            .font(Font.custom("Futura", size: 24))
                        Text(todo.subtitle ?? "")
                            .font(Font.custom("Futura", size: 12))
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                    }
                }
                
            }
            .onDelete(perform: self.deleteRow)
            

        }
           
            
         //Navbar stuff
        .navigationBarTitle(Text("Today's Todos"))
        .navigationBarItems(
            trailing: NavigationLink(destination: NewTodo()) { Text("Add Todo")
                .font(Font.custom("Futura", size: 20))
                .foregroundColor(Color.green)
            })
        
        
       
    }
        }
}
    
    private func deleteRow(at offsets: IndexSet) {
              for offset in offsets{
                  let todo = todos[offset]
                  moc.delete(todo)
              }
              try? self.moc.save()

          }
          private func toggleCheck(todo: Todo) {
                  todo.completed = !todo.completed
              
              try? self.moc.save()
    
    }
}

struct GoalView: View {
@FetchRequest(entity: Goal.entity(), sortDescriptors: []) var goals : FetchedResults<Goal>
@Environment(\.managedObjectContext) var moc
@State var isChecked:Bool = false
let formatter1 = DateFormatter()
    



init() {

UINavigationBar.appearance().largeTitleTextAttributes = [
    .font : UIFont(name: "Futura", size: 30)!]

// To remove only extra separators below the list:
UITableView.appearance().tableFooterView = UIView()


}
var body: some View {
VStack{
NavigationView {
    
    //lists out each todo from coredata
    List{
        ForEach(goals, id: \.title) {goal in
            HStack {
                Button(action: {
                    self.toggleCheck(goal: goal)
                }){
                HStack{
                    Image(systemName: goal.completed  ? "checkmark.square": "square")
                    }
                }
            
                    
                    VStack(alignment: .leading){
                    Text(goal.title ?? "")
                        .font(Font.custom("Futura", size: 24))
                    Text(goal.subtitle ?? "")
                        .font(Font.custom("Futura", size: 12))
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)

                }
                
                Text("By: \(self.formatter1.string(from: goal.finishBy ?? Date()))")
                    .font(Font.custom("Futura", size: 20))
                    .frame(alignment: .center)
                
            }
            
            
        }
        .onDelete(perform: self.deleteRow)
        

    }
       
        
     //Navbar stuff
    .navigationBarTitle(Text("Goals"))
    .navigationBarItems(
        trailing: NavigationLink(destination: NewGoal()) { Text("Add Todo")
            .font(Font.custom("Futura", size: 20))
            .foregroundColor(Color.green)
        })
    
    
   
}
    }
}

private func deleteRow(at offsets: IndexSet) {
    for offset in offsets{
        let goal = goals[offset]
        moc.delete(goal)
    }
    try? self.moc.save()

}
private func toggleCheck(goal: Goal) {
        goal.completed = !goal.completed
    
    try? self.moc.save()

}
}



struct ContentView_Previews: PreviewProvider {
static var previews: some View {
ContentView()
}
}
