//
//  RadarChartViewer.swift
//  MyMood
//
//  Created by Kyle Shores on 1/22/22.
//

import SwiftUI

struct RadarChartDateSelector: View {
    @State var startDate: Date = Date()
    @State var endDate: Date = Date().addingTimeInterval(60 * 60 * 24)
    
    var body: some View {
        VStack {
            VStack{
                DatePicker("Start", selection: $startDate)
                    .padding(.horizontal)
                DatePicker("End", selection: $endDate)
                    .padding(.horizontal)
            }
            Spacer()
            TimestampFilteredMoods(startDate: startDate, endDate: endDate) { moods in
                CreateRadarChart(moods: moods)
            }
        }
    }
    
    private func CreateRadarChart(moods: [Feeling]) -> some View {
        var moodCounts: [String:Double] = Dictionary(uniqueKeysWithValues: zip(Array(Mood.moods.keys), Array(repeating: 0, count: Mood.moods.count)))
        for mood in moods {
            for moodString in Mood.MoodToStrings(from: mood.mood) {
                moodCounts[moodString]! += 1
            }
        }
        
        return RadarChart(
            data: Array(moodCounts.values),
            fillColor: Theme.color1,
            strokeColor: Theme.color1,
            divisions: 5,
            radiusBuffer: 10,
            edgeImageNames: Array(moodCounts.keys)
        )
    }
}

struct RadarChartViewer_Previews: PreviewProvider {
    static var previews: some View {
        RadarChartDateSelector()
    }
}
