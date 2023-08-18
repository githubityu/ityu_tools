import 'dart:io';

import 'package:dio/io.dart';

final httpAdapter2 = IOHttpClientAdapter(
    validateCertificate: (X509Certificate? certificate, String host, int port) {
  return true;
});
