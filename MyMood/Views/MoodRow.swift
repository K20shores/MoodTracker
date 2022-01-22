//
//  MoodRow.swift
//  MyMood
//
//  Created by Kyle Shores on 1/19/22.
//

import SwiftUI

struct MoodRow: View {
    let feeling: Feeling
    
    
    init(feeling: Feeling)
    {
        self.feeling = feeling
    }
    
    var body: some View {
        let moods = Mood.MoodToStrings(mood: Mood(rawValue: feeling.mood))
        
        HStack {
            GeometryReader { geo in
                ScrollView(.horizontal) {
                    HStack {
                        let imageSize: CGFloat = geo.size.height * 0.5
                        ForEach(Array(moods.enumerated()), id: \.element) { idx, mood in
                            //                            let _ = print(idx, geo.size, 1 - idx / moods.count, Double(1 - idx / moods.count) * geo.size.width)
                            CircleImage(image: Image(mood))
                                .frame(width: imageSize, height: imageSize)
                                .position(y: geo.size.height / 2)
                            //                                .offset(x: Double(idx) * -imageSize * 0.95)
                        }
                    }.padding(.leading, 12)
                }
            }
            Spacer()
            Text(feeling.timestamp!, formatter: TimeOnlyDateFormatter)
        }
    }
    
    private func CircleImage(image: Image) -> some View {
        return image
            .resizable()
            .clipShape(Circle())
            .overlay(
                Circle().stroke(.white, lineWidth:3)
            )
            .shadow(radius: 2)
    }
}

struct MoodRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MoodRow(
                feeling: RandomFeeling()
            )
            MoodRow(
                feeling: RandomFeeling()
            )
            MoodRow(
                feeling: RandomFeeling()
            )
            MoodRow(
                feeling: RandomFeeling()
            )
            MoodRow(
                feeling: RandomFeeling()
            )
        }
//        .previewLayout(.fixed(width: 300, height: 70))
    }
}
