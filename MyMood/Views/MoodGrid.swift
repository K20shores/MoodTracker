//
//  MoodGrid.swift
//  MyMood
//
//  Created by Kyle Shores on 1/19/22.
//

import SwiftUI

struct MoodGrid: View {
    @Binding var mood: Int32
    var onTapGesture: ((String) -> Void)? = nil
    
    let edgeSize: CGFloat = 35
    let columns: [GridItem] =
            [.init(.adaptive(minimum: 70, maximum: 100))
    ]
    
    var body: some View {
        let moods = Array(Mood.moods.keys).sorted()
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
                    if self.onTapGesture != nil {
                        self.onTapGesture!(mood)
                    }
                }
            }
        }
    }
    
    private func hasFeeling(mood:String) -> Bool {
        let parsedMood = Mood.stringToMood(mood: mood)
        return (self.mood & parsedMood.rawValue) != 0
    }
}

struct MoodGrid_Previews: PreviewProvider {
    @State static var mood: Int32 = 222
    static var previews: some View {
        MoodGrid(mood: $mood)
    }
    
    static func onTapped(_: String) -> Void {
        print("here")
    }
}
