import 'package:flutter/widgets.dart';
import 'package:global_analytics/global_analytics.dart';

/// A [NavigatorObserver] that reports page views to [Plausible].
class GlobalAnalyticsNavigatorObserver extends NavigatorObserver {
  /// The [GlobalAnalytics] instance to report page views to.
  final GlobalAnalytics global;

  /// Creates a [GlobalAnalyticsNavigatorObserver].
  GlobalAnalyticsNavigatorObserver(this.global);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    global.globalEvent(page: route.settings.name ?? '');
  }
}