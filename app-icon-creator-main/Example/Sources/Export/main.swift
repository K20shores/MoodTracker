import AppIconCreator
import ExampleAppIcon
import Foundation

let exportURL = FileManager.default
  .homeDirectoryForCurrentUser
  .appendingPathComponent("Documents")
  .appendingPathComponent("MoodTracker")
  .appendingPathComponent("MyMood")
  .appendingPathComponent("Assets.xcassets")
  .appendingPathComponent("AppIcon.appiconset")

[IconImage]
  .images(for: ExampleAppIconView(.iOS), with: .iOS)
  .forEach { $0.save(to: exportURL) }

//[IconImage]
//  .images(for: ExampleAppIconView(.macOS), with: .macOS)
//  .forEach { $0.save(to: exportURL) }
