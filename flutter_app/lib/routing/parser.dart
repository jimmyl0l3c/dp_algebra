import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import 'parsed_route.dart';

class RouteParser extends RouteInformationParser<ParsedRoute> {
  final List<String> _pathTemplates;
  final ParsedRoute initialRoute;

  RouteParser({
    required List<String> allowedPaths,
    String initialRoute = '/',
  })  : initialRoute = ParsedRoute(initialRoute, initialRoute, {}, {}),
        _pathTemplates = [
          ...allowedPaths,
        ],
        assert(allowedPaths.contains(initialRoute));

  @override
  Future<ParsedRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final path = routeInformation.location;
    final queryParams = Uri.parse(path).queryParameters;
    var parsedRoute = initialRoute;

    for (var pathTemplate in _pathTemplates) {
      final parameters = <String>[];
      var pathRegExp = pathToRegExp(pathTemplate, parameters: parameters);
      if (pathRegExp.hasMatch(path)) {
        final match = pathRegExp.matchAsPrefix(path);
        if (match == null) continue;
        final params = extract(parameters, match);
        parsedRoute = ParsedRoute(path, pathTemplate, params, queryParams);
      }
    }

    return parsedRoute;
  }

  @override
  RouteInformation? restoreRouteInformation(ParsedRoute configuration) =>
      RouteInformation(location: configuration.path);
}
