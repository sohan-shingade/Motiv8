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
                        .font(Font.custom("Futura", size: 12))
                    
            }
            
            GoalView()
                .tabItem {
                    Image(systemName: "flag")
                    Text("Goals")
                        .font(Font.custom("Futura", size: 12))
            }
        }
    }
}


struct TodoView: View {
    @FetchRequest(entity: Todo.entity(), sortDescriptors: []) var todos : FetchedResults<Todo>
    @Environment(\.managedObjectContext) var moc
    @State var isChecked:Bool = false
    var formatter1: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
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
                List {
                    ForEach(todos, id: \.title) { todo in
                        HStack {
                            Button(action: {
                                self.toggleChecktodo(todo: todo)
                            }){
                                HStack{
                                    Image(systemName: todo.completed  ? "checkmark.square": "square")
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(todo.title ?? "")
                                    .font(Font.custom("Futura", size: 24))
                                    .strikethrough(todo.completed)
                                    .onAppear{
                                        self.checkToday(todo: todo)
                                }
                                Text(todo.subtitle ?? "")
                                    .font(Font.custom("Futura", size: 12))
                                    .foregroundColor(Color.gray)
                                    .strikethrough(todo.completed)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                
                                
                                
                            }
                            VStack(alignment: .trailing){
                                Image(systemName: "bolt.circle")
                                    .foregroundColor(Color.yellow)
                                    .frame(alignment: .trailing)
                                Text("+10")
                                    .font(Font.custom("Futura", size: 12))
                                    .strikethrough(todo.completed)
                                
                                
                                
                            }
                        }
                        
                    }
                    .onDelete(perform: self.deleteRow)
                }
                    
                    
                    //Navbar stuff
                    .navigationBarTitle(Text("Today's Todos"))
                    .navigationBarItems(
                        leading: HStack{
                            Image(systemName: "bolt.circle")
                                .foregroundColor(Color.yellow)
                            
                            Text("\(UserDefaults.standard.integer(forKey: "Points"))")
                                .font(Font.custom("Futura", size: 12))
                            
                            
                            
                            
                        }, trailing: NavigationLink(destination: NewTodo()) { Text("Add Todo")
                            .font(Font.custom("Futura", size: 20))
                            .foregroundColor(Color.green)}
                        
                )
                
                
                
            }
        }
    }
    
    private func checkToday(todo: Todo){
        if let date = todo.createdOn {
            if !Calendar.current.isDateInToday(date){
                moc.delete(todo)
                try? self.moc.save()
                
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
    
    private func toggleChecktodo(todo: Todo) {
        todo.completed = !todo.completed
        try? self.moc.save()
        if todo.completed {
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "Points")+10, forKey: "Points")
        }
        else{
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "Points")-10, forKey: "Points")
        }
    }
}

struct GoalView: View {
    @FetchRequest(entity: Goal.entity(), sortDescriptors: []) var goals : FetchedResults<Goal>
    @Environment(\.managedObjectContext) var moc
    @State var isChecked:Bool = false
    
    var formatter1: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
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
                    ForEach(goals, id: \.title) { goal in
                        HStack {
                            
                            Button(action: { self.toggleCheckgoal(goal: goal) }){
                                HStack {
                                    Image(systemName: goal.completed  ? "checkmark.square": "square")
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(goal.title ?? "")
                                    .font(Font.custom("Futura", size: 24))
                                    .onAppear{
                                        self.currday(goal: goal)
                                }
                                Text(goal.subtitle ?? "")
                                    .font(Font.custom("Futura", size: 12))
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Text("By: \(self.formatter1.string(from: goal.finishBy ?? Date()))")
                                .font(Font.custom("Futura", size: 20))
                                .strikethrough(goal.completed)
                                .frame(alignment: .center)

                            Spacer()
                                .frame(width: 25)
                            
                            VStack(alignment: .trailing){
                                Image(systemName: "bolt.circle")
                                    .foregroundColor(Color.yellow)
                                    .frame(alignment: .trailing)
                                Text("+30")
                                    .font(Font.custom("Futura", size: 12))
                                    .strikethrough(goal.completed)
                            }
                        }
                        .foregroundColor(goal.isCurrDay  ? Color.init(hue: 0, saturation: 100, brightness: 87): Color.black)
                    }
                    .onDelete(perform: self.deleteRow)
                }

                    //Navbar stuff
                    .navigationBarTitle(Text("Goals"))
                    .navigationBarItems(
                        leading: HStack{
                            Image(systemName: "bolt.circle")
                                .foregroundColor(Color.yellow)
                            Text("\(UserDefaults.standard.integer(forKey: "Points"))")
                                .font(Font.custom("Futura", size: 12))
                        }, trailing: NavigationLink(destination: NewGoal()) { Text("Add Goal")
                            .font(Font.custom("Futura", size: 20))
                            .foregroundColor(Color.green)}
                )
            }
            Spacer()
        }
    }
    
    
    private func currday(goal: Goal){
        goal.isCurrDay = Calendar.current.isDateInToday(goal.finishBy!)
        try? self.moc.save()
    }
    
    private func deleteRow(at offsets: IndexSet) {
        for offset in offsets {
            let goal = goals[offset]
            moc.delete(goal)
        }
    }
    
    private func toggleCheckgoal(goal: Goal) {
        goal.completed = !goal.completed
        try? self.moc.save()
        
        if goal.completed {
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "Points")+30, forKey: "Points")
        }
        else{
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "Points")-30, forKey: "Points")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





