//
//  ViewController.swift
//  NYTimesArticles
//
//  Created by Burhanuddin Sunelwala on 17/12/20.
//

import UIKit
import WebKit
import MBProgressHUD

class WebViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!

    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        guard let url = url else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
        webView.load(URLRequest(url: url))
    }
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressHUD.hide(for: view, animated: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}

