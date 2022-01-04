class InputLogin {
  static String? inputEmail({String? value}) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value ?? '')
        ? null
        : 'El valor ingresado no luce como un correo';
  }

  static String? inputPassword({String? value}) {
    return value != null && value.length >= 6
        ? null
        : 'La contraseña al menos tiene que tener 6 caracteres';
  }
}
