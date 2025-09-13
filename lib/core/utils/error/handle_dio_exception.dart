import 'package:dio/dio.dart';
import 'package:syncrow_test/features/github_search/data/models/failure_response_model.dart';
import 'failures.dart';

class HandleDioException {
  static Failure handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(message: 'Connection timeout. Please try again.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final serverMessage = e.response?.data
            .toString(); // You can parse this more cleanly if it's JSON or XML

        if (statusCode == 400) {
          return BadRequestFailure(
            message: 'Bad request. ${serverMessage ?? ''}',
          );
        } else if (statusCode == 401) {
          return AuthFailure(message: 'Unauthorized. Please log in again.');
        } else if (statusCode == 403) {
          return AuthFailure(message: 'Forbidden access.');
        } else if (statusCode == 404) {
          return NotFoundFailure(message: 'Resource not found.');
        } else if (statusCode == 422) {
          final response = ValidationFailureResponse.fromJson(e.response?.data);
          print("errror");
          return ValidationFailure(message: response.message);
        } else if (statusCode >= 500) {
          return ServerFailure(message: 'Server error. Please try later.');
        } else {
          return ServerFailure(
            message: serverMessage ?? 'Unknown server error.',
          );
        }

      case DioExceptionType.cancel:
        return UnexpectedFailure(message: 'Request was cancelled.');

      case DioExceptionType.unknown:
        return UnexpectedFailure(
          message: 'Something went wrong. Please try again.',
        );

      case DioExceptionType.connectionError:
        return OfflineFailure(message: 'No internet connection.');

      default:
        return UnexpectedFailure(message: 'Unexpected error occurred.');
    }
  }
}
