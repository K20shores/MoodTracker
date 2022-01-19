//
//  ContentView.swift
//  MyMood
//
//  Created by Kyle Shores on 1/2/22.
//

import SwiftUI
import CoreData

struct NewFeeling: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var newFeelings: Int32 = 0
    @State var date: Date
    
    let moods = Array(Mood.moods.keys).sorted()

    var body: some View {
        let edgeSize: CGFloat = 35
        let columns: [GridItem] =
                [.init(.adaptive(minimum: 70, maximum: 100))]
        VStack {
            Text("How do you feel?")
                .font(.title)
            HStack{
                Spacer()
                DatePicker("Date", selection: $date)
                    .padding(.horizontal)
            }
            LazyVGrid(columns: columns) {
                ForEach(moods, id: \.self) { mood in
                    VStack(alignment: .center, spacing: 1) {
                        Image(mood)
                            .resizable()
                            .scaledToFit()
                            .frame(width:edgeSize, height:edgeSize)
                            .padding(.horizontal)
                        Text(mood)
                            .foregroundColor(.secondary)
                            .font(.system(size: 12))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(hasFeeling(mood: mood) ? .blue : .clear, lineWidth:2)
                    )
                    .onTapGesture {
                        self.onMoodTapped(mood: mood)
                    }
                }
            }
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
    
    private func onMoodTapped(mood:String){
        let parsedMood = Mood.stringToMood(mood: mood)
        print(date, "Tapped " + mood, parsedMood)
        self.newFeelings ^= parsedMood.rawValue
        print(String(self.newFeelings, radix: 2))
    }
    
    private func hasFeeling(mood:String) -> Bool {
        let parsedMood = Mood.stringToMood(mood: mood)
        return (self.newFeelings & parsedMood.rawValue) != 0
    }
    
    private func saveFeelings(){
        let newFeeling = Feeling(context: viewContext)
        newFeeling.timestamp = date
        newFeeling.mood = newFeelings

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
        NewFeeling(date: Date()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}