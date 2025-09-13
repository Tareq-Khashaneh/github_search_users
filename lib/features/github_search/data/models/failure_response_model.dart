class ValidationFailureResponse {
  final String message;
  final List<ErrorDetail> errors;
  final String documentationUrl;
  final int status;

  ValidationFailureResponse({
    required this.message,
    required this.errors,
    required this.documentationUrl,
    required this.status,
  });

  factory ValidationFailureResponse.fromJson(Map<String, dynamic> json) {
    return ValidationFailureResponse(
      message: json['message'] ?? 'Unknown error',
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => ErrorDetail.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      documentationUrl: json['documentation_url'] ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'errors': errors.map((e) => e.toJson()).toList(),
      'documentation_url': documentationUrl,
      'status': status,
    };
  }
}

class ErrorDetail {
  final String resource;
  final String field;
  final String code;

  ErrorDetail({
    required this.resource,
    required this.field,
    required this.code,
  });

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      resource: json['resource'] ?? '',
      field: json['field'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resource': resource,
      'field': field,
      'code': code,
    };
  }
}
