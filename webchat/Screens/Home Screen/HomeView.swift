//
//  HomeView.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import SnapKit
import UIKit

final class HomeView: UIView, ContentView {
    
    private let openWebPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .groupTableViewBackground
        return button
    }()
    
    var openWebPageAction: (() -> Void)?
    var openWebPageButtonTitle: String? {
        didSet {
            openWebPageButton.setTitle(openWebPageButtonTitle, for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        openWebPageButton.layer.cornerRadius = openWebPageButton.bounds.height / 2
    }
    
    func arrangeSubviews() {
        addSubview(openWebPageButton)
        openWebPageButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(60)
        }
    }
    
    func setupSubviews() {
        openWebPageButton.addTarget(self, action: #selector(openWebPageButtonTapped), for: .touchUpInside)
        backgroundColor = .white
    }
}

private extension HomeView {
    @objc func openWebPageButtonTapped() {
        openWebPageAction?()
    }
}
