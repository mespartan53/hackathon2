import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '/Views/main_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(child,
          maxWidth: 2000,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET, scaleFactor: 0.93),
            const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            const ResponsiveBreakpoint.resize(1800,
                name: 'XL', scaleFactor: 1.1),
          ],
          background: Container(color: const Color.fromARGB(255, 27, 27, 27))),
      initialRoute: "/",
      routes: {
        '/': (context) => const MainView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
