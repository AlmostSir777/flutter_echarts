import 'package:flutter/material.dart';
import 'flutter_echarts.dart';

export './echarts_event_manager.dart';
export './theme.dart';

class BaiinfoEcharts extends StatelessWidget {
  final String? option;
  final String extraScript;

  final void Function(String message)? onMessage;

  final List<String> extensions;

  final String? theme;

  final bool captureAllGestures;

  final bool captureHorizontalGestures;

  final bool captureVerticalGestures;

  final bool showLoading;

  final bool reloadAfterInit;

  final void Function(dynamic)? onLoad;

  final bool hasWatermarkImage;

  const BaiinfoEcharts({
    Key? key,
    required this.option,
    this.extraScript = '',
    this.onMessage,
    this.extensions = const [],
    this.theme,
    this.captureAllGestures = false,
    this.captureHorizontalGestures = false,
    this.captureVerticalGestures = false,
    this.showLoading = true,
    this.reloadAfterInit = false,
    this.onLoad,
    this.hasWatermarkImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> currentExtentions = [
      lightThemeScript,
      darkThemeScript,
      ...extensions,
    ];

    return (option?.isEmpty ?? true
        ? const SizedBox()
        : Echarts(
            option: option!,
            extensions: currentExtentions,
            extraScript: extraScript,
            onMessage: onMessage,
            theme: theme ?? 'light',
            captureAllGestures: captureAllGestures,
            captureHorizontalGestures: captureHorizontalGestures,
            captureVerticalGestures: captureVerticalGestures,
            onLoad: onLoad,
            reloadAfterInit: reloadAfterInit,
            hasWatermarkImage: hasWatermarkImage,
          ));
  }
}
