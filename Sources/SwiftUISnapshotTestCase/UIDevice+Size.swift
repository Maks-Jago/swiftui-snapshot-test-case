import Foundation
import struct CoreGraphics.CGSize

/// This enum gives us simple way how to recognize which UIDevice size
///
/// For the resolutions, refer to
/// Apple official website:
/// https://developer.apple.com/library/archive/documentation/DeviceInformation/Reference/iOSDeviceCompatibility/Displays/Displays.html
/// Because the documentation is missing, I ran simulators and manually checked some resolutions on
/// `UIScreen.main.bounds` (for Xr, XS Max and 11-inch iPhones) Apple somehow doesn't update the documentation.
public enum DeviceSize: String, CaseIterable {
    // iPhones:
    case iPhoneX // XS
    case iPhoneXSMax // Fun fact: Xr has same logical resolution as XS Max.
    // https://stackoverflow.com/a/52425261/5774854
    case iPhone8Plus // Since iPhone 6+, this works for all of our screens
    case iPhone8 // Since iPhone 6, this works for all of our screens
    case iPhoneSE // iPhone 5, 5S... SE 2 maybe? 🚀
    case iPhone4 // 4S
    // iPads:
    case iPadAir // Also known as: iPad 3, iPad 4, iPad Air, iPad Air 2, 9.7-inch iPad Pro
    // iPad Minis have same logical resolutions, but are different in PPI (higher) and physical display.
    // I expect them to behave the same in same logical resolutions.
    case iPadPro10AndHalfInch
    case iPadPro11Inch
    case iPadPro12Point9Inch

    var size: CGSize {
        switch self {
            // iPhones
        case .iPhoneX:
            return .init(width: 375, height: 812)
        case .iPhoneXSMax:
            return .init(width: 414, height: 896)
        case .iPhone8Plus:
            return .init(width: 414, height: 736)
        case .iPhone8:
            return .init(width: 375, height: 667)
        case .iPhoneSE:
            return .init(width: 320, height: 568)
        case .iPhone4:
            return .init(width: 320, height: 480)
            // iPads:
        case .iPadAir:
            return .init(width: 768, height: 1024)
        case .iPadPro10AndHalfInch:
            return .init(width: 834, height: 1112)
        case .iPadPro11Inch:
            return .init(width: 834, height: 1194)
        case .iPadPro12Point9Inch:
            return .init(width: 1024, height: 1366)
        }
    }
}
