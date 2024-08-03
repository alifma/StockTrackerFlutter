import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class TokenRepository {
  final WebSocketChannel channel;
  final StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();

  TokenRepository(String url)
      : channel = WebSocketChannel.connect(Uri.parse(url)) {
    channel.stream.listen((message) {
      final data = json.decode(message);
      if (data.containsKey('s')) {
        _controller.add(data);
      }
    });
  }

  Stream<Map<String, dynamic>> get tokenUpdates => _controller.stream;

  void subscribeToTokens(List<String> symbols) {
    final request = {"action": "subscribe", "symbols": symbols.join(",")};
    channel.sink.add(json.encode(request));
  }

  void unsubscribeFromTokens(List<String> symbols) {
    final request = {"action": "unsubscribe", "symbols": symbols.join(",")};
    channel.sink.add(json.encode(request));
  }

  void dispose() {
    _controller.close();
    channel.sink.close();
  }
}
