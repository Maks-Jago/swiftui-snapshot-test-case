#if os(iOS)
import UIKit
import SnapshotTesting

public extension ViewImageConfig {
    
    // MARK: - iPhone 14 Pro
    // 6.1" Display | 393 x 852 pts | Dynamic Island
    static let iPhone14Pro = ViewImageConfig.iPhone14Pro(.portrait)

    static func iPhone14Pro(_ orientation: Orientation) -> ViewImageConfig {
        let safeArea: UIEdgeInsets
        let size: CGSize
        switch orientation {
        case .landscape:
            safeArea = .init(top: 0, left: 59, bottom: 21, right: 59)
            size = .init(width: 852, height: 393)
        case .portrait:
            safeArea = .init(top: 59, left: 0, bottom: 34, right: 0)
            size = .init(width: 393, height: 852)
        }
        return .init(safeArea: safeArea, size: size, traits: .iPhone13(orientation))
    }

    // MARK: - iPhone 15 Pro
    // 6.1" Display | 393 x 852 pts | Dynamic Island
    static let iPhone15Pro = ViewImageConfig.iPhone15Pro(.portrait)

    static func iPhone15Pro(_ orientation: Orientation) -> ViewImageConfig {
        return .iPhone14Pro(orientation)
    }

    // MARK: - iPhone 16 Pro
    // 6.3" Display | 402 x 874 pts | Dynamic Island
    static let iPhone16Pro = ViewImageConfig.iPhone16Pro(.portrait)

    static func iPhone16Pro(_ orientation: Orientation) -> ViewImageConfig {
        let safeArea: UIEdgeInsets
        let size: CGSize
        switch orientation {
        case .landscape:
            safeArea = .init(top: 0, left: 62, bottom: 21, right: 62)
            size = .init(width: 874, height: 402)
        case .portrait:
            safeArea = .init(top: 62, left: 0, bottom: 34, right: 0)
            size = .init(width: 402, height: 874)
        }
        return .init(safeArea: safeArea, size: size, traits: .iPhone13(orientation))
    }

    // MARK: - iPhone 17 Pro
    // 6.3" Display | 402 x 874 pts | Dynamic Island
    static let iPhone17Pro = ViewImageConfig.iPhone17Pro(.portrait)

    static func iPhone17Pro(_ orientation: Orientation) -> ViewImageConfig {
        return .iPhone16Pro(orientation)
    }
}
#endif
