import 'dart:io';

abstract class ImagesAPIRepository {
  Future<HttpResponse?> sendToServer(List<String> base64List);
}

class DummyAPI extends ImagesAPIRepository {
  @override
  Future<HttpResponse?> sendToServer(List<String> base64List) async {
    await Future.delayed(const Duration(seconds: 10));
    return null;
  }
}
