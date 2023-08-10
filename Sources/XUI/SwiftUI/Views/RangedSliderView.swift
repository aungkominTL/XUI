//
//  File.swift
//  
//
//  Created by Aung Ko Min on 29/7/23.
//

import SwiftUI

public struct RangedSliderView: View {

    private let currentValue: Binding<ClosedRange<Int>>
    private let sliderBounds: ClosedRange<Int>
    private let step: Float
    private let formatter = KMBFormatter()

    @State private var isLowerActive = false
    @State private var isUpperActive = false

    public init(value: Binding<ClosedRange<Int>>, bounds: ClosedRange<Int>, step: Float) {
        self.currentValue = value
        self.sliderBounds = bounds
        self.step = step
    }

    public var body: some View {
        VStack(spacing: 1) {
            Spacer(minLength: 20)
            GeometryReader { geomentry in
                sliderView(sliderSize: geomentry.size)
            }
        }
    }

    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.secondary.opacity(0.5))
                .frame(height: 5)

            ZStack {
                let sliderBoundDifference = sliderBounds.count
                let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)

                // Calculate Left Thumb initial position
                let leftThumbLocation: CGFloat = currentValue.wrappedValue.lowerBound == (sliderBounds.lowerBound)
                ? 0
                : CGFloat(Float(currentValue.wrappedValue.lowerBound - sliderBounds.lowerBound)) * stepWidthInPixel

                // Calculate right thumb initial position
                let rightThumbLocation = CGFloat(currentValue.wrappedValue.upperBound) * stepWidthInPixel

                // Path between both handles
                lineBetweenThumbs(from: .init(x: leftThumbLocation, y: sliderViewYCenter), to: .init(x: rightThumbLocation, y: sliderViewYCenter))

                // Left Thumb Handle
                let leftThumbPoint = CGPoint(x: leftThumbLocation, y: sliderViewYCenter)
                thumbView(position: leftThumbPoint, value: Float(currentValue.wrappedValue.lowerBound))
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { dragValue in
                                let dragLocation = dragValue.location
                                let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width)

                                let newValue = Float(sliderBounds.lowerBound) + Float(xThumbOffset / stepWidthInPixel)

                                let rounded = ((newValue / step) * step).int
                                // Stop the range thumbs from colliding each other
                                if rounded < currentValue.wrappedValue.upperBound {
                                    isLowerActive = true
                                    currentValue.wrappedValue = rounded...currentValue.wrappedValue.upperBound
                                    _Haptics.play(.soft)
                                }
                            } .onEnded { value in
                                isLowerActive = false
                            }
                    )
                    .foregroundStyle(isLowerActive ? .primary : .tertiary)


                // Right Thumb Handle
                thumbView(position: CGPoint(x: rightThumbLocation, y: sliderViewYCenter), value: Float(currentValue.wrappedValue.upperBound))
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { dragValue in
                                let dragLocation = dragValue.location
                                let xThumbOffset = min(max(CGFloat(leftThumbLocation), dragLocation.x), sliderSize.width)

                                var newValue = Float(xThumbOffset / stepWidthInPixel) // convert back the value bound
                                newValue = min(newValue, Float(sliderBounds.upperBound))

                                let rounded = ((newValue / step) * step).int
                                // Stop the range thumbs from colliding each other
                                if rounded > currentValue.wrappedValue.lowerBound {
                                    isUpperActive = true
                                    currentValue.wrappedValue = currentValue.wrappedValue.lowerBound...rounded
                                    _Haptics.play(.soft)
                                }
                            } .onEnded {_ in
                                isUpperActive = false
                            }
                    )
                    .foregroundStyle(isUpperActive ? .primary : .tertiary)
            }
            .animation(.interactiveSpring(), value: currentValue.wrappedValue)
        }
    }

    @ViewBuilder private func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .stroke(Color.green,lineWidth: 5)
    }

    @ViewBuilder private func thumbView(position: CGPoint, value: Float) -> some View {
        ZStack {
            Text(formatter.string(fromNumber: Int(value)))
                .font(.footnote.bold().italic())
                .offset(y: -23)

            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor( isValid(Int(value)) ? .green : .white)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 0)
                .contentShape(Rectangle())
                .padding()
        }
        .position(x: position.x, y: position.y)
    }

    private func isValid(_ value: Int) -> Bool {
        value != sliderBounds.lowerBound && value != sliderBounds.upperBound
    }
}
