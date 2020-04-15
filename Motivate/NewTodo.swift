//
//  NewTodo.swift
//  Motivate
//
//  Created by Sohan Shingade on 4/12/20.
//  Copyright © 2020 Sohan Shingade. All rights reserved.
//

import SwiftUI
import CoreData

struct NewTodo: View {
    @State private var todoname: String = ""
    @State private var todosub: String = ""

    @FetchRequest(entity: Todo.entity(), sortDescriptors: []) var todos : FetchedResults<Todo>
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack{
            
            Text("New Todo!")
                .font(Font.custom("Futura", size: 60))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding()
            Spacer()
                .frame(height: 20)
            
            Text("Name your Todo:")
                .font(Font.custom("Futura", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            TextField("Name", text: $todoname)
                .padding()
                .frame(width: 350)
                .textFieldStyle(RoundedBorderTextFieldStyle())

                
            Spacer()
                .frame(height: 20)
                Text("Add a subtitle:")
                    .font(Font.custom("Futura", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                TextField("Name", text: $todosub)
                    .padding()
                    .frame(width: 350)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            Spacer()
            Button(action: {
                let todo = Todo(context: self.moc)
                todo.title = self.todoname
                todo.completed = false
                todo.subtitle = self.todosub
                try? self.moc.save()
                
                self.mode.wrappedValue.dismiss()
                
            }) {
                Text("Add Todo")
                    .font(Font.custom("Futura", size: 40))
                    .foregroundColor(Color.green)
                
            }
            Spacer()
        }
        
    }
}


struct NewTodo_Previews: PreviewProvider {
    static var previews: some View {
        NewTodo()
    }
}
