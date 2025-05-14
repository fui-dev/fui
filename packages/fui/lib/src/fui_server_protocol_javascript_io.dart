import 'fui_server_protocol.dart';

class fuiJavaScriptServerProtocol implements fuiServerProtocol {
  final String address;
  final fuiServerProtocolOnMessageCallback onMessage;
  final fuiServerProtocolOnDisconnectCallback onDisconnect;

  fuiJavaScriptServerProtocol(
      {required this.address,
      required this.onDisconnect,
      required this.onMessage});

  @override
  connect() async {}

  @override
  bool get isLocalConnection => true;

  @override
  int get defaultReconnectIntervalMs => 10;

  @override
  void send(String message) {}

  @override
  void disconnect() {}
}
