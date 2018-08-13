//
//  WebViewController.swift
//  Q3
//
//  Created by Anthony on 23/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    let closeBtn: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didPressCloseBtn), for: .touchUpInside)
        btn.setTitle(Constants.BtnTitles.closeBtn, for: .normal)
        btn.setTitleColor(UIColor(hex: Constants.Colors.gumtreeRed), for: .normal)
        btn.backgroundColor = .white
        return btn
    }()
    
    func didPressCloseBtn() {
        dismiss(animated: true, completion: nil)
    }
    
    let progressView: UIProgressView = {
       let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor(hex: Constants.Colors.gumtreeRed)
        return progressView
    }()
    
    let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.Keys.kEstimatedProgress {
            progressView.progress = Float(webView.estimatedProgress)
            if progressView.progress == 1.0 {
                progressView.removeFromSuperview()
            }
        }
    }
    
    var url: URL?

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = url {
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            webView.load(URLRequest(url: url))
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: Constants.Keys.kEstimatedProgress)
    }
    
    func setUpLayout() {
        title = ""

        view.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(closeBtn)
        closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        closeBtn.topAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        closeBtn.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(progressView)
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: closeBtn.topAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 5).isActive = true

    }
}
