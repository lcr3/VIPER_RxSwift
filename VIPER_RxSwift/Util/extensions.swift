//
//  extensions.swift
//  VIPER_RxSwift
//
//  Created by lcr on 2021/03/09.
//  
//

import Foundation

import Foundation
import UIKit

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

// クラス名取得
extension NSObject: ClassNameProtocol {}
public extension ClassNameProtocol {
    static var className: String {
        String(describing: self)
    }

    var className: String {
        Self.className
    }
}

// StoryBoardからControllerを取得する
public enum StoryboardInstantiateType {
    case initial
    case identifier(String)
}

public protocol StoryboardInstantiatable {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle { get }
    static var instantiateType: StoryboardInstantiateType { get }
}

public extension StoryboardInstantiatable where Self: NSObject {
    static var storyboardName: String {
        className
    }

    static var storyboardBundle: Bundle {
        Bundle(for: self)
    }

    private static var storyboard: UIStoryboard {
        UIStoryboard(name: storyboardName, bundle: storyboardBundle)
    }

    static var instantiateType: StoryboardInstantiateType {
        .identifier(className)
    }
}

public extension StoryboardInstantiatable where Self: UIViewController {
    static func instantiate() -> Self {
        switch instantiateType {
        case .initial:
            // swiftlint:disable:next force_cast
            return storyboard.instantiateInitialViewController() as! Self
        case .identifier(let identifier):
            // swiftlint:disable:next force_cast
            return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        }
    }
}
