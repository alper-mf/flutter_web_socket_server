import 'dart:io';
import 'dart:typed_data';

import 'package:socket_server/terminal_service.dart';

Future<void> main() async {
  final socket = await Socket.connect('0.0.0.0', 3000);
  printGreen('Client: Connected to ${socket.remoteAddress.address}:${socket.remotePort}');
  String? userName;

  socket.listen((Uint8List data) {
    final response = String.fromCharCodes(data);
    print('Client $response');
  }, onError: (error) {
    print('Client: $error');
    socket.destroy();
  }, onDone: () {
    print('Client: Server left.');
    socket.destroy();
  });

  do {
    print('Please enter your user name');
    userName = stdin.readLineSync();
  } while (userName == null || userName.isEmpty);

  socket.write(userName);
}
