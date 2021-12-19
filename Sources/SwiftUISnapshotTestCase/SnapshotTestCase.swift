import Foundation
import XCTest
import SnapshotTesting
@_exported import struct SnapshotTesting.ViewImageConfig
import SwiftUI

open class SnapshotTestCase: XCTestCase {
    open var isRecording: Bool = false
    open var devices: [ViewImageConfig] = [.iPhone13, .iPhone13Mini, .iPhone8, .iPhone8Plus, .iPhoneSE2]

    public func snapshot<V: View>(for component: V, precision: Float = 1, colorScheme: ColorScheme = .light, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let view = component
            .environment(\.colorScheme, colorScheme)
            .preferredColorScheme(colorScheme)

        var interfaceStyle: UIUserInterfaceStyle {
            switch colorScheme {
            case .light:
                return .light
            case .dark:
                return .dark
            @unknown default:
                return .light
            }
        }

        devices.forEach { deviceSize in
            let vc = SnapshotHostingController(rootView: view, insets: deviceSize.safeArea)
            validateOrRecord(
                for: vc,
                config: deviceSize,
                precision: precision,
                interfaceStyle: interfaceStyle,
                file: file,
                testName: testName + "_" + deviceSize.name,
                line: line
            )
        }
    }

    private func validateOrRecord<V: View>(
        for component: UIHostingController<V>,
        config: ViewImageConfig,
        precision: Float,
        interfaceStyle: UIUserInterfaceStyle,
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        let bundlePath = Bundle(for: type(of: self)).bundlePath
        assertSnapshot(
            matching: component,
            as: .image(on: config, precision: precision, interfaceStyle: interfaceStyle),
            record: self.isRecording,
            snapshotDirectory: bundlePath,
            addAttachment: { self.add($0) },
            file: file,
            testName: testName,
            line: line
        )
    }
}
