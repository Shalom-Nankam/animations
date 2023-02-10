import 'package:get/get_connect.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://jsonplaceholder.typicode.com/albums/1';
  }

  Future<Response> getAlbums() =>
      get('https://jsonplaceholder.typicode.com/albums/1');
}
