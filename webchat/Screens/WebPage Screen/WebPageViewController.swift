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
    
    var transitions = Transitions()
    
    init(config: WebPageConfig) {
        self.webPageConfig = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        contentView.setWebView(makeWebView())
    }
    
    override func setupData() {
        super.setupData()
        
        contentView.setupURLForWebView(webPageConfig.url)
        
        contentView.closeButtonAction = transitions.close
        contentView.closeButtonTitle = L10n.Alert.Action.close
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
        
        let alert = UIAlertController(title: L10n.WebPage.Alert.MessageReceived.title(message.name),
                                      message: alertMessage ?? "null",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Alert.Action.ok, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeWebView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let userController = WKUserContentController()
        
        userController.add(self, name: webPageConfig.handlerName)
        
        let userScript = WKUserScript(source: webPageConfig.jsScript,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: false)
        
        userController.addUserScript(userScript)
        configuration.userContentController = userController
        
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.allowsBackForwardNavigationGestures = true
        return view
    }
}

