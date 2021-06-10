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
    
    var webView: WKWebView!

    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.sizeToFit()
        return view
    }()
    
    var closeButtonAction: (() -> Void)?
    
    func arrangeSubviews() {
        addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
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
