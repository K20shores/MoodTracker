//
//  MoodRow.swift
//  MyMood
//
//  Created by Kyle Shores on 1/19/22.
//

import SwiftUI

struct MoodRow: View {
    let feeling: Feeling
    private let imageSize: CGFloat = 20
    
    init(feeling: Feeling)
    {
        self.feeling = feeling
    }
    
    var body: some View {
        let moods = Mood.MoodToStrings(mood: Mood(rawValue: feeling.mood))
        
        HStack {
            ForEach(Array(moods.enumerated()), id: \.element) { idx, mood in
                CircleImage(image: Image(mood))
                    .frame(width: imageSize, height: imageSize)
                    .offset(x: Double(idx) * -imageSize * 0.99)
            }
            Spacer()
            Text(feeling.timestamp!, formatter: DefaultDateFormatter)
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
        Group{
            MoodRow(
                feeling: RandomFeeling(context: PersistenceController.preview.container.viewContext)
            )
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
