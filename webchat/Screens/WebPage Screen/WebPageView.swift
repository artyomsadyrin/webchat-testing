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
    
    let closeButton = UIBarButtonItem(title: L10n.Alert.Action.done,
                                      style: .done,
                                      target: self,
                                      action: #selector(closeButtonTapped))
    
    private let webViewTopBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.Colors.border.color
        return view
    }()
    
    var webView: WKWebView!

    var closeButtonAction: (() -> Void)?
    
    func arrangeSubviews() {
        addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
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
