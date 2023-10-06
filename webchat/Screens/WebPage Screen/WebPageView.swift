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
    
    private let webView: WKWebView

    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.sizeToFit()
        return view
    }()
    
    let stopLoadingButton: UIBarButtonItem
    let refreshButton: UIBarButtonItem

    private var progressObservation: NSKeyValueObservation?
    
    var closeButtonAction: (() -> Void)?
    var didProgressChange: ((Float) -> Void)?
    
    init(webView: WKWebView) {
        self.webView = webView
        
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        stopLoadingButton = UIBarButtonItem(barButtonSystemItem: .stop, target: webView, action: #selector(webView.stopLoading))
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        progressObservation = nil
    }
    
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
        
        progressObservation = webView.observe(
            \WKWebView.estimatedProgress,
             options: .new
        ) { [weak self] _, change in
            guard let newValue = change.newValue else { return }
            
            DispatchQueue.main.async {
                self?.didProgressChange?(Float(newValue))
            }
        }
    }
}

extension WebPageView {
    func load(url: URL) {
        webView.load(.init(url: url))
    }
    
    func setupWebView(_ setup: (WKWebView) -> Void) {
        setup(webView)
    }
    
    func setupProgressView(isHidden: Bool, progress: Float) {
        progressView.isHidden = isHidden
        progressView.progress = progress
    }
}

private extension WebPageView {
    @objc func closeButtonTapped() {
        closeButtonAction?()
    }
}
