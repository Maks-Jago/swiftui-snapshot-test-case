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
        renderingMode: RenderingMode = .drawHierarchy(afterScreenUpdates: true),
        precision: Float = 0.99,
        perceptualPrecision: Float = 0.98,
        png: Bool = false,
        colorScheme: ColorScheme = .light,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        DispatchQueue.once {
            UIScreen.swizzle()
            UIScrollView.swizzle()
        }

        UIView.setAnimationsEnabled(false)

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

            var vc: UIViewController!

            switch deviceSize.options {
            case .navigationBarInline:
                let hosting = UIHostingController(rootView: view)
                vc = UINavigationController(rootViewController: hosting)

                hosting.navigationItem.largeTitleDisplayMode = .never
                hosting.navigationController?.navigationBar.prefersLargeTitles = false

            case .navigationBarLargeTitle:
                let hosting = UIHostingController(rootView: view)
                vc = UINavigationController(rootViewController: hosting)

                hosting.navigationItem.largeTitleDisplayMode = .always
                hosting.navigationController?.navigationBar.prefersLargeTitles = true

            default:
                vc = UIHostingController(rootView: view)
            }

            validateOrRecord(
                for: vc,
                config: deviceSize,
                precision: precision,
                perceptualPrecision: perceptualPrecision,
                png: png,
                renderingMode: renderingMode,
                interfaceStyle: interfaceStyle,
                file: file,
                testName: testName + "_" + deviceSize.name,
                line: line
            )
        }
    }

    public func snapshot<V: View>(
        for component: V,
        size: CGSize,
        renderingMode: RenderingMode = .snapshot(afterScreenUpdates: true),
        precision: Float = 0.99,
        perceptualPrecision: Float = 0.98,
        png: Bool = false,
        colorScheme: ColorScheme = .light,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        snapshot(
            for: component,
            sizes: [size],
            renderingMode: renderingMode,
            precision: precision,
            perceptualPrecision: perceptualPrecision,
            png: png,
            colorScheme: colorScheme,
            file: file,
            testName: testName,
            line: line
        )
    }

    public func snapshot<V: View>(
        for component: V,
        sizes: [CGSize],
        renderingMode: RenderingMode = .drawHierarchy(afterScreenUpdates: true),
        precision: Float = 0.99,
        perceptualPrecision: Float = 0.98,
        png: Bool = false,
        colorScheme: ColorScheme = .light,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
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

        sizes.forEach { size in
            validateOrRecord(
                for: view,
                size: size,
                precision: precision,
                perceptualPrecision: perceptualPrecision,
                png: png,
                renderingMode: renderingMode,
                interfaceStyle: interfaceStyle,
                file: file,
                testName: testName + "_\(size.width)x\(size.height)",
                line: line
            )
        }
    }

    public func snapshotSizeThatFits<V: View>(
        for component: V,
        renderingMode: RenderingMode = .drawHierarchy(afterScreenUpdates: true),
        precision: Float = 0.99,
        perceptualPrecision: Float = 0.98,
        png: Bool = false,
        colorScheme: ColorScheme = .light,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
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

        validateOrRecordSizeThatFits(
            for: view,
            precision: precision,
            perceptualPrecision: perceptualPrecision,
            png: png,
            renderingMode: renderingMode,
            interfaceStyle: interfaceStyle,
            file: file,
            testName: testName,
            line: line
        )
    }

    private func validateOrRecord(
        for component: UIViewController,
        config: ViewImageConfig,
        precision: Float,
        perceptualPrecision: Float,
        png: Bool,
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
                perceptualPrecision: perceptualPrecision,
                png: png,
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

    private func validateOrRecord<V: View>(
        for component: V,
        size: CGSize,
        precision: Float,
        perceptualPrecision: Float,
        png: Bool,
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
                renderingMode: renderingMode,
                precision: precision,
                perceptualPrecision: perceptualPrecision,
                png: png,
                layout: .fixed(width: size.width, height: size.height),
                traits: UITraitCollection(displayScale: 2),
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

    private func validateOrRecordSizeThatFits<V: View>(
        for component: V,
        precision: Float,
        perceptualPrecision: Float,
        png: Bool,
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
                renderingMode: renderingMode,
                precision: precision,
                perceptualPrecision: perceptualPrecision,
                png: png,
                layout: .sizeThatFits,
                traits: UITraitCollection(displayScale: 2),
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
