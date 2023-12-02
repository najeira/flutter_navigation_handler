import 'package:flutter/widgets.dart';

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
  final VoidCallback? onPopNext;

  /// Called when the current route has been pushed.
  final VoidCallback? onPush;

  /// Called when the current route has been popped off.
  final VoidCallback? onPop;

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  final VoidCallback? onPushNext;

  @override
  State<NavigationHandler> createState() => NavigationHandlerState();
}

class NavigationHandlerState extends State<NavigationHandler>
    with RouteAware {
  RouteObserver<ModalRoute<dynamic>>? _observer;

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  void _subscribe() {
    final observer = _findRouteObserver(context);
    if (observer != _observer) {
      _unsubscribe();
    }
    _observer = observer;

    final route = ModalRoute.of(context);
    if (route != null) {
      observer?.subscribe(this, route);
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
  }

  @override
  void didPopNext() {
    widget.onPopNext?.call();
  }

  @override
  void didPush() {
    widget.onPush?.call();
  }

  @override
  void didPop() {
    widget.onPop?.call();
  }

  @override
  void didPushNext() {
    widget.onPushNext?.call();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

RouteObserver<ModalRoute<dynamic>>? _findRouteObserver(BuildContext context) {
  final nav = Navigator.maybeOf(context);
  if (nav != null) {
    for (final observer in nav.widget.observers) {
      if (observer is RouteObserver<ModalRoute<dynamic>>) {
        return observer;
      }
    }
  }
  return null;
}
