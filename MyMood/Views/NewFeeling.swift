//
//  ContentView.swift
//  MyMood
//
//  Created by Kyle Shores on 1/2/22.
//

import SwiftUI

struct NewFeeling: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var timestamp: Date
    @State private var mood: Int32 = 0
    
    let moods = Array(Mood.moods.keys).sorted()

    var body: some View {
        VStack {
            Text("How do you feel?")
                .font(.title)
            HStack{
                Spacer()
                DatePicker("Date", selection: $timestamp)
                    .padding(.horizontal)
            }
            MoodGrid(mood: $mood, onTapGesture: onMoodTapped )
            .padding()
            
            Spacer()
            
            Button(action: saveFeelings) {
                Label {
                    Text("Save Feelings")
                } icon: {
                    Theme.Heart()
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blue, lineWidth:1)
            )
            
        }
    }
    
    private func onMoodTapped(_ mood:String){
        let parsedMood = Mood.stringToMood(mood: mood)
        print($timestamp, "Tapped " + mood, parsedMood)
        self.mood ^= parsedMood.rawValue
        print(String(self.mood, radix: 2))
    }
    
    private func saveFeelings(){
        let newFeeling = Feeling(context: viewContext)
        newFeeling.timestamp = timestamp
        newFeeling.mood = mood
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct NewFeeling_Previews: PreviewProvider {
    static var previews: some View {
        NewFeeling(timestamp: Date())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
