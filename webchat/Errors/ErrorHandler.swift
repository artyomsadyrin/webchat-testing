//
//  ErrorHandler.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 9.06.21.
//

import UIKit

protocol ErrorLocalizable {
    var title: String { get }
    var message: String? { get }
}

extension UIViewController {
    func showErrorAlert(error: ErrorLocalizable) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Alert.Action.ok, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
