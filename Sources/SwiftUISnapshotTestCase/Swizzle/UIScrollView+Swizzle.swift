import Foundation
import UIKit

extension UIScrollView {
    @objc private dynamic var swizzledContentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior {
        .never
    }

    static func swizzle() {
        exchange(#selector(getter: UIScrollView.contentInsetAdjustmentBehavior), #selector(getter: UIScrollView.swizzledContentInsetAdjustmentBehavior))
    }

    private static func exchange(_ sel1: Selector, _ self2: Selector) {
        let originalMethod = class_getInstanceMethod(UIScrollView.self, sel1)
        let swizzledMethod = class_getInstanceMethod(UIScrollView.self, self2)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
