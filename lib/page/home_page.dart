import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  String myCustomUrl = 'https://125.212.238.246:3773/MERP/';

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      useOnDownloadStart: true,
      mediaPlaybackRequiresUserGesture: false,
      supportZoom: false,
      preferredContentMode: UserPreferredContentMode.MOBILE,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      supportMultipleWindows: true,
    ),
  );

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: InAppWebView(
          initialOptions: options,
          initialUrlRequest: URLRequest(url: Uri.parse(myCustomUrl)),
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            // Do some checks here to decide if CANCELS or PROCEEDS
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          },
          onDownloadStartRequest: (controller, url) async {
            _launchUrl(url.url);
          },
        ),
      ),
    );
  }
}
