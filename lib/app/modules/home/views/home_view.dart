import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!kIsWeb) ...[
              Text(Platform.isAndroid ? 'Android => this is host aka server' : 'IOS => This is client'),
              const SizedBox(height: 20),
            ] else ...[
              Text('Web => This is Web'),
              const SizedBox(height: 20),
            ],
            const SizedBox(height: 20),
            const Text('MacOs ${kDebugMode ? 'Debug' : 'Release'}}'),
            Obx(() {
              return Text('MacOs -error ${controller.error.value}');
            }),
            Obx(() {
              return Text('MacOs -log  ${controller.stat.value}');
            }),
            Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.wifiData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.wifiData[index]),
                  );
                },
              );
            }),
            ElevatedButton(
              onPressed: () {
                controller.connect();
              },
              child: Text('Send Message'),
            )
          ],
        ),
      ),
    );
  }
}
