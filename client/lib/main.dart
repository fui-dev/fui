import 'dart:io';

import 'package:fui/fui.dart';
// --FAT_CLIENT_START--
import 'package:fui_audio/fui_audio.dart' as fui_audio;
// --FAT_CLIENT_END--
import 'package:fui_audio_recorder/fui_audio_recorder.dart'
    as fui_audio_recorder;
import 'package:fui_camera/fui_camera.dart' as fui_camera;
import 'package:fui_lightsensor/fui_lightsensor.dart' as fui_lightsensor;
import "package:fui_flashlight/fui_flashlight.dart" as fui_flashlight;
import 'package:fui_geolocator/fui_geolocator.dart' as fui_geolocator;
import 'package:fui_lottie/fui_lottie.dart' as fui_lottie;
import 'package:fui_map/fui_map.dart' as fui_map;
import 'package:fui_permission_handler/fui_permission_handler.dart'
    as fui_permission_handler;
import 'package:fui_rive/fui_rive.dart' as fui_rive;
import 'package:fui_ads/fui_ads.dart' as fui_ads;
// --FAT_CLIENT_START--
import 'package:fui_video/fui_video.dart' as fui_video;
// --FAT_CLIENT_END--
import 'package:fui_webview/fui_webview.dart' as fui_webview;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

void main([List<String>? args]) async {

  await setupDesktop();

  WidgetsFlutterBinding.ensureInitialized();

  // --FAT_CLIENT_START--
  fui_audio.ensureInitialized();
  fui_video.ensureInitialized();
  // --FAT_CLIENT_END--
  fui_audio_recorder.ensureInitialized();
  fui_geolocator.ensureInitialized();
  fui_permission_handler.ensureInitialized();
  fui_lottie.ensureInitialized();
  fui_map.ensureInitialized();
  fui_ads.ensureInitialized();
  fui_rive.ensureInitialized();
  fui_webview.ensureInitialized();
  fui_flashlight.ensureInitialized();
  fui_camera.ensureInitialized();
  fui_lightsensor.ensureInitialized();

  var pageUrl = Uri.base.toString();
  var assetsDir = "";

  if (kIsWeb) {
    var routeUrlStrategy = getfuiRouteUrlStrategy();
    if (routeUrlStrategy == "path") {
      setPathUrlStrategy();
    }
  } else if ((Platform.isWindows || Platform.isMacOS || Platform.isLinux) &&
      kDebugMode) {
    // first argument must be
    if (args!.isEmpty) {
      throw Exception('Page URL must be provided as a first argument.');
    }
    pageUrl = args[0];
    if (args.length > 1) {
      var pidFilePath = args[1];
      var pidFile = await File(pidFilePath).create();
      await pidFile.writeAsString("$pid");
    }
    if (args.length > 2) {
      assetsDir = args[2];
    }
  }

  fuiAppErrorsHandler errorsHandler = fuiAppErrorsHandler();

  if (kDebugMode) {
    FlutterError.onError = (details) {
      errorsHandler.onError(details.exceptionAsString());
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      errorsHandler.onError(error.toString());
      return true;
    };
  }

  runApp(fuiApp(
    title: 'fui',
    pageUrl: pageUrl,
    assetsDir: assetsDir,
    errorsHandler: errorsHandler,
    createControlFactories: [
// --FAT_CLIENT_START--
      fui_audio.createControl,
      fui_video.createControl,
// --FAT_CLIENT_END--
      fui_audio_recorder.createControl,
      fui_geolocator.createControl,
      fui_permission_handler.createControl,
      fui_lottie.createControl,
      fui_map.createControl,
      fui_ads.createControl,
      fui_rive.createControl,
      fui_webview.createControl,
      fui_flashlight.createControl,
      fui_camera.createControl,
      fui_lightsensor.createControl,
    ],
  ));
}