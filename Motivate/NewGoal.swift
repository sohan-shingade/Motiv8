//
//  NewGoal.swift
//  Motivate
//
//  Created by Sohan Shingade on 4/14/20.
//  Copyright © 2020 Sohan Shingade. All rights reserved.
//

import SwiftUI

struct NewGoal: View {
    
    @State private var goalname: String = ""
    @State private var goalsub: String = ""
    @State private var goalDate = Date()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    @FetchRequest(entity: Goal.entity(), sortDescriptors: []) var goals : FetchedResults<Goal>
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack{
            
            VStack {
                Text("New goal!")
                    .font(Font.custom("Futura", size: 60))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding()
            }
            Spacer()
                .frame(height: 10)
            
            VStack {
                Text("Name your goal:")
                    .font(Font.custom("Futura", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            
            
            TextField("Name", text: $goalname)
                .padding()
                .frame(width: 350)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }

                
            Spacer()
                .frame(height: 10)
            
            VStack {
                Text("Add a subtitle:")
                    .font(Font.custom("Futura", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            
                
                TextField("Name", text: $goalsub)
                    .padding()
                    .frame(width: 350)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
                
            Spacer()
                .frame(height: 20)
            
            VStack{
                Text("Pick a date for when you want to accomplish your goal:")
                .font(Font.custom("Futura", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                DatePicker("", selection: $goalDate, displayedComponents: .date)
                    .labelsHidden()
                    .frame(height: 45, alignment: .center)
                    .clipped()
            }
            Spacer()
                .frame(height: 40)
            
            
            VStack {
                Button(action: {
                    let goal = Goal(context: self.moc)
                    goal.title = self.goalname
                    goal.completed = false
                    goal.subtitle = self.goalsub
                    goal.finishBy = self.goalDate
                    goal.isCurrDay = Calendar.current.isDateInToday(self.goalDate)

                    
                    print(self.dateFormatter.string(from: goal.finishBy!))
                    try? self.moc.save()
                    
                    self.mode.wrappedValue.dismiss()
                    
                }) {
                    Text("Add goal")
                        .font(Font.custom("Futura", size: 40))
                        .foregroundColor(Color.green)
                    
                }
            }

        }
    }
}

struct NewGoal_Previews: PreviewProvider {
    static var previews: some View {
        NewGoal()
    }
}
