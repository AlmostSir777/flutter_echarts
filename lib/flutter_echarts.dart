library flutter_echarts;

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import './echarts_event_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
export './echarts_event_manager.dart';
import 'echarts_min_script.dart' show echartsScript;
import 'inobounce.dart' show inobounce;

export './baiinfo_echarts.dart';

String htmlBase64 = '''<!DOCTYPE html>
    <html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0, target-densitydpi=device-dpi" />
    <style type="text/css">body,html,#chart{height: 100%;width: 100%;margin: 0px;}div {-webkit-tap-highlight-color:rgba(255,255,255,0);}${Platform.isIOS ? '''#chart{overflow: auto;
				-webkit-overflow-scrolling: touch;}''' : ''}
        </style>
        </head>
        <body style="background-color: rgb(255,255,255,0); opacity: 0.99;"><div id="chart" />
        </body>
        <script>${Platform.isIOS ? inobounce : ''}</script>
        <script>$echartsScript</script>
        </html>''';

class Echarts extends StatefulWidget {
  Echarts({
    Key? key,
    required this.option,
    this.extraScript = '',
    this.onMessage,
    this.extensions = const [],
    this.theme,
    this.captureAllGestures = false,
    this.captureHorizontalGestures = false,
    this.captureVerticalGestures = false,
    this.onLoad,
    this.onWebResourceError,
    this.reloadAfterInit = false,
    this.hasWatermarkImage = false,
  }) : super(key: key);

  final String option;

  final String extraScript;

  final void Function(String message)? onMessage;

  final List<String> extensions;

  final String? theme;

  final bool captureAllGestures;

  final bool captureHorizontalGestures;

  final bool captureVerticalGestures;

  final void Function(WebViewController)? onLoad;

  final void Function(WebViewController, Exception)? onWebResourceError;

  final bool reloadAfterInit;

  final bool hasWatermarkImage;

  @override
  EchartsState createState() => EchartsState();
}

class EchartsState extends State<Echarts> with WidgetsBindingObserver {
  late WebViewController _controller;
  String? _currentOption;

  bool? _isDark;

  StreamSubscription? _listen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            init();
          },
          onWebResourceError: (WebResourceError error) {
            if (widget.onWebResourceError != null) {
              widget.onWebResourceError!(_controller, Exception(error));
            }
          },
        ),
      )
      ..addJavaScriptChannel('Messager',
          onMessageReceived: (javascriptMessage) {
        if (widget.onMessage != null) {
          widget.onMessage!(javascriptMessage.message);
        }
      });
    _controller.loadHtmlString(htmlBase64);
    _currentOption = widget.option;

    if (widget.reloadAfterInit) {
      new Future.delayed(const Duration(milliseconds: 100), () {
        _controller.reload();
      });
    }

    _listen =
        EchartsEventManager().eventBus.on<EchartsEventModel>().listen((event) {
      if (event.action == EchartsEventAction.hideTip) {
        String script = '''chart.dispatchAction({
          type:'hideTip'
        })
        chart.dispatchAction({
          type:'updateAxisPointer',
          currTrigger:'leave'
        })
        ''';
        _controller.runJavaScript(script);
      } else if (event.action == EchartsEventAction.themeChange) {
        bool isDark = event.data;
        if (_isDark != isDark) {
          _isDark = isDark;
          themeChange();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.clearCache();
    _listen?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      checkWebResult();
    } else if (state == AppLifecycleState.paused) {}
  }

  void checkWebResult() async {
    var result = await _controller.runJavaScriptReturningResult(
        'document.getElementById("chart").clientWidth');
    num? value = result is String ? num.tryParse(result) : (result as num?);
    value ??= 0;
    if (value == 0) {
      _controller.reload();
    }
  }

  void init() async {
    final extensionsStr = this.widget.extensions.length > 0
        ? this
            .widget
            .extensions
            .reduce((value, element) => value + '\n' + element)
        : '';
    //\'dark\'
    final themeStr =
        this.widget.theme != null ? '\'${this.widget.theme}\'' : 'null';
    await _controller.runJavaScript('''
      $extensionsStr
      var chart = echarts.init(document.getElementById('chart'),  $themeStr);
      var option = $_currentOption;
      ${widget.hasWatermarkImage ? EchartsFunc.echartsScriptFunc() : ''}
      ${this.widget.extraScript}
      chart.on('finished', function(){
      Messager.postMessage(JSON.stringify({'id':chart.id,'desc':'加载结束', 'type':2})); 
    });
      chart.setOption(option, true);
      Messager.postMessage(JSON.stringify({'id':chart.id, 'desc':'正在加载' ,'type':1})); 
      window.onresize  = ()=>{
         chart.resize();
     }
    ''');
    if (widget.onLoad != null) {
      widget.onLoad!(_controller);
    }
  }

  void themeChange() async {
    final themeStr = _isDark == true ? '\'dark\'' : '\'light\'';
    await _controller.runJavaScript('''
      var chart = echarts.getInstanceByDom(document.getElementById('chart'));
      if (chart != null) {
         chart.dispose();
      }
      chart = echarts.init(document.getElementById('chart'),  $themeStr);
      var option = $_currentOption;
      ${widget.hasWatermarkImage ? EchartsFunc.echartsScriptFunc() : ''}
      ${this.widget.extraScript}
      chart.setOption(option, true);
      Messager.postMessage(JSON.stringify({'id':chart.id,'desc':'更新option','type':3})); 
    ''');
  }

  Set<Factory<OneSequenceGestureRecognizer>> getGestureRecognizers() {
    Set<Factory<OneSequenceGestureRecognizer>> set = Set();
    if (this.widget.captureAllGestures ||
        this.widget.captureHorizontalGestures) {
      set.add(Factory<HorizontalDragGestureRecognizer>(() {
        return HorizontalDragGestureRecognizer()
          ..onStart = (DragStartDetails details) {}
          ..onUpdate = (DragUpdateDetails details) {}
          ..onDown = (DragDownDetails details) {}
          ..onCancel = () {}
          ..onEnd = (DragEndDetails details) {};
      }));
    }
    if (this.widget.captureAllGestures || this.widget.captureVerticalGestures) {
      set
        ..add(Factory<VerticalDragGestureRecognizer>(() {
          return VerticalDragGestureRecognizer()
            ..onStart = (DragStartDetails details) {
              print(details.kind);
            }
            ..onUpdate = (DragUpdateDetails details) {}
            ..onDown = (DragDownDetails details) {}
            ..onCancel = () {}
            ..onEnd = (DragEndDetails details) {};
        }))
        ..add(
          Factory<PanGestureRecognizer>(
            () => PanGestureRecognizer(),
          ),
        )
        ..add(
          Factory<ForcePressGestureRecognizer>(
            () => ForcePressGestureRecognizer(),
          ),
        )
        ..add(
          Factory<EagerGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        )
        ..add(
          Factory<LongPressGestureRecognizer>(
            () => LongPressGestureRecognizer(),
          ),
        );
    }
//     set.add(Factory<LongPressGestureRecognizer>(() {
//       return LongPressGestureRecognizer()
//         ..onLongPressDown = (value) async {
//           String? base64 = await _controller?.runJavascriptReturningResult('''
// var base64 = chart.getDataURL({
//             pixelRatio: 2,
//             backgroundColor: '#fff'
//         });
//          Messager.postMessage(JSON.stringify({'id':chart.id, 'baseStr':base64}));
// ''');
//           log(base64 ?? '');
//         };
//     }));
    return set;
  }

  void update(String preOption) async {
    _currentOption = widget.option;
    if (_currentOption != preOption) {
      await _controller.runJavaScript('''
        try {
          ${this.widget.extraScript}
           var option = $_currentOption;
            ${widget.hasWatermarkImage ? EchartsFunc.echartsScriptFunc() : ''}
          chart.setOption(option, true);
          Messager.postMessage(JSON.stringify({'id':chart.id,'desc':'更新option','type':3})); 
        } catch(e) {
        }
      ''');
    }
  }

  @override
  void didUpdateWidget(Echarts oldWidget) {
    super.didUpdateWidget(oldWidget);
    update(oldWidget.option);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
      gestureRecognizers: getGestureRecognizers(),
    );
  }
}

class EchartsFunc {
  /// echarts 水印
  static const String echartsWatermarkImage =
      '''var watermarkImage = new Image();
watermarkImage.src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAYAAACtWK6eAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyhpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMC1jMDAwIDc5LjE3MWMyN2ZhYiwgMjAyMi8wOC8xNi0yMjozNTo0MSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI0LjAgKE1hY2ludG9zaCkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OEFBQjhFOEZDNzBGMTFFRTk5NTJENDQ4QTVCNEYzMEUiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OEFBQjhFOTBDNzBGMTFFRTk5NTJENDQ4QTVCNEYzMEUiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo4QUFCOEU4REM3MEYxMUVFOTk1MkQ0NDhBNUI0RjMwRSIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo4QUFCOEU4RUM3MEYxMUVFOTk1MkQ0NDhBNUI0RjMwRSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PmB5H/QAABNZSURBVHja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a9MhLw8R5BJZvbb2KQ4KpF3wt7vOSXTzz1kIw434XyAmrY45EdwzYrDzG0P8WBlidRLr8AxlhFs62XhuEu26OfeOOX8c4jnyBLLHj5UepFPw1z2JRPcSDy1VWQt4CxcyVelBKJBOZdsLk6zB+5wZ0RS8PORUWut8QiiQa49/N6akZHvECOOb51lsx0NCgXQUzgNsmdwt1OHkBnIQ9SRfveezewgF0tHYsq/fWsf9/ATJuQu/3kub3hucRLCK1RzaoG1Oou2urnLl1lENmPzENWg74sdFgXQjLsnWxYfDEm131SXsawylKJBuRsu+981juxItpScUSNfjBHGAfMNVt/b5kVAgJM4HJOF1fhQUCLkIt7t2AYV6nQMgIUlwHoQQCoQQCoQQCoQQCoQQCoQQCoQQCoQQCoQQCoQQQoEQQoEQQoEQQoEQQoEQQoEQQoEQQoEQQoEQQoEQQigQQigQQigQQigQQigQQigQQigQQigQQigQQggFQggFQggFQggFQggFQggFQggFQggFQggFQggFQgihQAihQAihQAihQAihQAihQAihQAihQAihQAghFAghFAghFAghV8T/BRgA8onwFRMZn3AAAAAASUVORK5CYII='; 
''';

  static String echartsScriptFunc() {
    return '''
  $echartsWatermarkImage
   option = {
    ...option,
    backgroundColor: {
    type: 'pattern',
    image:watermarkImage,
    repeat: 'repeat',
    scaleX:1,
    scaleY:1,
  }
   }
''';
  }
}
