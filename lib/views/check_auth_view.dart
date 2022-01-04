import 'package:flutter/material.dart';
import 'package:product_app/providers/providers.dart' show AuthProvider;
import 'package:product_app/views/views.dart'
    show HomeView, LoginView;
import 'package:provider/provider.dart';

class CheckAuthView extends StatelessWidget {
  static String routerName = 'CheckAuthView';
  const CheckAuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authProvider.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            Widget data = Container();

            if (!snapshot.hasData) {
              data = const Text('Cargando...');
            }
            Future.microtask(
              () => {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    Widget data = Container();
                    if (snapshot.data == '') {
                      data = const LoginView();
                    } else {
                      data = const HomeView();
                    }
                    return data;
                  },
                ))
              },
            );
            return data;
          },
        ),
      ),
    );
  }
}
