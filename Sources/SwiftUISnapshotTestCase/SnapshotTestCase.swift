import Foundation
import XCTest
import SnapshotTesting
@_exported import struct SnapshotTesting.ViewImageConfig
@_exported import enum SnapshotTesting.RenderingMode
import SwiftUI

open class SnapshotTestCase: XCTestCase {
    open var isRecording: Bool = false
    open var devices: [ViewImageConfig] = [.iPhone13, .iPhone13Mini, .iPhone8, .iPhone8Plus, .iPhoneSE2]

    public func snapshot<V: View>(
        for component: V,
        renderingMode: RenderingMode = .snapshot(afterScreenUpdates: true),
        precision: Float = 1,
        colorScheme: ColorScheme = .light,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        DispatchQueue.once {
            UIScreen.swizzle()
        }

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
            ViewImageConfig.global = deviceSize
            var vc: UIViewController = SnapshotHostingController(rootView: view, insets: deviceSize.safeArea)

            switch deviceSize.options {
            case .navigationBarLargeTitle:
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationItem.largeTitleDisplayMode = .always
                navController.navigationBar.prefersLargeTitles = true
                vc = navController

            case .navigationBarInline:
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationItem.largeTitleDisplayMode = .never
                navController.navigationBar.prefersLargeTitles = false
                vc = navController

            default:
                break
            }

            validateOrRecord(
                for: vc,
                config: deviceSize,
                precision: precision,
                renderingMode: renderingMode,
                interfaceStyle: interfaceStyle,
                file: file,
                testName: testName + "_" + deviceSize.name,
                line: line
            )
        }
    }

    private func validateOrRecord(
        for component: UIViewController,
        config: ViewImageConfig,
        precision: Float,
        renderingMode: RenderingMode,
        interfaceStyle: UIUserInterfaceStyle,
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        let bundlePath = Bundle(for: type(of: self)).bundlePath
        assertSnapshot(
            matching: component,
            as: .image(
                on: config,
                renderingMode: renderingMode,
                precision: precision,
                traits: config.traits,
                interfaceStyle: interfaceStyle
            ),
            record: self.isRecording,
            snapshotDirectory: bundlePath,
            addAttachment: { self.add($0) },
            file: file,
            testName: testName,
            line: line
        )
    }
}
