//
//  ListOfDates.swift
//  MyMood
//
//  Created by Kyle Shores on 1/6/22.
//

import SwiftUI
import CoreData

struct ListOfMoods: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var feelings: [Feeling]
    var date: Date

    var body: some View {
            List {
                ForEach(feelings) { feeling in
                    NavigationLink {
                        MoodGrid(mood: Binding.constant(feeling.mood))
                            .padding()
                        Text("Feeling at \(feeling.timestamp!, formatter: DefaultDateFormatter)")
                    } label: {
                        MoodRow(feeling: feeling)
//                        Text(feeling.timestamp!, formatter: DefaultDateFormatter)
                    }
                }
                .onDelete(perform: deleteFeelings)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink(
                        destination: NewFeeling(timestamp: date)
                            .environment(\.managedObjectContext, viewContext)
                    ) {
                        Label {
                            Text("Add Feeling")
                        } icon: {
                            Theme.Heart()
                        }
                        .overlay(
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .padding(6)
                        )
                    }
                }
            }
            .navigationTitle("Moods on \(date, formatter: NavigationTitleFormater)")
    }

    private func deleteFeelings(offsets: IndexSet) {
        withAnimation {
            offsets.map { feelings[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ListOfDates_Previews: PreviewProvider {
    static let context = PersistenceController.preview.container.viewContext
    static var previews: some View {
        NavigationView{
            ListOfMoods(
                feelings: RandomFeelings(5, context: context),
                date: Date()
            )
                .environment(\.managedObjectContext, context)
        }
    }
}
