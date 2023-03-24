//
//  AutoWrap.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/3/23.
//



import SwiftUI

@available(iOS 16.0, *)
struct ViewKey<Element>: PreferenceKey {
    typealias Value = [Element]
    static var defaultValue: Value { Value() }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

struct BindID<ID: Hashable, Value: Hashable>: Hashable {
    let id: ID
    let value: Value
}
@available(iOS 16.0, *)
struct WidthWithID<ID: Hashable>: ViewModifier {
    typealias Element = BindID<ID, CGFloat>
    let id: ID

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo in
                Spacer().preference(
                    key: ViewKey<Element>.self,
                    value: [Element(id: id, value: geo.size.width)]
                )
            }
        )
    }
}

struct FrameWidth: Hashable {
    let frameWidth: CGFloat
}
@available(iOS 16.0, *)
struct FrameWidthPreference: ViewModifier {
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo in
                Spacer().preference(
                    key: ViewKey<FrameWidth>.self,
                    value: [FrameWidth(frameWidth: geo.size.width)]
                )
            }
        )
    }
}

struct FrameHeight: Hashable {
    let frameHeight: CGFloat
}
@available(iOS 16.0, *)
struct FrameHeightPreference: ViewModifier {
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: ViewKey<FrameHeight>.self,
                    value: [FrameHeight(frameHeight: geo.size.height)]
                )
            }
        )
    }
}

@available(iOS 16.0, *)
public struct _AutoWrap<Items, ID, Content>: View where Items: RandomAccessCollection, ID: Hashable, Content: View {
    let items: Array<Items.Element>
    let keyPath: KeyPath<Items.Element, ID>
    let vSpacing: CGFloat
    let hSpacing: CGFloat
    let content: (Items.Element) -> Content

    class ViewModel<Items: RandomAccessCollection>: ObservableObject {
        @Published var ranges: [Range<Int>]
        init(items: Items) {
            ranges = [0..<items.count]
        }
    }

    public init(_ items: Items,
                id: KeyPath<Items.Element, ID>,
                vSpacing: CGFloat = 3,
                hSpacing: CGFloat = 3,
                @ViewBuilder content: @escaping (Items.Element) -> Content
    ) {
        self.items = items.map { val in val }
        self.keyPath = id
        self.vSpacing = vSpacing
        self.hSpacing = hSpacing
        self.content = content
        _model = .init(wrappedValue: .init(items: items))
    }

    @StateObject var model: ViewModel<Items>
    @State private var frameWidth: CGFloat = .zero
    @State private var frameHeight: CGFloat = .zero
    @State private var subWidths: [ID: CGFloat] = [:]

    public var body: some View {
        GeometryReader { geo in
            HStack {
                VStack(alignment: .leading, spacing: vSpacing) {
                    ForEach(model.ranges, id: \.self) { range in
                        HStack(spacing: hSpacing) {
                            ForEach(range, id: \.self) { i in
                                content(items[i])
                                    .modifier(WidthWithID(id: items[i][keyPath: keyPath]))
                            }
                        }
                    }
                }
                .onPreferenceChange(ViewKey<WidthWithID<ID>.Element>.self) { values in
                    self.subWidths = [:]
                    values.forEach { val in
                        self.subWidths[val.id] = val.value
                    }
                    self.freshRanges()
                }

                Spacer(minLength: 0)
            }
            .frame(width: geo.size.width)
            .modifier(FrameWidthPreference())
            .onPreferenceChange(ViewKey<FrameWidth>.self) { values in
                values.forEach { val in
                    self.frameWidth = val.frameWidth
                }
                self.freshRanges()
            }
            .modifier(FrameHeightPreference())
            .onPreferenceChange(ViewKey<FrameHeight>.self) { values in
                values.forEach { val in
                    self.frameHeight = val.frameHeight
                }
                self.freshRanges()
            }
        }
        .frame(height: frameHeight)
    }

    func freshRanges() {
        guard frameWidth != .zero && subWidths.count == items.count else {
            return
        }
        model.ranges = []
        var start = 0, last = 0, sum: CGFloat = -hSpacing
        for (i, value) in items.enumerated() {
            let width = (subWidths[value[keyPath: keyPath]] ?? .zero) + hSpacing
            if sum + width >= frameWidth {
                model.ranges.append(start..<i)
                sum = -hSpacing
                start = i
            }
            sum += width
            last = i
        }
        if start <= last && items.count != 0 {
            model.ranges.append(start..<(last + 1))
        }
    }
}

@available(iOS 16.0, *)
public struct _Tag<Content>: View where Content: View {

    private let content: () -> Content
    private let fgcolor: Color
    private let bgcolor: Color


    public init(fgcolor: Color? = .init(uiColor: .systemBackground), bgcolor: Color? = .accentColor, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.fgcolor = fgcolor ?? .black
        self.bgcolor = bgcolor ?? .gray
    }

    public var body: some View {
        content()
            .foregroundColor(fgcolor)
            .fixedSize()
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(bgcolor)
            .cornerRadius(10)
    }
}
