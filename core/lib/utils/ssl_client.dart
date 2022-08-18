import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class SSLClient {
  static SSLClient? _sslClient;

  SSLClient._instance() {
    _sslClient = this;
  }

  factory SSLClient() => _sslClient ?? SSLClient._instance();

  static IOClient? _ioClient;

  Future<IOClient> get ioClient async {
    _ioClient ??= await _initClient();
    return _ioClient!;
  }

  Future<SecurityContext> get _globalContext async {
    final sslCert = await rootBundle.load('certificates/certificate.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: true);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

    return securityContext;
  }

  Future<IOClient> _initClient() async {
    HttpClient client = HttpClient(context: await _globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(client);
  }
}
