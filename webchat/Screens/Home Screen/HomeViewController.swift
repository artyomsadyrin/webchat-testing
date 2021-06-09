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
        contentView.openLocalPageAction = { [weak self] in
            self?.openLocalPage()
        }
        contentView.openWebPageButtonTitle = L10n.Home.Button.openWebPage
        contentView.openLocalPageButtonTitle = L10n.Home.Button.openLocalPage
    }
}

private extension HomeViewController {
    func enterWebPageConfigValues() {
        let alert = UIAlertController(title: L10n.Home.Alert.EnterWebPageData.title, message: nil, preferredStyle: .alert)
        let textFieldsPlaceholder = [L10n.Home.Alert.EnterWebPageData.Placeholder.url,
                                     L10n.Home.Alert.EnterWebPageData.Placeholder.handlerName,
                                     L10n.Home.Alert.EnterWebPageData.Placeholder.injectedScript]
        
        textFieldsPlaceholder.forEach { placeholder in
            alert.addTextField { textField in
                textField.placeholder = placeholder
            }
        }
        
        alert.addAction(UIAlertAction(title: L10n.Home.Alert.EnterWebPageData.Action.open, style: .default, handler: { [weak self] _ in
            guard let textFields = alert.textFields,
                  textFields.count >= textFieldsPlaceholder.count else {
                self?.showErrorAlert(error: Errors.incorrectTextFieldsSetup)
                return
            }
            
            let urlTextField = alert.textFields![0]
            let handlerTextField = alert.textFields![1]
            let injectedScriptTextField = alert.textFields![2]
            
            guard urlTextField.text?.contains(Constants.httpsPrefix) == true else {
                self?.showErrorAlert(error: Errors.httpsInURLMissing)
                return
            }
            
            guard let url = URL(string: urlTextField.text ?? "") else {
                self?.showErrorAlert(error: Errors.wrongURL)
                return
            }
            
            guard let handlerName = handlerTextField.text,
                  !handlerName.isEmpty else {
                self?.showErrorAlert(error: Errors.emptyHandlerName)
                return
            }
            
            self?.transitions.openWebPage?(WebPageConfig(url: url,
                                                         handlerName: handlerName,
                                                         jsScript: injectedScriptTextField.text))
        }))
        
        alert.addAction(UIAlertAction(title: L10n.Alert.Action.cancel,
                                      style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
    
    func openLocalPage() {
        guard let url = Bundle.main.url(forResource: "index", withExtension: "html") else {
            showErrorAlert(error: Errors.localPageNotFound)
            return
        }
        
        transitions.openWebPage?(WebPageConfig(url: url,
                                               handlerName: "onChatEvent",
                                               jsScript: nil))
    }
}

private extension HomeViewController {
    enum Constants {
        static let httpsPrefix = "https://"
    }
}
