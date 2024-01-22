// // Package imports:
// import 'package:dio/dio.dart';
//
// class DioExceptions implements Exception {
//   DioExceptions.fromDioError(DioError dioError) {
//     switch (dioError.type) {
//       case DioErrorType.cancel:
//         message = "Request to API server was cancelled";
//         break;
//       case DioErrorType.connectTimeout:
//         message = "Connection timeout with API server";
//         break;
//       // case DioErrorType.DEFAULT:
//       //   message = "Connection to API server failed due to internet connection";
//       //   break;
//       case DioErrorType.receiveTimeout:
//         message = "Receive timeout in connection with API server";
//         break;
//       case DioErrorType.response:
//         message =
//             _handleError(dioError.response?.statusCode ?? 0, dioError.response?.data);
//         break;
//       case DioErrorType.sendTimeout:
//         message = "Send timeout in connection with API server";
//         break;
//       default:
//         message = "Something went wrong";
//         break;
//     }
//   }
//
//   String message;
//
//   String _handleError(int statusCode, dynamic error) {
//     switch (statusCode) {
//       case 400:
//         return 'Bad request';
//       case 404:
//         return error["message"];
//       case 500:
//         return 'Internal server error';
//       default:
//         return '$statusCode';
//     }
//   }
//
//   @override
//   String toString() => message;
// }




import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioError dioError)
      : message = _handleDioError(dioError),
        super();

  String message;

  static String _handleDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        return "Request to API server was cancelled";
      case DioErrorType.sendTimeout:
        return "Connection timeout with API server";
      case DioErrorType.receiveTimeout:
        return "Receive timeout in connection with API server";
      case DioErrorType.badResponse:
        return _handleError(dioError.response?.statusCode ?? 0, dioError.response?.data);
      case DioErrorType.sendTimeout:
        return "Send timeout in connection with API server";
      default:
        return "Something went wrong";
    }
  }

  static String _handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return error["message"];
      case 500:
        return 'Internal server error';
      default:
        return '$statusCode';
    }
  }

  @override
  String toString() => message;
}
