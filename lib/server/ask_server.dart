import 'dart:io';
import 'dart:async';

Future<String> sendToServer({required String cmd}) async {
  // Configuration
  String serverIp = "<YOUR_IP_ADDRESS>";
  int port = 8080;

  try {
    Socket socket = await Socket.connect(serverIp, port);

    socket.write(cmd);
    Completer<String> completer = Completer();

    socket.listen(
      (data) => completer.complete(String.fromCharCodes(data)),
      onDone: () => socket.close(),
      onError: (error) => completer.completeError(error),
    );
    return await completer.future;
  } catch (e) {
    return "ERROR: $e";
  }
}
