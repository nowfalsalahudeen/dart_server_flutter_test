import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:belatuk_http_server/belatuk_http_server.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var wifiData = [].obs;

  IOWebSocketChannel? channel;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getWifiDetails();
    connectServer();
    // if (Platform.isMacOS) {
    //   debugPrint('Android => this is host aka server');
    //   connectServer();
    // } else {
    //   debugPrint('IOS => This is client');
    //   connectClient();
    // }
  }

  void connect() {}

  @override
  void onClose() {
    super.onClose();
  }

  getWifiDetails() async {
    final info = NetworkInfo();

    final wifiName = await info.getWifiName(); // "FooNetwork"
    final wifiBSSID = await info.getWifiBSSID(); // 11:22:33:44:55:66
    final wifiIP = await info.getWifiIP(); // 192.168.1.43
    final wifiIPv6 = await info.getWifiIPv6(); // 2001:0db8:85a3:0000:0000:8a2e:0370:7334
    final wifiSubmask = await info.getWifiSubmask(); // 255.255.255.0
    final wifiBroadcast = await info.getWifiBroadcast(); // 192.168.1.255
    final wifiGateway = await info.getWifiGatewayIP(); // 192.168.1.1

    var list = [
      'wifiName       => $wifiName',
      'wifiBSSID      => $wifiBSSID',
      'wifiIP         => $wifiIP',
      'wifiIPv6       => $wifiIPv6',
      'wifiSubmask    => $wifiSubmask',
      'wifiBroadcast  => $wifiBroadcast',
      'wifiGateway    => $wifiGateway'
    ];
    wifiData.value = list;
  }

  void connectServer() async {
    // var server = await HttpServer.bind('localhost', 8080);
    // server.transform(HttpBodyHandler(defaultEncoding: utf8)).listen((body) {
    //   switch (body.type) {
    //     case 'text':
    //       print(body.body);
    //       break;
    //
    //     case 'json':
    //       print(body.body);
    //       break;
    //
    //     default:
    //       throw StateError('bad body type');
    //   }
    //   body.request.response.close();
    // }, onError: (Object error) {
    //   throw StateError('bad connection');
    // });

    // var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8090);
    // print("Server running on IP : " + server.address.toString() + " On Port : " + server.port.toString());
    // await for (var request in server) {
    //   request.response
    //     ..headers.contentType = new ContentType("text", "plain", charset: "utf-8")
    //     ..write('Hello, world')
    //     ..close();
    //
    //   var statusText = "Server running on IP : " + server.address.toString() + " On Port : " + server.port.toString();
    //   print('Request received! $statusText');
    // }

    final app = Alfred(onInternalError: onError);

    app.get('/', (req, res) => 'Its working');

    app.get('/text', (req, res) => 'Text response');

    app.get('/json', (req, res) => {'json_response': true});

    app.get('/jsonExpressStyle', (req, res) {
      res.json({'type': 'traditional_json_response'});
    });

    app.get('/file', (req, res) => File('test/files/image.jpg'));

    app.get('/html', (req, res) {
      res.headers.contentType = ContentType.html;
      return '<html><body><h1>Test HTML</h1></body></html>';
    });

    await app.listen(6565).then((value) {
      print('Server running on port 6565');
      stat.value = 'Server running on port 6565';
    }).onError((error, stackTrace) {
      print('Server running on port 6565');
      stat.value = 'Server running on port 6565 error ${error.toString()}';
    }); //Listening on port 6565
  }

  var stat = ''.obs;

  void connectClient() async {
    // api request using http
    var response = await http.get(Uri.parse('http://192.168.0.137:6565/html'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  var error = ''.obs;
  FutureOr onError(HttpRequest req, HttpResponse res) {
    res.statusCode = HttpStatus.internalServerError;
    res.write('Internal server error');
    res.close();
    error.value = 'Internal server error';
  }
}
