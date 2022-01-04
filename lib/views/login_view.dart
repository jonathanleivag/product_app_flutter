import 'package:flutter/material.dart';
import 'package:product_app/providers/providers.dart'
    show LoginFormProvider, AuthProvider;
import 'package:product_app/ui/ui.dart';
import 'package:product_app/utils/utils.dart' show NotificationUtil;
import 'package:product_app/validators/validators.dart';
import 'package:product_app/views/views.dart' show RegisterView, HomeView;
import 'package:product_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  static String routerName = 'LoginView';

  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardWidget(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (context) => LoginFormProvider(),
                      child: const _Form(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  RegisterView.routerName,
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    Colors.indigo.withOpacity(0.1),
                  ),
                  shape: MaterialStateProperty.all(
                    const StadiumBorder(),
                  ),
                ),
                child: const Text(
                  'Crear una nueva cuenta',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginFormProvider loginFormProvider =
        Provider.of<LoginFormProvider>(context);
    return Form(
        key: loginFormProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: true,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => loginFormProvider.email = value,
              decoration: InputDecorationUI.authDecoration(
                labelText: 'Correo Electrónico',
                hintText: 'email@email.cl',
                icon: Icons.alternate_email_sharp,
              ),
              validator: (value) => InputLogin.inputEmail(value: value),
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.text,
              obscureText: true,
              onChanged: (value) => loginFormProvider.password = value,
              decoration: InputDecorationUI.authDecoration(
                labelText: 'Ingrese su password',
                hintText: 'Password',
                icon: Icons.lock_outline,
              ),
              validator: (value) => InputLogin.inputPassword(value: value),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              color: Colors.deepPurple,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15,
                ),
                child: Text(
                  loginFormProvider.isLoading ? 'Espere...' : 'Ingresar',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: loginFormProvider.isLoading
                  ? null
                  : () async {
                      if (loginFormProvider.isValidForm()) {
                        final AuthProvider authProvider =
                            Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );

                        FocusScope.of(context).unfocus();
                        loginFormProvider.isLoading = true;

                        final String? resp = await authProvider.login(
                          loginFormProvider.email,
                          loginFormProvider.password,
                        );

                        if (resp == null) {
                          loginFormProvider.isLoading = false;
                          Navigator.pushReplacementNamed(
                            context,
                            HomeView.routerName,
                          );
                        } else {
                          NotificationUtil.showSnackBar(resp);
                        }
                      }
                    },
            )
          ],
        ));
  }
}
