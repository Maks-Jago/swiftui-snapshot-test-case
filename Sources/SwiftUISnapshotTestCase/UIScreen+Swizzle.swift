import Foundation
import UIKit

extension UIScreen {
    @objc dynamic var _traitCollection: UITraitCollection {
        ViewImageConfig.global.traits
    }

    @objc dynamic var _bounds: CGRect {
        let bounds = ViewImageConfig.global.size.map { CGRect(origin: .zero, size: $0) } ?? _bounds
        return bounds
    }

    @objc dynamic var _scale: CGFloat {
        _scale
    }

    static func swizzle() {
        exchange(#selector(getter: UIScreen.traitCollection), #selector(getter: UIScreen._traitCollection))
        exchange(#selector(getter: UIScreen.bounds), #selector(getter: UIScreen._bounds))
        exchange(#selector(getter: UIScreen.scale), #selector(getter: UIScreen._scale))
    }

    private static func exchange(_ sel1: Selector, _ self2: Selector) {
        let originalMethod = class_getInstanceMethod(UIScreen.self, sel1)
        let swizzledMethod = class_getInstanceMethod(UIScreen.self, self2)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
