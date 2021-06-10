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
    
    private let webViewTopBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.Colors.border.color
        return view
    }()
    
    private var webView: WKWebView!

    var closeButtonAction: (() -> Void)?
    
    func arrangeSubviews() {
        addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setWebView(_ webView: WKWebView) {
        self.webView = webView
    }
    
    func configureWebView(getWebView: (WKWebView) -> Void) {
        getWebView(webView)
    }
    
    func setupSubviews() {
        backgroundColor = Assets.Colors.webPageTopBar.color
    }
}

private extension WebPageView {
    @objc func closeButtonTapped() {
        closeButtonAction?()
    }
}
