import 'package:animations/models/album.dart';
import 'package:animations/services/api_service.dart';
import 'package:get/get.dart';

class ApiController extends GetxController {
  var isCalling = false.obs;
  final apiService = ApiService();
  Album finalAlbum = Album(userId: 0, id: 0, title: '');

  getAlbum() async {
    isCalling(true);
    print('started');
    Response albumResponse = await apiService.getAlbums();
    Album album = Album.fromMap(albumResponse.body);
    finalAlbum = album;
    isCalling(false);
    print('ended');
    return;
  }
}
