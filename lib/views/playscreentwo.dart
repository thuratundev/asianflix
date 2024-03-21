import 'package:asianflix/viewmodels/dataserviceviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class PlayScreenOther extends StatefulWidget {
  String initurl;

  PlayScreenOther({required this.initurl, Key? key}) : super(key: key);

  @override
  _PlayScreenOtherState createState() => _PlayScreenOtherState();
}

class _PlayScreenOtherState extends State<PlayScreenOther> {
  String? playUrl;
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    Provider.of<DataServiceViewModel>(context, listen: false)
        .getMoviePlayUrl(widget.initurl)
        .then((value) {
      setState(() {
        playUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: playUrl == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: InAppWebView(
                        initialUrlRequest: URLRequest(url: Uri.parse(playUrl!)),
                        initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                              useShouldOverrideUrlLoading: false,
                              useShouldInterceptAjaxRequest: false,
                          javaScriptEnabled: true,
                        )),
                        onWebViewCreated: (InAppWebViewController controller) {
                          _webViewController = controller;
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          return NavigationActionPolicy.CANCEL;
                        }),
                  )
                ],
              ));
  }
}
