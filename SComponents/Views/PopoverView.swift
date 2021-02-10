//
//  PopoverView.swift
//  Components
//
//  Created by Szymon Lorenz on 10/2/21.
//

import SwiftUI

extension View {
    public func popover<Content: View>(isShowing: Binding<Bool>,
                                       backgroundColor: Color = .white,
                                       foregroundColor: Color = .black,
                                       content: @escaping () -> Content) -> some View {
        self.overlay( ZStack { if isShowing.wrappedValue {
            GeometryReader { proxy in
                Window {
                    PopoverView(from: proxy.frame(in: .global), backgroundColor: backgroundColor, foregroundColor: foregroundColor, content)
                        .onCancelAction {
                            isShowing.wrappedValue = false
                        }
                }
            }
                .zIndex(0)
        }})
    }
}

struct PopoverView<Content: View>: View {
    @State private var frame: CGRect = .zero
    
    private let fromRect: CGRect
    private var backgroundColor: Color
    private var foregroundColor: Color
    private let content: () -> Content
    private var cancelAction: () -> Void = {}

    init(from rect: CGRect,
         backgroundColor: Color = .white,
         foregroundColor: Color = .black,
         _ content: @escaping () -> Content) {
        self.fromRect = rect
        self.content = content
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(alignment: .top, spacing: 0) {
                    content().padding([.bottom, .leading ,.top], 8)
                    Button(action: cancelAction) {
                        XMark()
                            .stroke(foregroundColor, lineWidth: 2)
                            .frame(width: 10, height: 10)
                            .padding([.top, .horizontal], 8)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 8).fill(backgroundColor))
                .onFrameChange($frame)
                .position(position(in: geo.frame(in: .global), from: fromRect))
                .zIndex(1)

                Triangle(orientation: geo.frame(in: .global).midY < fromRect.midY ? .bottom : .top)
                    .fill(backgroundColor)
                    .frame(width: 20, height: 12)
                    .position(chevronPosition(in: geo.frame(in: .global), from: fromRect))
                    .zIndex(2)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func chevronPosition(in global: CGRect, from rect: CGRect) -> CGPoint {
        let isTopSide = global.midY < rect.midY
        let center = position(in: global, from: rect)
        let offsetY = 4 + frame.height / 2
        var x = rect.midX
        let width = frame.width
        let leftLedge: CGFloat = x - (width / 2)
        let rightLedge: CGFloat = x + (width / 2)
        
        if leftLedge < 0 {
            x += 13
        } else if rightLedge > global.width {
            x -= 13
        }
        return CGPoint(x: x, y: isTopSide ? center.y + offsetY : center.y - offsetY)
    }

    private func position(in global: CGRect, from rect: CGRect) -> CGPoint {
        let isTopSide = global.midY < rect.midY
        let spacing: CGFloat = 18
        let offsetY: CGFloat = (rect.height + frame.height) / 2 + spacing
        let y: CGFloat = rect.midY + (isTopSide ? -offsetY : offsetY)
        var x = rect.midX
        let popoverWidth = frame.width
        let leftLedge: CGFloat = x - (popoverWidth / 2)
        let rightLedge: CGFloat = x + (popoverWidth / 2)
        
        if leftLedge < 0 {
            x -= leftLedge
        } else if rightLedge > global.width {
            x -= (rightLedge - global.width)
        }

        return CGPoint(x: x, y: y)
    }
}

extension PopoverView {
    func onCancelAction(_ action: @escaping () -> Void) -> Self {
        var view = self
        view.cancelAction = action
        return view
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var text: String = "Content"
    static var previews: some View {
        GeometryReader { proxy in
            ZStack {
                Color.gray.edgesIgnoringSafeArea(.all)
                PopoverView(from: CGRect(origin: CGPoint(x: proxy.frame(in: .global).minX, y: proxy.frame(in: .global).minY), size: .zero)) {
                    Text(text)
                }
                
                PopoverView(from: CGRect(origin: CGPoint(x: proxy.frame(in: .global).maxX, y: proxy.frame(in: .global).minY), size: .zero)) {
                    Text(text)
                }
                
                PopoverView(from: CGRect(origin: CGPoint(x: proxy.frame(in: .global).minX, y: proxy.frame(in: .global).maxY), size: .zero)) {
                    Text(text)
                }
                
                PopoverView(from: CGRect(origin: CGPoint(x: proxy.frame(in: .global).maxX, y: proxy.frame(in: .global).maxY), size: .zero)) {
                    Text(text)
                }
                
                PopoverView(from: CGRect(origin: CGPoint(x: proxy.frame(in: .global).minX, y: proxy.frame(in: .global).midY - 10), size: .zero)) {
                    Text(text)
                }
                
                PopoverView(from: CGRect(origin: CGPoint(x: proxy.frame(in: .global).maxX, y: proxy.frame(in: .global).midY), size: .zero)) {
                    Text(text)
                }
                
                PopoverView(from: CGRect(origin: CGPoint(x: proxy.frame(in: .global).midX, y: proxy.frame(in: .global).midY), size: .zero)) {
                    Text(text)
                }
                
                PopoverView(from: CGRect(origin: CGPoint(x: proxy.frame(in: .global).midX, y: proxy.frame(in: .global).midY - 10), size: .zero)) {
                    Text(text)
                }
            }
        }
    }
}
