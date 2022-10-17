import Foundation
import UIKit

extension UIScreen {
    private static var config: () -> ViewImageConfig = { ViewImageConfig.global }

    @objc private dynamic var swizzledTraitCollection: UITraitCollection {
        Self.config().traits
    }

    @objc private dynamic var swizzledBounds: CGRect {
        let bounds = Self.config().size.map { CGRect(origin: .zero, size: $0) } ?? .zero
        return bounds
    }

    @objc private dynamic var swizzledScale: CGFloat {
        Self.config().traits.displayScale
    }

    @objc private dynamic var swizzledNativeScale: CGFloat {
        Self.config().nativeScale
    }

    @objc private dynamic var swizzledNativeBounds: CGRect {
        CGRect(
            origin: .zero,
            size: CGSize(width: swizzledBounds.width * swizzledNativeScale, height: swizzledBounds.height * swizzledNativeScale)
        )
    }


    static func swizzle() {
        exchange(#selector(getter: UIScreen.traitCollection), #selector(getter: UIScreen.swizzledTraitCollection))
        exchange(#selector(getter: UIScreen.bounds), #selector(getter: UIScreen.swizzledBounds))
        exchange(#selector(getter: UIScreen.scale), #selector(getter: UIScreen.swizzledScale))
        exchange(#selector(getter: UIScreen.nativeScale), #selector(getter: UIScreen.swizzledNativeScale))
        exchange(#selector(getter: UIScreen.nativeBounds), #selector(getter: UIScreen.swizzledNativeBounds))
    }

    private static func exchange(_ sel1: Selector, _ self2: Selector) {
        let originalMethod = class_getInstanceMethod(UIScreen.self, sel1)
        let swizzledMethod = class_getInstanceMethod(UIScreen.self, self2)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
