//
//  ViewController.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import UIKit
import WebKit

class WebPageViewController: ContentViewController<WebPageView> {
    
    private let webPageConfig: WebPageConfig
    
    private var observation: NSKeyValueObservation?
    
    init(config: WebPageConfig) {
        self.webPageConfig = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        observation = nil
    }
    
    override func loadView() {
        super.loadView()
        
        contentView.webView = makeWebView()
    }
    
    override func setupData() {
        super.setupData()
        
        contentView.webView.load(URLRequest(url: webPageConfig.url))
        contentView.webView.navigationDelegate = self
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: contentView.webView, action: #selector(contentView.webView.reload))
        self.navigationItem.rightBarButtonItem = refresh
        
        observation = contentView.webView.observe(
            \WKWebView.estimatedProgress,
            options: .new) { [weak self] _, change in
            if let newValue = change.newValue {
                self?.contentView.progressView.progress = Float(newValue)
            }
        }
    }
}

extension WebPageViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        showAlert(message: message)
    }
}

extension WebPageViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.url?.host
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
        present(alert, animated: true, completion: nil)
    }
    
    func makeWebView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let userController = WKUserContentController()
        
        userController.add(self, name: webPageConfig.handlerName)
        
        if let jsScript = webPageConfig.jsScript {
            let userScript = WKUserScript(source: jsScript,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: false)
        
            userController.addUserScript(userScript)
        }
        
        configuration.userContentController = userController
        
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.allowsBackForwardNavigationGestures = true
        return view
    }
}
