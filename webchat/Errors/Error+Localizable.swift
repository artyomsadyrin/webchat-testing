//
//  Error+Localizable.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 9.06.21.
//

import Foundation

// MARK: - Home Screen

extension HomeViewController {
    enum Errors {
        case wrongURL
        case httpsInURLMissing
        case emptyHandlerName
        case incorrectTextFieldsSetup
        case localPageNotFound
    }
}

extension HomeViewController.Errors: ErrorLocalizable {
    private typealias Texts = L10n.Error.OpenWebPage.Message
    
    var title: String { L10n.Error.OpenWebPage.title }
    
    var message: String? {
        switch self {
        case .httpsInURLMissing:
            return NSLocalizedString(Texts.httpsMissing, comment: "")
        case .wrongURL:
            return NSLocalizedString(Texts.wrongUrl, comment: "")
        case .emptyHandlerName:
            return NSLocalizedString(Texts.emptyHandlerName, comment: "")
        case .incorrectTextFieldsSetup:
            return NSLocalizedString(L10n.Error.Message.unknown, comment: "")
        case .localPageNotFound:
            return Texts.localPageNotFound
        }
    }
}
