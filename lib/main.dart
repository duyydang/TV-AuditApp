import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tv_audit/page/home_page.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize();
  await Permission.camera.request();
  await Permission.location.request();
  await Permission.storage.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
