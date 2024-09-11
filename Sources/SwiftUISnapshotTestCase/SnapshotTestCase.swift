import Foundation
import XCTest
import SnapshotTesting
@_exported import struct SnapshotTesting.ViewImageConfig
import SwiftUI

open class SnapshotTestCase: XCTestCase {
    open var isRecording: Bool = false
    open var devices: [ViewImageConfig] = [.iPhone13Pro]
    public static var deviceReference: String = "iPhone 15 Pro"
    public static var osVersionReference: String = "17.5"

    private var recordMode: SnapshotTestingConfiguration.Record {
        isRecording ? .all : .missing
    }

    open override class func setUp() {
        let device = UIDevice.current.name
        if device != deviceReference {
            fatalError("Switch to using \(deviceReference) (\(osVersionReference) for these tests.")
        }

        let systemVersion = UIDevice.current.systemVersion
        if systemVersion != osVersionReference {
            fatalError("Switch to using \(deviceReference) (\(osVersionReference) for these tests.")
        }

//        UIView.setAnimationsEnabled(false)
        UIApplication.shared.windows.first?.layer.speed = 100
    }

    public func snapshot(
        for view: some View,
        precision: Float = 0.99,
        perceptualPrecision: Float = 0.98,
        delayForLayout: TimeInterval = 0,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line,
        column: UInt = #column
    ) {
        let vc = UIHostingController(rootView: view)
        withSnapshotTesting(record: recordMode) {
            for device in devices {
                if delayForLayout > 0 {
                    assertSnapshot(
                        of: vc,
                        as: .wait(
                            for: delayForLayout,
                            on: .image(
                                on: device,
                                precision: precision,
                                perceptualPrecision: perceptualPrecision
                            )
                        ),
                        file: file,
                        testName: testName,
                        line: line,
                        column: column
                    )
                } else {
                    assertSnapshot(
                        of: vc,
                        as: .image(
                            on: device,
                            precision: precision,
                            perceptualPrecision: perceptualPrecision
                        ),
                        file: file,
                        testName: testName,
                        line: line,
                        column: column
                    )
                }
            }
        }
    }
}
