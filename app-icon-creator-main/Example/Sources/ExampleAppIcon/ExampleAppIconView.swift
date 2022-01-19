import SwiftUI
import AppIconCreator

// Icon maker downloaded from here: https://github.com/darrarski/swiftui-app-icon-creator

struct Theme {
    // Color scheme: https://www.schemecolor.com/emotion-and-feelings.php
    static let color1: Color = Color(red:95/255, green:222/255, blue:192/255)
    static let color2: Color = Color(red:100/255, green:180/255, blue:227/255)
    static let color3: Color = Color(red:255/255, green:207/255, blue:51/255)
    static let color4: Color = Color(red:252/255, green:111/255, blue:68/255)
    static let color5: Color = Color(red:224/255, green:81/255, blue:176/255)
}

public struct ExampleAppIconView: View {
    public enum Platform {
        case iOS
        case macOS
    }
    
    public init(_ platform: Platform) {
        self.platform = platform
    }
    
    var platform: Platform
    
    private func ForegroundGradient() -> some View {
        return LinearGradient(
            gradient: Gradient(colors: [Theme.color5, Theme.color4]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private func BackgroundGradient() -> some View {
        return LinearGradient(
            gradient: Gradient(colors: [Theme.color1, Theme.color2]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .overlayMask(
                    ForegroundGradient()
                )
                .padding(geometry.size.width * 0.18)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    BackgroundGradient()
                )
                .if(platform == .macOS) {
                    $0.overlay(
                        RoundedRectangle(
                            cornerRadius: geometry.size.width * 0.4,
                            style: .continuous
                        )
                            .strokeBorder(
                                lineWidth: geometry.size.width * 0.06
                            )
                            .overlayMask(
                                BackgroundGradient()
                            )
                            .shadow(
                                color: Color.black.opacity(0.5),
                                radius: geometry.size.width * 0.015
                            )
                    )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: geometry.size.width * 0.4,
                                style: .continuous
                            )
                        )
                }
        }
    }
}

extension View {
    func overlayMask<Overlay: View>(_ overlay: Overlay) -> some View {
        self.overlay(overlay).mask(self)
    }
}

struct ExampleAppIconView_Preivews: PreviewProvider {
    static var previews: some View {
        IconPreviews(
            icon: ExampleAppIconView(.iOS),
            configs: .iOS
        )
        IconPreviews(
            icon: ExampleAppIconView(.macOS),
            configs: .macOS,
            clip: false
        )
    }
}
