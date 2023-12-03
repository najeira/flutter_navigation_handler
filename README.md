A widget that listens to navigation events.

## Usage

```dart
class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationHandler(
      onPush: (_, __) {
        // this route has been pushed.
      },
      onPushNext: (_, __) {
        // A new route has been pushed, 
        // and this route is no longer visible.
      },
      onPopNext: (_, __) {
        // The top route has been popped off, 
        // and this route shows up.
      },
      onPop: (_, __) {
        // this route has been popped off.
      },
      child: Container()
    );
  }
}
```
