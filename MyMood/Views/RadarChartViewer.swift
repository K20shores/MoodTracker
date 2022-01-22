//
//  RadarChartViewer.swift
//  MyMood
//
//  Created by Kyle Shores on 1/22/22.
//

import SwiftUI

struct RadarChartViewer: View {
    @FetchRequest var fetchRequest: FetchedResults<Feeling>
    
    var body: some View {
        CreateRadarChart()
            .padding()
        Spacer()
    }
    
    private func CreateRadarChart() -> some View {
        var moodCounts: [String:Double] = Dictionary(uniqueKeysWithValues: zip(Array(Mood.moods.keys), Array(repeating: 0, count: Mood.moods.count)))
        for feeling in fetchRequest {
            for mood in Mood.MoodToStrings(from: feeling.mood) {
                moodCounts[mood]! += 1
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
    
    init(startDate: Date, endDate: Date) {
        _fetchRequest = FetchRequest<Feeling>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "(timestamp >= %@) AND (timestamp <= %@)", startDate as NSDate, endDate as NSDate))
    }
}

