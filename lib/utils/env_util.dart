import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvUtil {
  static final String? _urlFirebase = dotenv.env['URL_FIREBASE'];
  static final String? _cloudName = dotenv.env['CLOUD_NAME'];
  static final String? _uploadPreset = dotenv.env['UPLOAD_PRESET'];
  static final String? _apiWebKeyFirebase = dotenv.env['API_WEB_KEY_FIREBASE'];

  static String get urlFirebase => _urlFirebase ?? '';
  static String get cloudName => _cloudName ?? '';
  static String get uploadPreset => _uploadPreset ?? '';
  static String get apiWebKeyFirebase => _apiWebKeyFirebase ?? '';
}
