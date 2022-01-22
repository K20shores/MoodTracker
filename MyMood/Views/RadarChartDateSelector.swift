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
            RadarChartViewer(startDate: startDate, endDate: endDate)
        }
    }
}

struct RadarChartViewer_Previews: PreviewProvider {
    static var previews: some View {
        RadarChartDateSelector()
    }
}
