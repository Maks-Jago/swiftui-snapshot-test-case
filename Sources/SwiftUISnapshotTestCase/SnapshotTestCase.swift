import Foundation
import XCTest
import SnapshotTesting
@_exported import struct SnapshotTesting.ViewImageConfig
import SwiftUI

open class SnapshotTestCase: XCTestCase {
    open var isRecording: Bool = false
    open var devices: [ViewImageConfig] = [.iPhone13Pro]
    public static var deviceReference: String = "iPhone 15 Pro"

    private var recordMode: SnapshotTestingConfiguration.Record {
        isRecording ? .all : .missing
    }

    open override class func setUp() {
        let device = UIDevice.current.name
        if device != deviceReference {
            fatalError("Switch to using iPhone 15 Pro for these tests.")
        }

        UIView.setAnimationsEnabled(false)
        UIApplication.shared.windows.first?.layer.speed = 100
    }

    func snapshot(
        for view: some View,
        precision: Float = 0.99,
        perceptualPrecision: Float = 0.98,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line,
        column: UInt = #column
    ) {
        let vc = UIHostingController(rootView: view)
        withSnapshotTesting(record: recordMode) {
            for device in devices {
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
