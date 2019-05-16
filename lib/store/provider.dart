import 'package:flutter/widgets.dart';
import 'package:github/store/store.dart';

class StoreProvider extends InheritedWidget {

  static StoreProvider of(BuildContext context) {
    StoreProvider provider = context.inheritFromWidgetOfExactType(StoreProvider);
    return provider;
  }

  final Store store;

  StoreProvider({ Widget child }):
      store = Store(),
      super(child: child);

  @override
  bool updateShouldNotify(StoreProvider oldWidget) {
    return store != oldWidget.store;
  }

}
