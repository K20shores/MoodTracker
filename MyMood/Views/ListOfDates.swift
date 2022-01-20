//
//  ListOfDates.swift
//  MyMood
//
//  Created by Kyle Shores on 1/6/22.
//

import SwiftUI

struct ListOfDates: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var feelings: [Feeling]
    var date: Date

    var body: some View {
            List {
                ForEach(feelings) { feeling in
                    NavigationLink {
                        Text("Feeling at \(feeling.timestamp!, formatter: FeelingFormatter)")
                    } label: {
                        Text(feeling.timestamp!, formatter: FeelingFormatter)
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
                        destination: NewFeeling(date: date)
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
            .navigationTitle("All Feelings on \(date, formatter: FeelingFormatter)")
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
    static var previews: some View {
        NavigationView{
            ListOfDates(
                feelings: RandomFeelings(5),
                date: Date()
            ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

private func RandomFeelings(_ n: Int) -> [Feeling]
{
    var feelings : [Feeling] = []
    
    for _ in 1...n{
        let feeling = Feeling()
        feeling.timestamp = Date()
        feeling.mood = 1234
        feelings.append(feeling)
    }
    return feelings
}


private let FeelingFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
