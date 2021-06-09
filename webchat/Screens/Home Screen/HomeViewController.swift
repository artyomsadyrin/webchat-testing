//
//  HomeViewController.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import UIKit

final class HomeViewController: ContentViewController<HomeView> {
    
    struct Transitions {
        var openWebPage: ((WebPageConfig) -> Void)?
    }
    
    var transitions = Transitions()
    
    enum Errors {
        case wrongURL
        case httpsInURLMissing
        case emptyHandlerName
        case incorrectTextFieldsSetup
        case localPageNotFound
    }
    
    override func setupData() {
        contentView.openRemotePageButtonAction = { [weak self] in
            self?.openRemotePage()
        }
        contentView.openLocalPageButtonAction = { [weak self] in
            self?.openLocalPage()
        }
        contentView.openRemotePageButtonTitle = L10n.Home.Button.openRemotePage
        contentView.openLocalPageButtonTitle = L10n.Home.Button.openLocalPage
    }
}

private extension HomeViewController {
    func openRemotePage() {
        typealias Texts = L10n.Home.Alert.RemotePageData
        
        let alert = UIAlertController(title: Texts.title, message: nil, preferredStyle: .alert)
        let textFieldsPlaceholder = [Texts.Placeholder.url,
                                     Texts.Placeholder.handlerName,
                                     Texts.Placeholder.injectedScript]
        
        textFieldsPlaceholder.forEach { placeholder in
            alert.addTextField { textField in
                textField.placeholder = placeholder
            }
        }
        
        alert.addAction(UIAlertAction(title: Texts.Action.open, style: .default, handler: { [weak self] _ in
            guard let textFields = alert.textFields,
                  textFields.count >= textFieldsPlaceholder.count else {
                self?.showErrorAlert(error: Errors.incorrectTextFieldsSetup)
                return
            }
            
            let urlTextField = textFields[0]
            let handlerNameTextField = textFields[1]
            let injectedScriptTextField = textFields[2]
            
            guard urlTextField.text?.contains(Constants.httpsPrefix) == true else {
                self?.showErrorAlert(error: Errors.httpsInURLMissing)
                return
            }
            
            guard let url = URL(string: urlTextField.text ?? "") else {
                self?.showErrorAlert(error: Errors.wrongURL)
                return
            }
            
            guard let handlerName = handlerNameTextField.text,
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
        guard let url = Bundle.main.url(forResource: Constants.localPage.name,
                                        withExtension: Constants.localPage.extension) else {
            showErrorAlert(error: Errors.localPageNotFound)
            return
        }
        
        transitions.openWebPage?(WebPageConfig(url: url,
                                               handlerName: Constants.localPageHandlerName,
                                               jsScript: nil))
    }
}

private extension HomeViewController {
    enum Constants {
        static let httpsPrefix = "https://"
        static let localPage: (name: String, extension: String) = ("index", "html")
        static let localPageHandlerName = "onChatEvent"
    }
}
