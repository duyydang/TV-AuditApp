import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  String myCustomUrl = 'https://125.212.238.246:3773/MERP/';

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(myCustomUrl)),
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            //Do some checks here to decide if CANCELS or PROCEEDS
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          },
          //Handler with Javascript
          onWebViewCreated: (controller) {
            controller.addJavaScriptHandler(
              handlerName: "SendLocation",
              callback: (data) {
                //Data is handler from Javascript
              },
            );
          },
        ),
      ),
    );
  }
}
