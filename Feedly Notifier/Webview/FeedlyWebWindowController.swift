//
//  FeedlyWebWindowController.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 20 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Cocoa
import WebKit
import Foundation

class FeedlyWebWindowController: NSWindowController, WKUIDelegate, WKNavigationDelegate {
    
    let url = URL(string: Constants.FEEDLY_HOST + Constants.AUTH_URL)!
    var webView: WKWebView!
    var newWebviewPopupWindow: WKWebView?
    var authCode: String?
    
    
    override var windowNibName: String {
        return "FeedlyWebWindow"
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let request = URLRequest(url: self.url)
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preferences
        //self.webView = WKWebView(frame: .infinite, configuration: webConfiguration)
        print(self.window?.frame.minX)
        self.webView = WKWebView(frame: CGRect(x: (CGFloat(0)), y: (CGFloat(0)), width: (self.window?.frame.width)!, height: (self.window?.frame.height)!), configuration: webConfiguration)
        self.window?.contentView?.addSubview(self.webView)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.load(request)
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print("Webview closed")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("navigation from the main frame has started")
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        newWebviewPopupWindow =  WKWebView(frame: CGRect(x: (CGFloat(0)), y: (CGFloat(0)), width: (self.window?.frame.width)!, height: (self.window?.frame.height)!), configuration: configuration)
        newWebviewPopupWindow!.navigationDelegate = self
        newWebviewPopupWindow!.uiDelegate = self
        self.window?.contentView?.addSubview(newWebviewPopupWindow!)
        return newWebviewPopupWindow!
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("web view received a server redirect for a request")
        print(webView.url?.absoluteString)
        if ((webView.url?.absoluteString.hasPrefix(Constants.CODE_URL))!) {
            let queryItems = URLComponents(string: webView.url!.absoluteString)?.queryItems
            let code = queryItems?.filter({$0.name == "code"}).first
            print(code?.value!)
            self.authCode = (code?.value)!
            getAuthToken()
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("web view has started to receive content for the main frame")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("navigation is complete")
    }
    
    func getAuthToken() {
        // prepare json data
        // ?client_id=sandbox&client_secret=" + API_KEY + "&redirect_uri=http://localhost&grant_type=authorization_code&code=
        let json: [String: Any] = [
            "client_id": Constants.CLIENT_ID,
            "client_secret": Constants.API_KEY,
            "redirect_uri" : Constants.REDIRECT_URI,
            "grant_type": "authorization_code",
            "code": self.authCode
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print(jsonData)
        // create post request
        let url = URL(string: Constants.FEEDLY_HOST + Constants.TOKEN_AUTH_URL)!
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                print(tokenResponse)
                DefaultsUtil.defaults().save(key: DefaultKeys.ACCESS_TOKEN, value: tokenResponse.access_token)
                DefaultsUtil.defaults().save(key: DefaultKeys.REFRESH_TOKEN, value: tokenResponse.refresh_token)
              
                // close the webview
                DispatchQueue.main.async {
                    self.window?.close()
                }
            }
            catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        task.resume()
    }
    
}
