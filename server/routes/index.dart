import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  final request = context.request;

  final params = request.uri.queryParameters;
  return Response(body: 'Welcome to Dart Frog!$params');
}
