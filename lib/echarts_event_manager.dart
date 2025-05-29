import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';

enum EchartsEventAction { hideTip, themeChange }

class EchartsEventManager {
  factory EchartsEventManager() => _getInstance();

  static EchartsEventManager get instance => _getInstance();
  static EchartsEventManager? _instance;

  EchartsEventManager._internal() {
    _eventBus = EventBus();
  }

  static EchartsEventManager _getInstance() {
    _instance ??= EchartsEventManager._internal();
    return _instance!;
  }

  @mustCallSuper
  dispose() {
    _eventBus.destroy();
  }

  late EventBus _eventBus;
  EventBus get eventBus => _eventBus;

  fire<T>(EchartsEventModel<T> value) {
    _eventBus.fire(value);
  }
}

class EchartsEventModel<T> {
  EchartsEventAction? action;
  T? data;
}
