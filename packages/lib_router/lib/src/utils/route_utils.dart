class RouteUtils {
  // Provides utility functions for routing

  static String buildPath(String basePath, Map<String, String> params) {
    final uri = Uri(path: basePath, queryParameters: params);
    return uri.toString();
  }
}
