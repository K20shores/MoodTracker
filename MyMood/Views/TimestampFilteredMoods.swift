//
//  RadarChartViewer.swift
//  MyMood
//
//  Created by Kyle Shores on 1/22/22.
//

import SwiftUI

struct TimestampFilteredMoods<Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<Feeling>
    let content: ([Feeling]) -> Content
    
    var body: some View {
        self.content(Array(fetchRequest))
    }
    
    init(startDate: Date, endDate: Date, @ViewBuilder content: @escaping ([Feeling]) -> Content) {
        _fetchRequest = FetchRequest<Feeling>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "(timestamp >= %@) AND (timestamp <= %@)", startDate as NSDate, endDate as NSDate))
        self.content = content
    }
}

