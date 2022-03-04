import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio = Dio();

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/fcm/send',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAQLVOz6Y:APA91bF5qO7k4afxkr-pPkX7S30tNubPgAgoF697mgaz-KnfGfdsXP87uAF-XCzK8vSPxYO6fZbXj_Lfll28XsHTKl6-43MObgHtoY6vjoHp7oMOIjTUQKsuBRXCwSStA5hGXGZKZn83',
        },
      ),
    );
  }

  static Future<Response> postData({
    required String token,
  }) async {
    return await dio.post('', data: {
      'to': token,
    });
  }
}
