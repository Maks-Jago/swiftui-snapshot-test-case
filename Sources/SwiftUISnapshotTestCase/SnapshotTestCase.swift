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
        subpixelThreshold: UInt8 = 0,
        png: Bool = false,
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

//            let size = deviceSize.size ?? .zero
//            let safeArea = deviceSize.safeArea

            var vc: UIViewController!

            switch deviceSize.options {
            case .navigationBarInline:
//                let hosting = UIHostingController(rootView: view.navigationBarTitleDisplayMode(.inline))

                let hosting = UIHostingController(rootView: view)//, insets: deviceSize.safeArea)

//                let container = UIViewController()
//                container.view.translatesAutoresizingMaskIntoConstraints = false
//                container.addChild(hosting)
//                container.view.frame = CGRect(origin: CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>), size: <#T##CGSize#>)


//                vc = SnapshotNavigationController(
//                    rootViewController: hosting,
//                    insets: deviceSize.safeArea
//                )
//                container.view.addSubview(hosting.view)
//                hosting.didMove(toParent: container)

//                vc = UINavigationController(rootViewController: hosting)
                vc = SnapshotNavigationController(rootViewController: hosting, insets: deviceSize.safeArea)


//                hosting.view?.frame = CGRect(
//                    origin: CGPoint(x: safeArea.left, y: safeArea.top),
//                    size: CGSize(
//                        width: size.width - (safeArea.left + safeArea.right),
//                        height: size.height - (safeArea.top + safeArea.bottom)
//                    )
//                )

//                container.navigationItem.title = hosting.navigationItem.title
//                container.navigationItem.leftBarButtonItems = hosting.navigationItem.leftBarButtonItems
//                container.navigationItem.rightBarButtonItems = hosting.navigationItem.rightBarButtonItems

                hosting.navigationItem.largeTitleDisplayMode = .never
                hosting.navigationController?.navigationBar.prefersLargeTitles = false

            case .navigationBarLargeTitle:
                let hosting = UIHostingController(rootView: view)

//                let container = UIViewController()
//                container.view.translatesAutoresizingMaskIntoConstraints = false
//                container.addChild(hosting)
//
//                container.view.addSubview(hosting.view)
//                hosting.didMove(toParent: container)

//                vc = SnapshotNavigationController(
//                    rootViewController: hosting,
//                    insets: deviceSize.safeArea
//                )

                vc = SnapshotNavigationController(rootViewController: hosting, insets: deviceSize.safeArea)

//                hosting.view?.frame = CGRect(
//                    origin: CGPoint(x: safeArea.left, y: safeArea.top),
//                    size: CGSize(
//                        width: size.width - (safeArea.left + safeArea.right),
//                        height: size.height - (safeArea.top + safeArea.bottom)
//                    )
//                )

//                container.navigationItem.title = hosting.navigationItem.title
//                container.navigationItem.leftBarButtonItems = hosting.navigationItem.leftBarButtonItems
//                container.navigationItem.rightBarButtonItems = hosting.navigationItem.rightBarButtonItems

                hosting.navigationItem.largeTitleDisplayMode = .always
                hosting.navigationController?.navigationBar.prefersLargeTitles = true

            default:
                vc = SnapshotHostingController(rootView: view, insets: deviceSize.safeArea)
//                vc.view?.frame = CGRect(
//                    origin: CGPoint(x: safeArea.left, y: safeArea.top),
//                    size: CGSize(
//                        width: size.width - (safeArea.left + safeArea.right),
//                        height: size.height - (safeArea.top + safeArea.bottom)
//                    )
//                )
            }

            validateOrRecord(
                for: vc,
                config: deviceSize,
                precision: precision,
                subpixelThreshold: subpixelThreshold,
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
        precision: Float = 1,
        subpixelThreshold: UInt8,
        png: Bool = false,
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

        validateOrRecord(
            for: view,
            size: size,
            precision: precision,
            subpixelThreshold: subpixelThreshold,
            png: png,
            renderingMode: renderingMode,
            interfaceStyle: interfaceStyle,
            file: file,
            testName: testName + "_\(size)",
            line: line
        )
    }

    private func validateOrRecord(
        for component: UIViewController,
        config: ViewImageConfig,
        precision: Float,
        subpixelThreshold: UInt8,
        png: Bool,
        renderingMode: RenderingMode,
        interfaceStyle: UIUserInterfaceStyle,
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        let bundlePath = Bundle(for: type(of: self)).bundlePath
//        assertSnapshot(
//            matching: component,
//            as: .image(
//                on: config,
//                renderingMode: renderingMode,
//                precision: precision,
//                subpixelThreshold: subpixelThreshold,
//                png: png,
//                traits: config.traits,
//                interfaceStyle: interfaceStyle
//            ),
//            record: self.isRecording,
//            snapshotDirectory: bundlePath,
//            addAttachment: { self.add($0) },
//            file: file,
//            testName: testName,
//            line: line
//        )
        assertSnapshot(
            matching: component,
            as: .wait(
                for: 0.34,
                on: .image(
                    on: config,
                    renderingMode: renderingMode,
                    precision: precision,
                    subpixelThreshold: subpixelThreshold,
                    png: png,
                    traits: config.traits,
                    interfaceStyle: interfaceStyle
                )
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
        subpixelThreshold: UInt8,
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
                subpixelThreshold: subpixelThreshold,
                png: png,
                layout: .fixed(width: size.width, height: size.height),
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
