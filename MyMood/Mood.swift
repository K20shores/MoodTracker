//
//  Moods.swift
//  MyMood
//
//  Created by Kyle Shores on 1/6/22.
//

struct Mood : OptionSet {
    let rawValue: Int32

    static let none = Mood(rawValue: 1 << 0)
    static let angry = Mood(rawValue: 1 << 1)
    static let crying = Mood(rawValue: 1 << 2)
    static let cute = Mood(rawValue: 1 << 3)
    static let demon = Mood(rawValue: 1 << 4)
    static let disbelief = Mood(rawValue: 1 << 5)
    static let embarrassed = Mood(rawValue: 1 << 6)
    static let hungry = Mood(rawValue: 1 << 7)
    static let ill = Mood(rawValue: 1 << 8)
    static let kiss = Mood(rawValue: 1 << 9)
    static let laughing = Mood(rawValue: 1 << 10)
    static let joyful = Mood(rawValue: 1 << 11)
    static let exhilerated = Mood(rawValue: 1 << 12)
    static let love = Mood(rawValue: 1 << 13)
    static let money = Mood(rawValue: 1 << 14)
    static let neutral = Mood(rawValue: 1 << 15)
    static let puke = Mood(rawValue: 1 << 16)
    static let sad = Mood(rawValue: 1 << 17)
    static let sarcastic = Mood(rawValue: 1 << 18)
    static let shy = Mood(rawValue: 1 << 19)
    static let sick = Mood(rawValue: 1 << 20)
    static let sleep = Mood(rawValue: 1 << 21)
    static let content = Mood(rawValue: 1 << 22)
    static let expectant = Mood(rawValue: 1 << 23)
    static let smile = Mood(rawValue: 1 << 24)
    static let thinking = Mood(rawValue: 1 << 25)
    static let playful = Mood(rawValue: 1 << 26)
    static let tongue = Mood(rawValue: 1 << 27)
    static let flirty = Mood(rawValue: 1 << 28)
    static let wink = Mood(rawValue: 1 << 29)
    static let wow = Mood(rawValue: 1 << 30)
    
    static func stringToMood(mood: String) -> Mood
    {
        switch mood{
        case "angry":
            return Mood.angry
        case "crying":
            return Mood.crying
        case "cute":
            return Mood.cute
        case "demon":
            return Mood.demon
        case "disbelief":
            return Mood.disbelief
        case "embarrassed":
            return Mood.embarrassed
        case "hungry":
            return Mood.hungry
        case "ill":
            return Mood.ill
        case "kiss":
            return Mood.kiss
        case "laughing":
            return Mood.laughing
        case "joyful":
            return Mood.joyful
        case "exhilerated":
            return Mood.exhilerated
        case "love":
            return Mood.love
        case "money":
            return Mood.money
        case "neutral":
            return Mood.neutral
        case "puke":
            return Mood.puke
        case "sad":
            return Mood.sad
        case "sarcastic":
            return Mood.sarcastic
        case "shy":
            return Mood.shy
        case "sick":
            return Mood.sick
        case "sleep":
            return Mood.sleep
        case "content":
            return Mood.content
        case "expectant":
            return Mood.expectant
        case "smile":
            return Mood.smile
        case "thinking":
            return Mood.thinking
        case "playful":
            return Mood.playful
        case "tongue":
            return Mood.tongue
        case "flirty":
            return Mood.flirty
        case "wink":
            return Mood.wink
        case "wow":
            return Mood.wow
        default:
            return Mood.none
        }
    }
}
