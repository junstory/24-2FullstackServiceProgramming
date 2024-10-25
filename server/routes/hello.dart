import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  // TODO: implement route handler
  final request = context.request;

  final method = request.method.value;
  final headers = request.headers;
  final params = request.uri.queryParameters;
  final name = params['name'] ?? 'there';
  return Response(body: 'Headers: $headers\nThis is a new $method route! with $name');
}
