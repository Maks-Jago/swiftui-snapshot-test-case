//
//  SnapshotHostingController.swift
//  
//
//  Created by Max Kuznetsov on 28.11.2021.
//

import Foundation
import SwiftUI

final class SnapshotHostingController<Content: View>: UIHostingController<Content> {
    var insets: UIEdgeInsets?

    init(rootView: Content, insets: UIEdgeInsets? = nil) {
        self.insets = insets
        super.init(rootView: rootView)

        let _class: AnyClass = view.classForCoder
        let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { [weak self] _ in
            return self?.insets ?? .zero
        }

        guard let method = class_getInstanceMethod(_class.self, #selector(getter: UIView.safeAreaInsets)) else {
            return
        }

        class_replaceMethod(_class, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SnapshotNavigationController: UINavigationController {
    var insets: UIEdgeInsets

    init(rootViewController: UIViewController, insets: UIEdgeInsets) {
        self.insets = insets
        super.init(rootViewController: rootViewController)

        let _class: AnyClass = view.classForCoder
        let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { [weak self] _ in
            return self?.insets ?? .zero
        }

        guard let method = class_getInstanceMethod(_class.self, #selector(getter: UIView.safeAreaInsets)) else {
            return
        }

        class_replaceMethod(_class, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
