import Foundation
import UIKit

extension UIScreen {
    @objc dynamic var swizzledTraitCollection: UITraitCollection {
        ViewImageConfig.global.traits
    }

    @objc dynamic var swizzledBounds: CGRect {
        let bounds = ViewImageConfig.global.size.map { CGRect(origin: .zero, size: $0) } ?? .zero
        return bounds
    }

    @objc dynamic var swizzledScale: CGFloat {
        ViewImageConfig.global.traits.displayScale
    }

    static func swizzle() {
        exchange(#selector(getter: UIScreen.traitCollection), #selector(getter: UIScreen.swizzledTraitCollection))
        exchange(#selector(getter: UIScreen.bounds), #selector(getter: UIScreen.swizzledBounds))
        exchange(#selector(getter: UIScreen.scale), #selector(getter: UIScreen.swizzledScale))
    }

    private static func exchange(_ sel1: Selector, _ self2: Selector) {
        let originalMethod = class_getInstanceMethod(UIScreen.self, sel1)
        let swizzledMethod = class_getInstanceMethod(UIScreen.self, self2)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
