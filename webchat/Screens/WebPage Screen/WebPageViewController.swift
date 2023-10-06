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
    
    var transitions = Transitions()
    
    private let webPageConfig: WebPageConfig
        
    init(config: WebPageConfig) {
        self.webPageConfig = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WebPageView(webView: makeWebView())
    }
    
    override func setupData() {
        super.setupData()
        
        setupLoadingBarButton()

        contentView.setupWebView { [weak self] webView in
            guard let self else { return }
            
            webView.navigationDelegate = self
            webView.uiDelegate = self
        }
        
        load(url: webPageConfig.url)
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

extension WebPageViewController: WKUIDelegate {
    func webViewDidClose(_ webView: WKWebView) {
        transitions.close?()
    }
}

private extension WebPageViewController {
    func load(url: URL) {
        contentView.setupProgressView(isHidden: false, progress: 0)
        contentView.load(url: url)
    }
    
    func setupLoadingBarButton() {
        navigationItem.rightBarButtonItem = contentView.refreshButton
        
        contentView.didProgressChange = { [weak self] progress in
            guard let self else { return }
            
            let isFinished = progress >= 1
            
            if isFinished {
                self.navigationItem.rightBarButtonItem = self.contentView.refreshButton
            } else {
                let stopLoadingButton = self.contentView.stopLoadingButton
                
                guard self.navigationItem.rightBarButtonItem != stopLoadingButton else { return }
                
                self.navigationItem.rightBarButtonItem = stopLoadingButton
            }
            
            self.contentView.setupProgressView(isHidden: isFinished, progress: progress)
        }
    }
    
    func showAlert(message: WKScriptMessage) {
        let alertMessage = (message.body as? [String: String])?.reduce(into: String()) {
            if !$0.isEmpty {
                $0 += "\n"
            }
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
