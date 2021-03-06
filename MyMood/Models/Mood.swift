//
//  Mood.swift
//  MyMood
//
//  Created by Kyle Shores on 1/6/22.
//

struct Mood : OptionSet {
    let rawValue: Int32

    static let none = Mood(rawValue: 0 << 0)
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
    
    static let moods = [
        "angry": Mood.angry,
        "crying": Mood.crying,
        "cute": Mood.cute,
        "demon": Mood.demon,
        "disbelief": Mood.disbelief,
        "embarrassed": Mood.embarrassed,
        "hungry": Mood.hungry,
        "ill": Mood.ill,
        "kiss": Mood.kiss,
        "laughing": Mood.laughing,
        "joyful": Mood.joyful,
        "exhilerated": Mood.exhilerated,
        "love": Mood.love,
        "money": Mood.money,
        "neutral": Mood.neutral,
        "puke": Mood.puke,
        "sad": Mood.sad,
        "sarcastic": Mood.sarcastic,
        "shy": Mood.shy,
        "sick": Mood.sick,
        "sleep": Mood.sleep,
        "content": Mood.content,
        "expectant": Mood.expectant,
        "smile": Mood.smile,
        "thinking": Mood.thinking,
        "playful": Mood.playful,
        "tongue": Mood.tongue,
        "flirty": Mood.flirty,
        "wink": Mood.wink,
        "wow": Mood.wow
    ]
    
    static func stringToMood(mood: String) -> Mood
    {
        return moods[mood]!
    }
    
    static func MoodToStrings(from: Int32) -> [String]
    {
        return Mood.MoodToStrings(mood: Mood(rawValue: from))
    }
    
    static func MoodToStrings(mood: Mood) -> [String]
    {
        var moods : [String] = []
        
        if none.rawValue & mood.rawValue != 0 {
            moods.append("none")
        }
        if angry.rawValue & mood.rawValue != 0 {
            moods.append("angry")
        }
        if crying.rawValue & mood.rawValue != 0 {
            moods.append("crying")
        }
        if cute.rawValue & mood.rawValue != 0 {
            moods.append("cute")
        }
        if demon.rawValue & mood.rawValue != 0 {
            moods.append("demon")
        }
        if disbelief.rawValue & mood.rawValue != 0 {
            moods.append("disbelief")
        }
        if embarrassed.rawValue & mood.rawValue != 0 {
            moods.append("embarrassed")
        }
        if hungry.rawValue & mood.rawValue != 0 {
            moods.append("hungry")
        }
        if ill.rawValue & mood.rawValue != 0 {
            moods.append("ill")
        }
        if kiss.rawValue & mood.rawValue != 0 {
            moods.append("kiss")
        }
        if laughing.rawValue & mood.rawValue != 0 {
            moods.append("laughing")
        }
        if joyful.rawValue & mood.rawValue != 0 {
            moods.append("joyful")
        }
        if exhilerated.rawValue & mood.rawValue != 0 {
            moods.append("exhilerated")
        }
        if love.rawValue & mood.rawValue != 0 {
            moods.append("love")
        }
        if money.rawValue & mood.rawValue != 0 {
            moods.append("money")
        }
        if neutral.rawValue & mood.rawValue != 0 {
            moods.append("neutral")
        }
        if puke.rawValue & mood.rawValue != 0 {
            moods.append("puke")
        }
        if sad.rawValue & mood.rawValue != 0 {
            moods.append("sad")
        }
        if sarcastic.rawValue & mood.rawValue != 0 {
            moods.append("sarcastic")
        }
        if shy.rawValue & mood.rawValue != 0 {
            moods.append("shy")
        }
        if sick.rawValue & mood.rawValue != 0 {
            moods.append("sick")
        }
        if sleep.rawValue & mood.rawValue != 0 {
            moods.append("sleep")
        }
        if content.rawValue & mood.rawValue != 0 {
            moods.append("content")
        }
        if expectant.rawValue & mood.rawValue != 0 {
            moods.append("expectant")
        }
        if smile.rawValue & mood.rawValue != 0 {
            moods.append("smile")
        }
        if thinking.rawValue & mood.rawValue != 0 {
            moods.append("thinking")
        }
        if playful.rawValue & mood.rawValue != 0 {
            moods.append("playful")
        }
        if tongue.rawValue & mood.rawValue != 0 {
            moods.append("tongue")
        }
        if flirty.rawValue & mood.rawValue != 0 {
            moods.append("flirty")
        }
        if wink.rawValue & mood.rawValue != 0 {
            moods.append("wink")
        }
        if wow.rawValue & mood.rawValue != 0 {
            moods.append("wow")
        }
        return moods
    }
}
