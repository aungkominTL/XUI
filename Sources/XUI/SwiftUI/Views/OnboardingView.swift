//
//  OnBoardingView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/4/23.
//

import SwiftUI

public enum Onboarding {
    static let key = "com.jonahaung.hasShownOnboarding"
    public static var hasShown: Bool {
        get {
            UserDefaults.standard.bool(forKey: Self.key)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Self.key)
        }
    }
}
public struct OnboardingItem: Identifiable, Hashable {
    
    public let id = UUID()
    public let title: String
    public let subtitle: String
    public let imageName: String
    
    public init(title: String, subtitle: String, imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
}

public struct OnboardingView: View {

    @State private var current = 0
    private let items: [OnboardingItem]
    private let onClose: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    
    public init(items: [OnboardingItem], _ onClose: (() -> Void)? = nil) {
        self.items = items
        self.onClose = onClose
    }
    
    public var body: some View {
        TabView(selection: $current) {
            ForEach(0..<items.count, id: \.self) { i in
                if let item = items[safe: i] {
                    OnboardingCell(item: item, index: i)
                        .tag(i)
                }
            }
        }
        .animation(.snappy, value: current)
        .overlay(overlayView)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(.container, edges: .vertical)
        .statusBarHidden(true)
    }
    
    private var overlayView: some View {
        VStack {
            HStack {
                Spacer()
                if self.hasNext {
                    Button {
                        skip()
                    } label: {
                        Image(systemName: "chevron.forward.2")
                            .imageScale(.large)
                            .padding()
                    }
                }
            }
            Spacer()
            HStack {
                if self.hasNext {
                    Button {
                        next()
                    } label: {
                        Image(systemName: "arrowshape.right.fill")
                            .imageScale(.large)
                            .padding()
                    }
                } else {
                    let hasShownOnboarding = Onboarding.hasShown
                    Button {
                        Onboarding.hasShown = true
                        dismiss()
                        onClose?()
                    } label: {
                        Text(hasShownOnboarding ? "Close" : "Done & Continue")
                            ._borderedProminentButtonStyle()
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
    
    private var hasNext: Bool { current+1 < items.count  }
    private var hasPrevious: Bool { current > 0 }
    
    private func next() {
        if hasNext  {
            current += 1
        }
    }
    
    private func previous() {
        if hasPrevious {
            current -= 1
        }
    }
    private func skip() {
        if hasNext {
            current = items.count-1
        }
    }
}

private struct OnboardingCell: View {
    let item: OnboardingItem
    let index: Int
    var body: some View {
        GeometryReader { geo in
            StickyHeaderScrollView(header: {
                StickyHeaderImage(Image(item.imageName))
            }, headerHeight: geo.size.height/2.5) {
                VStack {
                    Text(item.title)
                        .font(.title)
                    Text(item.subtitle)
                        .font(.body)
                }
                .padding()
            }}
    }
}
