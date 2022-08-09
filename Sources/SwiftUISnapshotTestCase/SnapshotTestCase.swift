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
            let vc = SnapshotHostingController(rootView: navView(rootView: view, options: deviceSize.options), insets: deviceSize.safeArea)

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

    @ViewBuilder
    private func navView<R: View>(rootView: R, options: ViewImageConfig.Options) -> some View {
        switch options {
        case .navigationBarInline:
            NavigationView {
                rootView
                    .navigationBarTitleDisplayMode(.inline)
            }
        case .navigationBarLargeTitle:
            NavigationView {
                rootView
                    .navigationBarTitleDisplayMode(.large)
            }

        default:
            rootView
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
