import 'package:flutter/widgets.dart';

typedef NavigationCallback = void Function(
    NavigatorState?, PageRoute<dynamic>);

/// A widget that listens to navigation events.
class NavigationHandler extends StatefulWidget {
  const NavigationHandler({
    super.key,
    required this.child,
    this.onPopNext,
    this.onPush,
    this.onPop,
    this.onPushNext,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  final NavigationCallback? onPopNext;

  /// Called when the current route has been pushed.
  final NavigationCallback? onPush;

  /// Called when the current route has been popped off.
  final NavigationCallback? onPop;

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  final NavigationCallback? onPushNext;

  @override
  State<NavigationHandler> createState() => NavigationHandlerState();
}

class NavigationHandlerState extends State<NavigationHandler> with RouteAware {
  RouteObserver<PageRoute<dynamic>>? _observer;

  PageRoute<dynamic>? _route;

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  void _subscribe() {
    final observer = _findRouteObserver(context);
    final route = ModalRoute.of(context) as PageRoute<dynamic>?;
    if (observer != _observer || route != _route) {
      _unsubscribe();
    }
    _observer = observer;
    _route = route;
    if (observer != null && route != null) {
      observer.subscribe(this, route);
    }
  }

  @override
  @mustCallSuper
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _unsubscribe() {
    _observer?.unsubscribe(this);
    _observer = null;
    _route = null;
  }

  @override
  void didPopNext() => _call(widget.onPopNext);

  @override
  void didPush() => _call(widget.onPush);

  @override
  void didPop() => _call(widget.onPop);

  @override
  void didPushNext() => _call(widget.onPushNext);

  void _call(NavigationCallback? callback) {
    if (callback != null && _observer != null && _route != null) {
      callback(_observer?.navigator, _route!);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

RouteObserver<PageRoute<dynamic>>? _findRouteObserver(BuildContext context) {
  final nav = Navigator.maybeOf(context);
  if (nav != null) {
    for (final observer in nav.widget.observers) {
      if (observer is RouteObserver<PageRoute<dynamic>>) {
        return observer;
      }
    }
  }
  return null;
}
