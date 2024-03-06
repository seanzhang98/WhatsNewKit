import SwiftUI

// MARK: - WhatsNewView

/// A WhatsNewView
public struct WhatsNewView {
    
    // MARK: Properties
    
    /// The WhatsNew object
    private let whatsNew: WhatsNew
    
    /// The WhatsNewVersionStore
    private let whatsNewVersionStore: WhatsNewVersionStore?
    
    /// The WhatsNew Layout
    private let layout: WhatsNew.Layout
    
    /// The View that is presented by the SecondaryAction
    @State
    private var secondaryActionPresentedView: WhatsNew.SecondaryAction.Action.PresentedView?
    
    /// The PresentationMode
    @Environment(\.presentationMode)
    private var presentationMode
    
    // MARK: Initializer
    
    /// Creates a new instance of `WhatsNewView`
    /// - Parameters:
    ///   - whatsNew: The WhatsNew object
    ///   - versionStore: The optional WhatsNewVersionStore. Default value `nil`
    ///   - layout: The WhatsNew Layout. Default value `.default`
    public init(
        whatsNew: WhatsNew,
        versionStore: WhatsNewVersionStore? = nil,
        layout: WhatsNew.Layout = .default
    ) {
        self.whatsNew = whatsNew
        self.whatsNewVersionStore = versionStore
        self.layout = layout
    }
    
}

// MARK: - View

@available(iOS 15.0, *)
extension WhatsNewView: View {
    
    /// The content and behavior of the view.
    public var body: some View {
        ZStack {
            // Content ScrollView
            ScrollView(
                .vertical,
                showsIndicators: self.layout.showsScrollViewIndicators
            ) {
                // Content Stack
                VStack(
                    spacing: self.layout.contentSpacing
                ) {
                    // Title
                    self.title
                    // Feature List
                    VStack(
                        alignment: .leading,
                        spacing: self.layout.featureListSpacing
                    ) {
                        // Feature
                        ForEach(
                            self.whatsNew.features,
                            id: \.self,
                            content: self.feature
                        )
                    }
                    .modifier(FeaturesPadding())
                    .padding(self.layout.featureListPadding)
                }
                .padding(.horizontal)
                .padding(self.layout.contentPadding)
                // ScrollView bottom content inset
                Color.clear
                    .padding(
                        .bottom,
                        self.layout.scrollViewBottomContentInset
                    )
            }
            #if os(iOS)
            .alwaysBounceVertical(false)
            #endif
            // Footer
            VStack {
                Spacer()
                /*
                VStack{
                    Image(systemName: "person.and.background.dotted")
                        .symbolRenderingMode(.hierarchical)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(hex: 0xf5855D6))
                        .frame(width: 32, height: 32)
                    Group {
                        Text("Camerapedia collects your activity, which is not associated with your Apple ID, in order to improve and personalize the application. ")
                            .foregroundColor(.secondary)/* +
                                                         Text("See how your data is managed...")
                                                         .foregroundColor(.purple)
                                                         .bold()*/
                    }
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10))
                    .padding(.bottom, 10)
                    .padding(.top, 4)
                }*/
                self.footer
                    .modifier(FooterPadding())
                    #if os(iOS)
                    .background(
                        UIVisualEffectView
                            .Representable()
                            .edgesIgnoringSafeArea(.horizontal)
                            .padding(self.layout.footerVisualEffectViewPadding)
                    )
                    #endif
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(
            item: self.$secondaryActionPresentedView,
            content: { $0.view }
        )
        .onDisappear {
            // Save presented WhatsNew Version, if available
            self.whatsNewVersionStore?.save(
                presentedVersion: self.whatsNew.version
            )
        }
    }
    
}

// MARK: - Title

private extension WhatsNewView {
    
    /// The Title View
    var title: some View {
        Text(
            whatsNewText: self.whatsNew.title.text
        )
        .font(.largeTitle.bold())
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }
    
}

// MARK: - Feature

private extension WhatsNewView {
    
    /// The Feature View
    /// - Parameter feature: A WhatsNew Feature
    func feature(
        _ feature: WhatsNew.Feature
    ) -> some View {
        HStack(
            alignment: self.layout.featureHorizontalAlignment,
            spacing: self.layout.featureHorizontalSpacing
        ) {
            feature
                .image
                .view()
                .frame(width: self.layout.featureImageWidth)
            VStack(
                alignment: .leading,
                spacing: self.layout.featureVerticalSpacing
            ) {
                Text(
                    whatsNewText: feature.title
                )
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                Text(
                    whatsNewText: feature.subtitle
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.leading)
        }.accessibilityElement(children: .combine)
    }
    
}

// MARK: - Footer

@available(iOS 15.0, *)
private extension WhatsNewView {
    
    /// The Footer View
    var footer: some View {
        VStack(
            spacing: self.layout.footerActionSpacing
        ) {
            // Check if a secondary action is available
            ZStack{
                if let secondaryAction = self.whatsNew.secondaryAction {
                    // Secondary Action Button
                    /* Button(
                     action: {
                     // Invoke HapticFeedback, if available
                     secondaryAction.hapticFeedback?()
                     // Switch on Action
                     switch secondaryAction.action {
                     case .present(let view):
                     // Set secondary action presented view
                     self.secondaryActionPresentedView = .init(view: view)
                     case .custom(let action):
                     // Invoke action with PresentationMode
                     action(self.presentationMode)
                     }
                     }
                     ) {
                     Text(
                     whatsNewText: secondaryAction.title
                     )
                     }.padding(.bottom, 10)
                     #if os(macOS)
                     .buttonStyle(
                     PlainButtonStyle()
                     )
                     #endif
                     .foregroundColor(secondaryAction.foregroundColor)
                     .zIndex(1)*/
                    VStack{
                        Image("icon_dataprivacy_2x")
                            .resizable()
                            .scaledToFit()
                            .colorMultiply(secondaryAction.foregroundColor.opacity(0.8))
                            //.foregroundColor(secondaryAction.foregroundColor)
                            .frame(width: 32, height: 32)
                        Group {
                            if Locale.current.languageCode == "zh" {
                                Text("Camerapedia 会收集用于改进和个性化应用程序的活动信息。这些信息将无法辨认您和您的 Apple ID。")
                                    .foregroundColor(.secondary) +
                                 Text("了解您的数据是如何管理的...")
                                    .foregroundColor(secondaryAction.foregroundColor)
                                 .bold()
                            } else {
                                Text("Camerapedia collects your activity, which is not associated with your Apple ID, in order to improve and personalize the application. ")
                                    .foregroundColor(.secondary) +
                                Text("See how your data is managed...")
                                .foregroundColor(secondaryAction.foregroundColor)
                                .bold()
                            }
                        }
                        .multilineTextAlignment(.center)
                        .font(.system(size: 10))
                        .padding(.bottom, 10)
                        //.padding(.top, 5)
                        .onTapGesture {
                            // Invoke HapticFeedback, if available
                            secondaryAction.hapticFeedback?()
                            // Switch on Action
                            switch secondaryAction.action {
                            case .present(let view):
                                // Set secondary action presented view
                                self.secondaryActionPresentedView = .init(view: view)
                            case .custom(let action):
                                // Invoke action with PresentationMode
                                action(self.presentationMode)
                            }
                        }
                    }.zIndex(0)
                }
            }
            // Primary Action Button
            Button(
                action: {
                    // Invoke HapticFeedback, if available
                    self.whatsNew.primaryAction.hapticFeedback?()
                    // Dismiss
                    self.presentationMode.wrappedValue.dismiss()
                    // Invoke on dismiss, if available
                    self.whatsNew.primaryAction.onDismiss?()
                }
            ) {
                Text(
                    whatsNewText: self.whatsNew.primaryAction.title
                )
            }
            .buttonStyle(
                PrimaryButtonStyle(
                    primaryAction: self.whatsNew.primaryAction,
                    layout: self.layout
                )
            )
            #if os(macOS)
            .keyboardShortcut(.defaultAction)
            #endif
        }
    }
    
}

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
