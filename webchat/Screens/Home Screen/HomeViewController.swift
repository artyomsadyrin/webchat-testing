//
//  HomeViewController.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import UIKit

struct WebPageConfig {
    let url: URL
    let handlerName: String
    let jsScript: String?
}

final class HomeViewController: ContentViewController<HomeView> {
    
    struct Transitions {
        var openWebPage: ((WebPageConfig) -> Void)?
    }
    
    var transitions = Transitions()
    
    override func setupData() {
        contentView.openWebPageAction = { [weak self] in
            self?.enterWebPageConfigValues()
        }
        contentView.openWebPageButtonTitle = L10n.Home.Button.openWebPage
    }
}

private extension HomeViewController {
    func enterWebPageConfigValues() {
        let alert = UIAlertController(title: L10n.Home.Alert.EnterWebPageData.title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = L10n.Home.Alert.EnterWebPageData.Placeholder.url
        }
        
        alert.addTextField { textField in
            textField.placeholder = L10n.Home.Alert.EnterWebPageData.Placeholder.handlerName
        }
        alert.addTextField { textField in
            textField.placeholder = L10n.Home.Alert.EnterWebPageData.Placeholder.injectedScript
        }
        
        alert.addAction(UIAlertAction(title: L10n.Home.Button.openWebPage, style: .default, handler: { [weak self] _ in
            let urlTextField = alert.textFields![0]
            let handlerTextField = alert.textFields![1]
            let injectedScriptTextField = alert.textFields![2]
            
            guard urlTextField.text?.contains("https://") == true else {
                self?.showErrorAlert(error: .httpsInURLMissing)
                return
            }
            
            guard let url = URL(string: urlTextField.text ?? "") else {
                self?.showErrorAlert(error: .wrongURL)
                return
            }
            
            guard let handlerName = handlerTextField.text,
                  !handlerName.isEmpty else {
                self?.showErrorAlert(error: .emptyHandlerName)
                return
            }
            
            self?.transitions.openWebPage?(WebPageConfig(url: url,
                                                         handlerName: handlerName,
                                                         jsScript: injectedScriptTextField.text))
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(error: OpenWebPageErrors) {
        let alert = UIAlertController(title: L10n.Error.OpenWebPage.title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Alert.Action.ok, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

private enum OpenWebPageErrors: Error {
    case wrongURL
    case httpsInURLMissing
    case emptyHandlerName
}

extension OpenWebPageErrors: LocalizedError {
    private typealias Texts = L10n.Error.OpenWebPage.Message
    
    var errorDescription: String? {
        switch self {
        case .httpsInURLMissing:
            return NSLocalizedString(Texts.httpsMissing, comment: "")
        case .wrongURL:
            return NSLocalizedString(Texts.wrongUrl, comment: "")
        case .emptyHandlerName:
            return NSLocalizedString(Texts.emptyHandlerName, comment: "")
        }
    }
}
