import 'package:go_router/go_router.dart';

extension GoRouterExtension on GoRouter {
  String get currentRoute => routerDelegate.currentConfiguration.uri.toString();
}