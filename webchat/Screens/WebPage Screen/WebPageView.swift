//
//  HomeView.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import SnapKit
import UIKit
import WebKit

final class WebPageView: UIView, ContentView {
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        return button
    }()
    
    private let webView = WKWebView()

    var closeButtonAction: (() -> Void)?
    
    func arrangeSubviews() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(44)
        }
        
        addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupSubviews() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        backgroundColor = .lightGray
    }
    
    func registerDelegatesForWebView(getWebView: (WKWebView) -> Void) {
        getWebView(webView)
    }
    
    func setupURLForWebView(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
}

private extension WebPageView {
    @objc func closeButtonTapped() {
        closeButtonAction?()
    }
}
