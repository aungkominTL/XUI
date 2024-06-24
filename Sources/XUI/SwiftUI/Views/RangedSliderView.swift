//
//  RangedSliderView.swift
//
//
//  Created by Aung Ko Min on 29/7/23.
//

import SwiftUI

public struct RangedSliderView: View {
    enum Constants {
        static let thumbSize = CGFloat(30)
    }
    @Binding private var originalValue: ClosedRange<Int>
    @State private var currentValue: ClosedRange<Int>
    private let sliderBounds: ClosedRange<Int>
    private let step: Float
    private let formatter = KMBFormatter()
    
    @State private var isLowerActive = false
    @State private var isUpperActive = false
    
    public init(value: Binding<ClosedRange<Int>>, bounds: ClosedRange<Int>, step: Float) {
        self._originalValue = value
        self.currentValue = value.wrappedValue
        self.sliderBounds = bounds
        self.step = step
    }
    
    public var body: some View {
        VStack(spacing: 1) {
            Color.clear
                .frame(height: 25)
            GeometryReader { geomentry in
                sliderView(sliderSize: geomentry.size)
            }
        }
        .padding(.trailing, Constants.thumbSize/2)
        ._flexible(.horizontal)
        .padding(.horizontal)
        .onChange(of: originalValue) { oldValue, newValue in
            if currentValue != originalValue {
                currentValue = originalValue
            }
        }
    }
    
    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        ZStack {
            let sliderBoundDifference = sliderBounds.count
            let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)
            
            let leftThumbLocation: CGFloat = currentValue.lowerBound == (sliderBounds.lowerBound)
            ? 0
            : CGFloat(Float(currentValue.lowerBound - sliderBounds.lowerBound)) * stepWidthInPixel
            
            let rightThumbLocation = CGFloat(currentValue.upperBound) * stepWidthInPixel
            lineBetweenThumbs(from: .init(x: leftThumbLocation, y: sliderViewYCenter), to: .init(x: rightThumbLocation, y: sliderViewYCenter))
            
            let leftThumbPoint = CGPoint(x: leftThumbLocation, y: sliderViewYCenter)
            thumbView(position: leftThumbPoint, value: Float(currentValue.lowerBound))
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { dragValue in
                            let dragLocation = dragValue.location
                            let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width + Constants.thumbSize/2)
                            
                            let newValue = Float(sliderBounds.lowerBound) + Float(xThumbOffset / stepWidthInPixel)
                            
                            let rounded = ((newValue / step) * step).int
                            // Stop the range thumbs from colliding each other
                            if rounded < currentValue.upperBound {
                                isLowerActive = true
                                currentValue = rounded...currentValue.upperBound
                                if rounded != 0 && rounded % 5 == 0 { // Prevent repeated vibration
                                    _Haptics.play(.soft)
                                }
                            }
                        }.onEnded { value in
                            isLowerActive = false
                            updateValue()
                        }
                )
                .foregroundStyle(isLowerActive ? .primary : .tertiary)
            
            thumbView(position: CGPoint(x: rightThumbLocation, y: sliderViewYCenter), value: Float(currentValue.upperBound))
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { dragValue in
                            let dragLocation = dragValue.location
                            let xThumbOffset = min(max(CGFloat(leftThumbLocation), dragLocation.x), sliderSize.width + Constants.thumbSize)
                            
                            var newValue = Float(xThumbOffset / stepWidthInPixel) // convert back the value bound
                            newValue = min(newValue, Float(sliderBounds.upperBound))
                            
                            let rounded = ((newValue / step) * step).int
                            // Stop the range thumbs from colliding each other
                            if rounded > currentValue.lowerBound {
                                isUpperActive = true
                                currentValue = currentValue.lowerBound...rounded
                                if rounded % 5 == 0 {
                                    _Haptics.play(.soft)
                                }
                            }
                        } .onEnded {_ in
                            isUpperActive = false
                            updateValue()
                        }
                )
                .foregroundStyle(isUpperActive ? .primary : .tertiary)
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
                .font(isLowerActive || isUpperActive ? .title : .footnote.bold().italic())
                .offset(
                    x: Int(value) == self.currentValue.lowerBound ? Constants.thumbSize : Int(value) == currentValue.upperBound ? -Constants.thumbSize : 0,
                    y: isLowerActive || isUpperActive ? -35 : -23
                )
            
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle( isValid(Int(value)) ? Color.green.gradient : Color.systemBackground.gradient)
                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 0)
                .contentShape(Circle())
        }
        .position(x: position.x, y: position.y)
        .compositingGroup()
    }
    
    private func isValid(_ value: Int) -> Bool {
        value != sliderBounds.lowerBound && value != sliderBounds.upperBound
    }
    
    private func updateValue() {
        originalValue = currentValue
        _Haptics.play(.rigid)
    }
}
