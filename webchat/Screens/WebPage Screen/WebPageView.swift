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
        return button
    }()
    
    private let webViewTopBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.Colors.border.color
        return view
    }()
    
    private var webView: WKWebView!

    var closeButtonAction: (() -> Void)?
    var closeButtonTitle: String? {
        get { closeButton.title(for: .normal) }
        set { closeButton.setTitle(newValue, for: .normal) }
    }
    
    func arrangeSubviews() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
            $0.width.equalTo(60)
        }
        
        addSubview(webViewTopBorder)
        webViewTopBorder.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(webViewTopBorder.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupSubviews() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        backgroundColor = Assets.Colors.webPageTopBar.color
    }
    
    func setWebView(_ webView: WKWebView) {
        self.webView = webView
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
