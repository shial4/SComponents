//
//  ContentView.swift
//  Components
//
//  Created by Szymon Lorenz on 10/2/21.
//

import SwiftUI
import SComponents

enum PopoverLocation: String {
    case topLeft
    case top
    case topRight
    case bottomRight
    case bottom
    case bottomLeft
    case upperLeft
    case upperCenter
    case upperRight
    case lowerLeft
    case lowerCenter
    case lowerRight
}

struct ContentView: View {
    @State private var isShowingPopover: Bool = true
    @State private var popoverLocation: PopoverLocation = .lowerCenter

    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            VStack(spacing: 16) {
                HStack {
                    button(.topLeft)
                    Spacer()
                    button(.top)
                    Spacer()
                    button(.topRight)
                }
                Spacer()
                HStack {
                    button(.upperLeft)
                    Spacer()
                    button(.upperCenter)
                    Spacer()
                    button(.upperRight)
                }
                HStack {
                    button(.lowerLeft)
                    Spacer()
                    button(.lowerCenter)
                    Spacer()
                    button(.lowerRight)
                }
                Spacer()
                HStack {
                    button(.bottomLeft)
                    Spacer()
                    button(.bottom)
                    Spacer()
                    button(.bottomRight)
                }
            }.padding()
        }
    }
    
    func button(_ location: PopoverLocation) -> some View {
        Button("show") {
            popoverLocation = location
            isShowingPopover = true
        }.popover(isShowing: Binding(get: {
            popoverLocation == location && isShowingPopover
        }, set: { value in
            isShowingPopover = value
        }), content: {
            Text(location.rawValue)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
