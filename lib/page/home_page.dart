import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
  );

  Future<String> getStorageDirectory() async {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      return downloadsDir.path;
    } else {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        return externalDir.path;
      } else {
        throw Exception('No storage directory available');
      }
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
            print('On Downloading');
            // Get the appropriate storage directory
            final storageDir = await getStorageDirectory();
            // Generate a unique filename based on the URL
            final urlString = url.url.toString();
            String formattedDate =
                '${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}';
            final filename = '$formattedDate.${urlString.split('/').last}';
            print(filename);

            // Enqueue the download with the generated filename
            await FlutterDownloader.enqueue(
              url: urlString,
              fileName: filename,
              savedDir: storageDir,
              showNotification: true,
              requiresStorageNotLow: false,
              openFileFromNotification:
                  false, // Set this to false to prevent automatic file opening
              saveInPublicStorage: true,
            );
          },
        ),
      ),
    );
  }
}
