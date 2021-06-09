//
//  ContentViewController.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 8.06.21.
//

import UIKit

open class ContentViewController<View: ContentView>: UIViewController {
    var contentView: View! { view as? View }
    
    open override func loadView() {
        super.loadView()
        
        view = View()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.arrangeSubviews()
        contentView.setupSubviews()
        setupData()
    }
    
    open func setupData() {
        // override in subclasses
    }
}

public protocol ContentView: UIView {
    func arrangeSubviews()
    func setupSubviews()
}
