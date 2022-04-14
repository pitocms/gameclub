import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


void main() {
	runApp(
		const MaterialApp(
			home: WebViewApp(),
		),
	);
}

class WebViewApp extends StatefulWidget {
	
	const WebViewApp({Key? key}) : super(key: key);

	@override
	State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
	late WebViewController webViewController;
	double pageHeight = 100;

	@override
	void initState() {
		super.initState();
	}
	
	// print(controller.runJavascriptReturningResult("document.documentElement.scrollHeight");
	@override
	Widget build(BuildContext context) {
		return WillPopScope(
		onWillPop: () async {
			if(await webViewController.canGoBack()){
				webViewController.goBack();
				
				return false;
			}else{
				return true;
			}
		},
		child: Scaffold(
				appBar: AppBar(
					backgroundColor: const Color.fromRGBO(234, 53, 45, 1),

					actions: [
						IconButton(
							onPressed: () async {
								if(await webViewController.canGoBack()){
									webViewController.goBack();
								}   
							}, 
							icon: const Icon(Icons.arrow_back),
						),
						IconButton(
							onPressed: ()=>webViewController.reload(), 
							icon: const Icon(Icons.refresh)
						)
					],

					title: const Center(child: Text('GameClub')),
				),
				body: WebView(
					javascriptMode: JavascriptMode.unrestricted,
					userAgent: 'random',
					initialUrl: 'https://gameclub.jp/',
					// initialUrl: 'http://localhost:8000/',

					onWebViewCreated: (webViewController){
						this.webViewController = webViewController;
					},

					onPageFinished: (url) async{
						print(url);
						var result = await webViewController.runJavascriptReturningResult("document.body.scrollHeight");
						setState(() {
						  pageHeight = double.parse(result);
						});
						print(pageHeight);
					},
					
					javascriptChannels: {
						JavascriptChannel(
								name: 'Print',
								onMessageReceived: (JavascriptMessage message) {
								
								print("Message"+message.message);
							}
						)
					},
				),
			),
		);
	}
}