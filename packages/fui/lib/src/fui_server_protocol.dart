import 'fui_server_protocol_javascript_io.dart'
    if (dart.library.js) "fui_server_protocol_javascript_web.dart";
import 'fui_server_protocol_tcp_socket.dart';
import 'fui_server_protocol_web_socket.dart';
import 'utils/platform_utils_non_web.dart'
    if (dart.library.js) "utils/platform_utils_web.dart";

typedef fuiServerProtocolOnDisconnectCallback = void Function();
typedef fuiServerProtocolOnMessageCallback = void Function(String message);
typedef ControlInvokeMethodCallback = Future<String?> Function(
    String methodName, Map<String, String> args);

abstract class fuiServerProtocol {
  factory fuiServerProtocol(
      {required String address,
      required fuiServerProtocolOnDisconnectCallback onDisconnect,
      required fuiServerProtocolOnMessageCallback onMessage}) {
    if (isfuiWebPyodideMode()) {
      // JavaScript
      return fuiJavaScriptServerProtocol(
          address: address, onDisconnect: onDisconnect, onMessage: onMessage);
    } else if (address.startsWith("http://") ||
        address.startsWith("https://")) {
      // WebSocket
      return fuiWebSocketServerProtocol(
          address: address, onDisconnect: onDisconnect, onMessage: onMessage);
    } else {
      // TCP or UDS
      return fuiTcpSocketServerProtocol(
          address: address, onDisconnect: onDisconnect, onMessage: onMessage);
    }
  }

  Future connect();
  bool get isLocalConnection;
  int get defaultReconnectIntervalMs;
  void send(String message);
  void disconnect();
}
