import 'dart:io';

import 'package:vigil_reporter/vigil_reporter.dart';

void main() {
  final vigilReporter = VigilReporter(
    url: 'https://status.example.com',
    token: 'YOUR_TOKEN_SECRET',
    probeId: 'relay',
    nodeId: 'socket-client',
    replicaId: '192.168.1.10',
    interval: 30,
    logger: VigilLogger(),
  );

  ProcessSignal.sigint.watch().listen((event) async {
    await vigilReporter.end(flush: true);
    exit(0);
  });
}
