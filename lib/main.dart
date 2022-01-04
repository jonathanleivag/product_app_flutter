import 'package:flutter/material.dart';
import 'package:product_app/providers/providers.dart'
    show ProductsProvider, AuthProvider;
import 'package:product_app/routers/router.dart';
import 'package:product_app/utils/utils.dart' show NotificationUtil;
import 'package:product_app/views/views.dart' show CheckAuthView;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: NotificationUtil.globalKey,
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: CheckAuthView.routerName,
      routes: router,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(color: Colors.indigo, elevation: 0),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
      ),
    );
  }
}
