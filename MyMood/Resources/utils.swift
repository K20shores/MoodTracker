//
//  utils.swift
//  MyMood
//
//  Created by Kyle Shores on 1/19/22.
//

import Foundation
import CoreData

func makeList(_ n: Int) -> [Double] {
    return (0..<n).map{ _ in Double.random(in: 1 ... 20) }
}

func RandomFeeling() -> Feeling {
    let feeling = Feeling(context: PersistenceController.preview.container.viewContext)
    feeling.timestamp = Date()
    feeling.mood = Int32.random(in: 1...Int32.max)
    return feeling
}

func RandomFeelings(_ n: Int) -> [Feeling]
{
    var feelings : [Feeling] = []
    
    for _ in 1...n{
        feelings.append(RandomFeeling())
    }
    return feelings
}
