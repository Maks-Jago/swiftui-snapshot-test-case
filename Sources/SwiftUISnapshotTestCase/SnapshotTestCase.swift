import Foundation
import XCTest
import SnapshotTesting
@_exported import struct SnapshotTesting.ViewImageConfig
import SwiftUI

open class SnapshotTestCase: XCTestCase {
    open var isRecording: Bool = false
    open var devices: [ViewImageConfig] = [.iPhone13, .iPhoneXsMax, .iPhone8, .iPhoneSe, .iPhone8Plus]

    public func snapshot<V: View>(for component: V, precision: Float = 1, colorScheme: ColorScheme = .light, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let view = component
            .environment(\.colorScheme, colorScheme)
            .preferredColorScheme(colorScheme)

        devices.forEach { deviceSize in
            let vc = SnapshotHostingController(rootView: view, insets: deviceSize.safeArea)
            validateOrRecord(for: vc, config: deviceSize, precision: precision, file: file, testName: testName + "_" + deviceSize.name, line: line)
        }
    }

    private func validateOrRecord<V: View>(for component: UIHostingController<V>, config: ViewImageConfig, precision: Float, file: StaticString, testName: String, line: UInt) {
        let bundlePath = Bundle(for: type(of: self)).bundlePath
        assertSnapshot(
            matching: component,
            as: .image(on: config, precision: precision),
            record: self.isRecording,
            snapshotDirectory: bundlePath,
            file: file,
            testName: testName,
            line: line
        )
    }
}
