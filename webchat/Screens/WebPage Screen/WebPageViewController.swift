//
//  ViewController.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import UIKit
import WebKit

class WebPageViewController: ContentViewController<WebPageView> {
    
    struct Transitions {
        var close: (() -> Void)?
    }
    
    private let webPageConfig: WebPageConfig
    
    var webPageResponseToIOS: ((Bool) -> Void)?
    var transitions = Transitions()
    
    init(config: WebPageConfig) {
        self.webPageConfig = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupData() {
        super.setupData()
        
        title = "Web Page"
        
        contentView.registerDelegatesForWebView { [weak self] webView in
            guard let self = self else { return }
            webView.configuration.userContentController.add(self, name: self.webPageConfig.handlerName)
        }
        
        contentView.setupURLForWebView(webPageConfig.url)
        
        contentView.closeButtonAction = transitions.close
    }
}

extension WebPageViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        showAlert(message: message)
    }
}

private extension WebPageViewController {
    func showAlert(message: WKScriptMessage) {
        let alertMessage = (message.body as? [String: String])?.reduce(into: String()) {
            $0 += "\($1.key) - \($1.value)"
        }
        
        let alert = UIAlertController(title: "'\(message.name)' Received", message: alertMessage ?? "null", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

