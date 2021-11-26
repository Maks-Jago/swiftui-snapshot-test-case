import Foundation
import XCTest
import SnapshotTesting
import SwiftUI

open class SnapshotTestCase: XCTestCase {
    open var isRecording: Bool = false
    open var devices: [DeviceSize] = [.iPhone13ProMaxAndiPhone12ProMax, .iPhones13Pro_13_12Pro_12, .iPhone13miniAnd12mini, .iPhonesSE2_8_7_6S, .iPhoneSEAndiPodTouch7]

    public func snapshot<V: View>(for component: V, colorScheme: ColorScheme = .light, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let view = component
            .environment(\.colorScheme, colorScheme)
            .preferredColorScheme(colorScheme)

        devices.forEach { deviceSize in
            validateOrRecord(for: vc(for: view, device: deviceSize), scale: deviceSize.scaleFactor, file: file, testName: testName + "_" + deviceSize.rawValue, line: line)
        }
    }

    private func validateOrRecord<V: View>(for component: UIHostingController<V>, scale: CGFloat, file: StaticString, testName: String, line: UInt) {
        let bundlePath = Bundle(for: type(of: self)).bundlePath
        assertSnapshot(matching: component, as: .image(scale: scale), record: self.isRecording, snapshotDirectory: bundlePath, file: file, testName: testName, line: line)
    }

    private func vc<V: View>(for view: V, device: DeviceSize) -> UIHostingController<V> {
        let vc = UIHostingController(rootView: view)
        vc.view.frame = .init(x: 0, y: 0, width: device.scaledSize.width, height: device.scaledSize.height)
        return vc
    }
}
