import 'dart:io';
import 'dart:typed_data';

import 'package:socket_server/terminal_service.dart';

Future<void> main() async {
  final InternetAddress ip = InternetAddress.anyIPv4;
  final ServerSocket server = await ServerSocket.bind(ip, 3000);
  print('Server is running on ${ip.address}:${server.port}');
  server.listen((Socket event) {
    handleConnection(event);
  });
}

List<Socket> clients = [];

void handleConnection(Socket client) {
  printGreen('Server: Connection from ${client.remoteAddress.address}:${client.remotePort}');
  client.listen(
    (Uint8List data) {
      final message = String.fromCharCodes(data);

      for (var c in clients) {
        c.write("Server: $message joined the party");
      }

      clients.add(client);
      client.write("Server: You are logged in as $message ");
    },
  );
  (error) {
    print(error);
    client.close();
  };
  () {
    printRed('ServerClient left');
    client.close();
  };
}
