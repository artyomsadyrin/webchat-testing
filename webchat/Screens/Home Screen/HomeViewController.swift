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
        contentView.openWebPageButtonTitle = "Open Web Page"
    }
}

private extension HomeViewController {
    func enterWebPageConfigValues() {
        let alert = UIAlertController(title: "Enter web page config", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "https://google.com"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Enter JS handler name"
        }
        
        alert.addAction(UIAlertAction(title: "Open web page", style: .default, handler: { [weak self] _ in
            let urlTextField = alert.textFields![0]
            let handlerTextField = alert.textFields![1]
            
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
                self?.showErrorAlert(error: .wrongHandlerName)
                return
            }
            
            self?.transitions.openWebPage?(WebPageConfig(url: url, handlerName: handlerName))
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(error: OpenWebPageErrors) {
        let alert = UIAlertController(title: "Open Web Page Failed", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

private enum OpenWebPageErrors: Error {
    case wrongURL
    case httpsInURLMissing
    case wrongHandlerName
}

extension OpenWebPageErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .httpsInURLMissing:
            return NSLocalizedString("https in URL is missing", comment: "")
        case .wrongURL:
            return NSLocalizedString("Wrong URL", comment: "")
        case .wrongHandlerName:
            return NSLocalizedString("Empty handler name", comment: "")
        }
    }
}
