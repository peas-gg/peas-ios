//
//  WebView.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-09-07.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
	var url: URL
	
	@Binding var isLoading: Bool
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func makeUIView(context: Context) -> WKWebView {
		let wkwebView = WKWebView()
		wkwebView.isOpaque = false;
		wkwebView.backgroundColor = UIColor.black;
		wkwebView.navigationDelegate = context.coordinator
		wkwebView.load(URLRequest(url: url))
		return wkwebView
	}
	
	func updateUIView(_ webView: WKWebView, context: Context) {
	}
	
	class Coordinator: NSObject, WKNavigationDelegate {
		var parent: WebView
		init(_ parent: WebView) {
			self.parent = parent
		}
		func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
			parent.isLoading = true
		}
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			parent.isLoading = false
		}
	}
}

struct WebView_Previews: PreviewProvider {
	static var previews: some View {
		WebView(url: URL(string: "https://apple.com/privacy")!, isLoading: Binding.constant(true))
			.edgesIgnoringSafeArea(.bottom)
	}
}
