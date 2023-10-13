import 'package:flutter/widgets.dart';


///
/// class App extends StatelessWidget {
///   const App({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return DismissFocusOverlay(
///       child: MaterialApp(
///         theme: exampleAppTheme,
///         home: HomePage(),
///         navigatorObservers: [],
///       ),
///     );
///   }
/// }

class DismissFocusOverlay extends StatelessWidget {
  final Widget? child;

  const DismissFocusOverlay({Key? key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: child,
    );
  }
}
