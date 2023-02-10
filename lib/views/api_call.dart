import 'package:animations/controllers/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiCall extends StatelessWidget {
  ApiCall({super.key});

  final ApiController _apiController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api Page'),
        elevation: 0,
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: _apiController.isCalling.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          height: 100,
                          width: 200,
                          color: Colors.grey,
                          child: Column(
                            children: [
                              Text(_apiController.finalAlbum.title),
                              const SizedBox(height: 10),
                              Text('${_apiController.finalAlbum.id}')
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
