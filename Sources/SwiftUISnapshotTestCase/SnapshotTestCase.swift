import Foundation
import XCTest
import SnapshotTesting
@_exported import struct SnapshotTesting.ViewImageConfig
import SwiftUI

open class SnapshotTestCase: XCTestCase {
    open var isRecording: Bool = false
    public static var devices: [ViewImageConfig] = [.iPhone15Pro]
    public static var deviceReference: String = "iPhone 15 Pro"
    public static var osVersionReference: String = "17.5"
    
    private var recordMode: SnapshotTestingConfiguration.Record {
        isRecording ? .all : .missing
    }
    
    private var shouldDrawHierarchyInKeyWindow: Bool = {
        if #available(iOS 26, *) {
            true
        } else {
            false
        }
    }()
    
    open override class func setUp() {
        let device = UIDevice.current.name
        if !device.contains(deviceReference) {
            fatalError("Switch to using \(deviceReference) (\(osVersionReference) for these tests.")
        }
        
        let systemVersion = UIDevice.current.systemVersion
        if systemVersion != osVersionReference {
            fatalError("Switch to using \(deviceReference) (\(osVersionReference) for these tests.")
        }
        
        UIView.setAnimationsEnabled(false)
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first(where: { $0.isKeyWindow })?.layer.speed = 100
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
        withSnapshotTesting(record: recordMode) {
            for device in Self.devices {
                if delayForLayout > 0 {
                    assertSnapshot(
                        of: view,
                        as: .wait(
                            for: delayForLayout,
                            on: .image(
                                drawHierarchyInKeyWindow: shouldDrawHierarchyInKeyWindow,
                                precision: precision,
                                perceptualPrecision: perceptualPrecision,
                                layout: .device(config: device)
                            )
                        ),
                        file: file,
                        testName: testName,
                        line: line,
                        column: column
                    )
                } else {
                    assertSnapshot(
                        of: view,
                        as: .image(
                            drawHierarchyInKeyWindow: shouldDrawHierarchyInKeyWindow,
                            precision: precision,
                            perceptualPrecision: perceptualPrecision,
                            layout: .device(config: device)
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
