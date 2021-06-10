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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: L10n.Alert.Action.done, style: .done, target: nil, action: nil)
    }
    
    override func setupData() {
        title = L10n.Common.appName
        
        contentView.openRemotePageButtonAction = { [weak self] in
            self?.enterConfigValuesAndOpenRemotePage()
        }
        contentView.openLocalPageButtonAction = { [weak self] in
            self?.openLocalPage()
        }
        contentView.openRemotePageButtonTitle = L10n.Home.Button.openRemotePage
        contentView.openLocalPageButtonTitle = L10n.Home.Button.openLocalPage
    }
}

private extension HomeViewController {
    func enterConfigValuesAndOpenRemotePage() {
        typealias Texts = L10n.Home.Alert.RemotePageData
        
        let alertController = UIAlertController(title: Texts.title, message: nil, preferredStyle: .alert)
        let textFieldsPlaceholders = [Texts.Placeholder.url,
                                      Texts.Placeholder.handlerName,
                                      Texts.Placeholder.injectedScript]
        
        textFieldsPlaceholders.forEach { placeholder in
            alertController.addTextField { textField in
                textField.placeholder = placeholder
            }
        }
        
        alertController.addAction(UIAlertAction(title: Texts.Action.open, style: .default, handler: { [weak self] _ in
            guard let textFields = alertController.textFields,
                  textFields.count >= textFieldsPlaceholders.count else {
                self?.showErrorAlert(error: OpenWebPageError.incorrectTextFieldsSetup)
                return
            }
            
            let urlTextField = textFields[0]
            let handlerNameTextField = textFields[1]
            let injectedScriptTextField = textFields[2]
            
            guard urlTextField.text?.contains(Constants.httpsPrefix) == true else {
                self?.showErrorAlert(error: OpenWebPageError.httpsInURLMissing)
                return
            }
            
            guard let url = URL(string: urlTextField.text ?? "") else {
                self?.showErrorAlert(error: OpenWebPageError.wrongURL)
                return
            }
            
            guard let handlerName = handlerNameTextField.text,
                  !handlerName.isEmpty else {
                self?.showErrorAlert(error: OpenWebPageError.emptyHandlerName)
                return
            }
            
            self?.transitions.openWebPage?(WebPageConfig(url: url,
                                                         handlerName: handlerName,
                                                         jsScript: injectedScriptTextField.text))
        }))
        
        alertController.addAction(UIAlertAction(title: L10n.Alert.Action.cancel,
                                      style: .cancel))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openLocalPage() {
        guard let url = Bundle.main.url(forResource: Constants.localPage.name,
                                        withExtension: Constants.localPage.extension) else {
            showErrorAlert(error: OpenWebPageError.localPageNotFound)
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
