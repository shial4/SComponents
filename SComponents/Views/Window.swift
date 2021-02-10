//
//  Window.swift
//  SComponents
//
//  Created by Szymon Lorenz on 10/2/21.
//

import Foundation
import SwiftUI

struct Window<Content: View>: View {
    @State private var popoverWindow: UIWindow?
    let content: () -> Content

    var body: some View {
        Color.clear
            .onAppear {
                newWindow()
            }
            .onDisappear {
                popoverWindow = nil
            }
    }

    // MARK: - Private

    private func newWindow() {
        guard let windowScene = UIApplication.shared.windows.first?.windowScene else { return }
        let newWindow = HostWindow<Content>(windowScene: windowScene)
        let rootViewController = UIHostingController(rootView: content())
        rootViewController.view.backgroundColor = .clear
        newWindow.rootViewController = rootViewController
        newWindow.backgroundColor = .clear
        newWindow.windowLevel = .normal + 1
        popoverWindow = newWindow
        newWindow.isHidden = false
    }
}

// MARK: - HostWindow

private class HostWindow<Content: View>: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if let viewController = hitView?.findViewController() as? UIHostingController<Content>, hitView === viewController.view {
            return nil
        }
        return hitView
    }
}

// MARK: - Utilities

private extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
