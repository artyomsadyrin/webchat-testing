//
//  OpenWebPageError.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 10.06.21.
//

import Foundation

enum OpenWebPageError {
    case wrongURL
    case httpsInURLMissing
    case emptyHandlerName
    case incorrectTextFieldsSetup
    case localPageNotFound
}
