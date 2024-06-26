import Foundation
import CoreGraphics

public enum DeviceSize: String, CaseIterable {
    // iPhones:
    case iPhone13ProMaxAndiPhone12ProMax
    case iPhone11ProMaxAndXSMax
    case iPhones13Pro_13_12Pro_12
    case iPhone13miniAnd12mini
    case iPhone11AndiPhoneXR
    case iPhones11Pro_XS_X
    case iPhones8Plus_7Plus_6SPlus
    case iPhonesSE2_8_7_6S
    case iPhoneSEAndiPodTouch7
    case iPhone15Pro

    // iPads:
    case iPadPro12Point9Inch
    case iPadPro11Inch
    case iPadAir10Point9Inch
    case iPadAirAndPro10Point5Inch
    case iPad10Point2Inch
    case iPadProAndAir9Point7Inch
    case iPadMini8Point3Inch
    case iPadMini7Point9Inch

    var size: CGSize {
        switch self {
            // iPhones
        case .iPhone13ProMaxAndiPhone12ProMax:
            return .init(width: 428, height: 926)
        case .iPhone11ProMaxAndXSMax:
            return .init(width: 414, height: 896)
        case .iPhones13Pro_13_12Pro_12:
            return .init(width: 390, height: 844)
        case .iPhone13miniAnd12mini:
            return .init(width: 375, height: 812)
        case .iPhone11AndiPhoneXR:
            return .init(width: 414, height: 896)
        case .iPhones11Pro_XS_X:
            return .init(width: 375, height: 812)
        case .iPhones8Plus_7Plus_6SPlus:
            return .init(width: 414, height: 736)
        case .iPhonesSE2_8_7_6S:
            return .init(width: 375, height: 667)
        case .iPhoneSEAndiPodTouch7:
            return .init(width: 320, height: 568)
        case .iPhone15Pro:
            return .init(width: 393, height: 852)

            // iPads:
        case .iPadPro12Point9Inch:
            return .init(width: 1024, height: 1366)
        case .iPadPro11Inch:
            return .init(width: 834, height: 1194)
        case .iPadAir10Point9Inch:
            return .init(width: 820, height: 1180)
        case .iPadAirAndPro10Point5Inch:
            return .init(width: 834, height: 1112)
        case .iPad10Point2Inch:
            return .init(width: 810, height: 1080)
        case .iPadProAndAir9Point7Inch:
            return .init(width: 768, height: 1024)
        case .iPadMini8Point3Inch:
            return .init(width: 744, height: 1133)
        case .iPadMini7Point9Inch:
            return .init(width: 768, height: 1024)
        }
    }

    var scaleFactor: CGFloat {
        switch self {
        case .iPhone13ProMaxAndiPhone12ProMax, .iPhone11ProMaxAndXSMax, .iPhones13Pro_13_12Pro_12, .iPhone13miniAnd12mini, .iPhones11Pro_XS_X, .iPhones8Plus_7Plus_6SPlus, .iPhone15Pro:
            return 3.0

        case .iPhone11AndiPhoneXR, .iPhonesSE2_8_7_6S, .iPhoneSEAndiPodTouch7:
            return 2.0

        case _ where Self.allPads.contains(self):
            return 2.0

        default:
            return 1.0
        }
    }

    var scaledSize: CGSize {
        CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
    }

    public static var allPhones: [DeviceSize] = [.iPhone13ProMaxAndiPhone12ProMax, .iPhone11ProMaxAndXSMax, .iPhones13Pro_13_12Pro_12, .iPhone13miniAnd12mini, .iPhone11AndiPhoneXR, .iPhones11Pro_XS_X, .iPhones8Plus_7Plus_6SPlus, .iPhonesSE2_8_7_6S, .iPhoneSEAndiPodTouch7, .iPhone15Pro]

    public static var allPads: [DeviceSize] = [.iPadPro12Point9Inch, .iPadPro11Inch, .iPadAir10Point9Inch, .iPadAirAndPro10Point5Inch, .iPad10Point2Inch, .iPadProAndAir9Point7Inch, .iPadMini8Point3Inch, .iPadMini7Point9Inch]
}
