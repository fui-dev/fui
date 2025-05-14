// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:ambient_light/ambient_light_web.dart';
import 'package:audioplayers_web/audioplayers_web.dart';
import 'package:camera_web/camera_web.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:geolocator_web/geolocator_web.dart';
import 'package:package_info_plus/src/package_info_plus_web.dart';
import 'package:permission_handler_html/permission_handler_html.dart';
import 'package:record_web/record_web.dart';
import 'package:rive_common/rive_web.dart';
import 'package:sensors_plus/src/sensors_plus_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:wakelock_plus/src/wakelock_plus_web_plugin.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  AmbientLightWeb.registerWith(registrar);
  AudioplayersPlugin.registerWith(registrar);
  CameraPlugin.registerWith(registrar);
  FilePickerWeb.registerWith(registrar);
  GeolocatorPlugin.registerWith(registrar);
  PackageInfoPlusWebPlugin.registerWith(registrar);
  WebPermissionHandler.registerWith(registrar);
  RecordPluginWeb.registerWith(registrar);
  RivePlugin.registerWith(registrar);
  WebSensorsPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  WakelockPlusWebPlugin.registerWith(registrar);
  WebWebViewPlatform.registerWith(registrar);
  registrar.registerMessageHandler();
}
