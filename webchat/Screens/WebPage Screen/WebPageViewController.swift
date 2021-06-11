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
    
    private var progressObservation: NSKeyValueObservation?
    
    init(config: WebPageConfig) {
        self.webPageConfig = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        progressObservation = nil
    }
    
    override func loadView() {
        super.loadView()
        
        contentView.webView = makeWebView()
    }
    
    override func setupData() {
        super.setupData()
        
        contentView.webView.load(URLRequest(url: webPageConfig.url))
        contentView.webView.navigationDelegate = self
        contentView.webView.uiDelegate = self
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: contentView.webView, action: #selector(contentView.webView.reload))
        let stopLoadingButton = UIBarButtonItem(barButtonSystemItem: .stop, target: contentView.webView, action: #selector(contentView.webView.stopLoading))
        
        navigationItem.rightBarButtonItem = refreshButton
        
        progressObservation = contentView.webView.observe(
            \WKWebView.estimatedProgress,
            options: .new) { [weak self] _, change in
            
            if let newValue = change.newValue {
                let progress = Float(newValue)
                let finished = progress == 1
                DispatchQueue.main.async {
                    if finished {
                        if !(self?.navigationItem.rightBarButtonItem == refreshButton) {
                            self?.navigationItem.rightBarButtonItem = refreshButton
                        }
                    } else {
                        if !(self?.navigationItem.rightBarButtonItem == stopLoadingButton) {
                            self?.navigationItem.rightBarButtonItem = stopLoadingButton
                        }
                    }
                    
                    self?.contentView.progressView.isHidden = finished
                }
                self?.contentView.progressView.progress = progress
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

extension WebPageViewController: WKUIDelegate {
    func webViewDidClose(_ webView: WKWebView) {
        transitions.close?()
    }
}

private extension WebPageViewController {
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
