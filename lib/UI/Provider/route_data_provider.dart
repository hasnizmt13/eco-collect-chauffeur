class RouteDataProvider {
  static final RouteDataProvider _instance = RouteDataProvider._internal();

  factory RouteDataProvider() {
    return _instance;
  }

  RouteDataProvider._internal();

  Map<String, dynamic> _routeData = {};

  void setRouteData(Map<String, dynamic> routeData) {
    _routeData = routeData;
  }

  Map<String, dynamic> get routeData => _routeData;
}
