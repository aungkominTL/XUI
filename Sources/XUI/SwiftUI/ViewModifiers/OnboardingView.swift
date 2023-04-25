//
//  OnBoardingView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/4/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct _Onboarding: Identifiable, Hashable {

    public let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String

    public init(title: String, subtitle: String, imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
}

@available(iOS 16.0.0, *)
public struct _OnboardingView: View {

    private var hasShownOnboarding: Binding<Bool>
    @State private var current = 0
    private let items: [_Onboarding]

    @Environment(\.dismiss) private var dismiss

    public init(hasShownOnboarding: Binding<Bool>, items: [_Onboarding]) {
        self.hasShownOnboarding = hasShownOnboarding
        self.items = items
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
        .animation(.interactiveSpring(), value: current)
        .background(Color(uiColor: .systemBackground))
        .overlay(overlayView)
        .tabViewStyle(.page(indexDisplayMode: .never))
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
                    Button {
                        if hasShownOnboarding.wrappedValue == true {
                            dismiss()
                        } else {
                            hasShownOnboarding.wrappedValue = true
                        }
                    } label: {
                        Text(hasShownOnboarding.wrappedValue ? "Close" : "Done & Continue")
                    }
                    ._borderedProminentButtonStyle()
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

@available(iOS 16.0.0, *)
private struct OnboardingCell: View {
    let item: _Onboarding
    let index: Int
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Image(item.imageName)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
            VStack {
                Text(item.title)
                    .font(.title)
                Text(item.subtitle)
                    .font(.body)
            }
            .padding()
            Spacer(minLength: 50)
        }
    }
}
