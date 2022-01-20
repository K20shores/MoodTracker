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

func RandomFeeling(context: NSManagedObjectContext) -> Feeling {
    let feeling = Feeling(context: context)
    feeling.timestamp = Date()
    feeling.mood = 1234
    return feeling
}

func RandomFeelings(_ n: Int, context: NSManagedObjectContext) -> [Feeling]
{
    var feelings : [Feeling] = []
    
    for _ in 1...n{
        feelings.append(RandomFeeling(context: context))
    }
    return feelings
}
