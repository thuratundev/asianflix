import 'dart:async';
import 'dart:io';

import 'package:asianflix/viewmodels/dataserviceviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class PlayScreen extends StatefulWidget {

  String initurl;

  PlayScreen({required this.initurl,Key? key}):super(key: key);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {

  String? playUrl;

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  final CookieManager cookieManager = CookieManager();

  late WebViewController _webviewController;


  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);


    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    Provider.of<DataServiceViewModel>(context,listen: false).getMoviePlayUrl(widget.initurl).
    then((value) {
      setState(() {
        playUrl = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: playUrl == null ?
        const Center(child: CircularProgressIndicator()) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: WebView(
                      initialUrl: playUrl,

                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);


                        /*Need to Clear Cookies to reload video*/
                        cookieManager.clearCookies();
                        _webviewController = webViewController;


                      },
                      onProgress: (int progress) {
                        removeElement();
                      },
                    javascriptChannels: <JavascriptChannel>{
                      _toasterJavascriptChannel(context),
                    },
                      navigationDelegate: (NavigationRequest request) {
                        return NavigationDecision.prevent;
                      },
                      onPageStarted: (String url) {
                        removeElement();

                      },
                      onPageFinished: (String url) {
                        print('Page finished loading: $url');
                        removeElement();
                      },
                      gestureNavigationEnabled: true,
                    ),
                ),
              ),
            ),
          ],
        )

    );
  }

  @override
  dispose(){
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  }

  
  void removeElement()
  {

    _webviewController.evaluateJavascript("document.getElementById('list-server-more').style.display='none';");

    _webviewController.evaluateJavascript("document.querySelectorAll('iframe').forEach(elem => {elem.parentNode.removeChild(elem);});");

  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('ttttt ${message.message}')),
          );
        });
  }
}
