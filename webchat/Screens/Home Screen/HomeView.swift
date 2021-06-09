//
//  HomeView.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import SnapKit
import UIKit

final class HomeView: UIView, ContentView {
    
    private let openWebPageButton = makeActionButton()
    private let openLocalPageButton = makeActionButton()
    
    var openWebPageAction: (() -> Void)?
    var openWebPageButtonTitle: String? {
        didSet {
            openWebPageButton.setTitle(openWebPageButtonTitle, for: .normal)
        }
    }
    
    var openLocalPageAction: (() -> Void)?
    var openLocalPageButtonTitle: String? {
        get { openLocalPageButton.title(for: .normal) }
        set { openLocalPageButton.setTitle(newValue, for: .normal) }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [openWebPageButton, openLocalPageButton].forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
        }
    }
    
    func arrangeSubviews() {
        let buttonContainer = UIView()
        addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        let actionButtonHeight: CGFloat = 60
        
        buttonContainer.addSubview(openLocalPageButton)
        openLocalPageButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(actionButtonHeight)
        }
        
        buttonContainer.addSubview(openWebPageButton)
        openWebPageButton.snp.makeConstraints {
            $0.top.equalTo(openLocalPageButton.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(actionButtonHeight)
        }
    }
    
    func setupSubviews() {
        openWebPageButton.addTarget(self, action: #selector(openWebPageButtonTapped), for: .touchUpInside)
        openLocalPageButton.addTarget(self, action: #selector(openLocalPageButtonTapped), for: .touchUpInside)

        backgroundColor = .white
    }
}

private extension HomeView {
    @objc func openWebPageButtonTapped() {
        openWebPageAction?()
    }
    
    @objc func openLocalPageButtonTapped() {
        openLocalPageAction?()
    }
    
    static func makeActionButton() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(Assets.Colors.white.color, for: .normal)
        button.backgroundColor = Assets.Colors.buttonBackground.color
        return button
    }
}
