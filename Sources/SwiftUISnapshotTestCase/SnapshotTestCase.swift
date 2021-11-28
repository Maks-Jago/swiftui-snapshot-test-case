import Foundation
import XCTest
import SnapshotTesting
@_exported import struct SnapshotTesting.ViewImageConfig
import SwiftUI

open class SnapshotTestCase: XCTestCase {
    open var isRecording: Bool = false
//    open var devices: [DeviceSize] = [.iPhone13ProMaxAndiPhone12ProMax, .iPhones13Pro_13_12Pro_12, .iPhone13miniAnd12mini, .iPhonesSE2_8_7_6S, .iPhoneSEAndiPodTouch7]
    open var devices: [ViewImageConfig] = [.iPhoneXsMax, .iPhone8, .iPhoneSe, .iPhone8Plus]

    public func snapshot<V: View>(for component: V, colorScheme: ColorScheme = .light, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let view = component
            .environment(\.colorScheme, colorScheme)
            .preferredColorScheme(colorScheme)

        devices.forEach { deviceSize in

            let viewWithSafeArea = view
                .edgesIgnoringSafeArea(.all)
                .padding(EdgeInsets(top: deviceSize.safeArea.top, leading: deviceSize.safeArea.left, bottom: deviceSize.safeArea.bottom, trailing: deviceSize.safeArea.right))
            validateOrRecord(for: UIHostingController(rootView: viewWithSafeArea), config: deviceSize, file: file, testName: testName + "_" + deviceSize.name, line: line)
        }
    }

//    private func validateOrRecord<V: View>(for component: UIHostingController<V>, scale: CGFloat, file: StaticString, testName: String, line: UInt) {
//        let bundlePath = Bundle(for: type(of: self)).bundlePath
////        assertSnapshot(matching: component, as: .image(scale: scale), record: self.isRecording, snapshotDirectory: bundlePath, file: file, testName: testName, line: line)
//        assertSnapshot(matching: component, as: .image(on: .iPadPro12_9), record: self.isRecording, snapshotDirectory: bundlePath, file: file, testName: testName, line: line)
//    }

    private func validateOrRecord<V: View>(for component: UIHostingController<V>, config: ViewImageConfig, file: StaticString, testName: String, line: UInt) {
        let bundlePath = Bundle(for: type(of: self)).bundlePath
        //        assertSnapshot(matching: component, as: .image(scale: scale), record: self.isRecording, snapshotDirectory: bundlePath, file: file, testName: testName, line: line)
        assertSnapshot(matching: component, as: .image(on: config), record: self.isRecording, snapshotDirectory: bundlePath, file: file, testName: testName, line: line)
    }

//    private func vc<V: View>(for view: V, device: DeviceSize) -> UIHostingController<V> {
//        let vc = UIHostingController(rootView: view)
////        vc.view.frame = .init(x: 0, y: 0, width: device.size.width, height: device.size.height)
//        return vc
//    }
}

//fileprivate extension DeviceSize {
//    var configs: ViewImageConfig {
//switch self {
//        case .iPhone13ProMaxAndiPhone12ProMax:
//            <#code#>
//        case .iPhone11ProMaxAndXSMax:
//            <#code#>
//        case .iPhones13Pro_13_12Pro_12:
//            <#code#>
//        case .iPhone13miniAnd12mini:
//            <#code#>
//        case .iPhone11AndiPhoneXR:
//            <#code#>
//        case .iPhones11Pro_XS_X:
//            <#code#>
//        case .iPhones8Plus_7Plus_6SPlus:
//            <#code#>
//        case .iPhonesSE2_8_7_6S:
//            <#code#>
//        case .iPhoneSEAndiPodTouch7:
//            <#code#>
//        case .iPadPro12Point9Inch:
//            <#code#>
//        case .iPadPro11Inch:
//            <#code#>
//        case .iPadAir10Point9Inch:
//            <#code#>
//        case .iPadAirAndPro10Point5Inch:
//            <#code#>
//        case .iPad10Point2Inch:
//            <#code#>
//        case .iPadProAndAir9Point7Inch:
//            <#code#>
//        case .iPadMini8Point3Inch:
//            <#code#>
//        case .iPadMini7Point9Inch:
//            return .iPadMini
//
//        }
//    }
//}
