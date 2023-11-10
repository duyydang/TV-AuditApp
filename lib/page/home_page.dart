import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
                supportZoom: false,
                preferredContentMode: UserPreferredContentMode.MOBILE),
          ),
          initialUrlRequest: URLRequest(url: Uri.parse(myCustomUrl)),
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            //Do some checks here to decide if CANCELS or PROCEEDS
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          },
          //Handler with Javascript
          onWebViewCreated: (InAppWebViewController controller) {
            controller.addJavaScriptHandler(
              handlerName: "SendLocation",
              callback: (data) {
                //Data is handler from Javascript
              },
            );
          },
          onDownloadStart: (controller, url) async {
            print("onDownloadStart $url");
            final urlStr = url.toString(); // Convert uri to string
            final taskId = await FlutterDownloader.enqueue(
              url: urlStr,
              savedDir: (await getExternalStorageDirectory())!.path,
              showNotification:
                  true, // show download progress in status bar (for Android)
              openFileFromNotification:
                  true, // click on notification to open downloaded file (for Android)
            );
            print("Download task ID: $taskId");
          },
        ),
      ),
    );
  }
}
