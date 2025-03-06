import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      // Handle cases where there is a response (HTTP errors)
      if (err.response!.statusCode! >= 300) {
        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: err.response!.data['message'] ?? err.response!.statusMessage!,
          type: err.type,
        );
      } else {
        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: 'Something went wrong',
          type: err.type,
        );
      }
    } else {
      // Handle connection errors
      if (err.type == DioExceptionType.connectionError) {
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'No internet connection. Please check your Wi-Fi or mobile data.',
          type: err.type,
        );
      } else {
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'Unknown error occurred',
          type: err.type,
        );
      }
    }

    // Don't proceed with the request if the error is a connection error
    // by invoking the handler with the custom error
    handler.next(err);
  }
}
