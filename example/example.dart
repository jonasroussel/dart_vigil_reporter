import 'dart:io';

import 'package:vigil_reporter/src/base.dart';

void main() {
  final reporter = VigilReporter(
    url: 'https://status.pikomit.com',
    token: '9HtpYiTj&q&X8DSRQzSXbAoYp@3SRczgsiaPLeek',
    probeId: 'app',
    nodeId: 'odin',
    replicaId: 'test',
  );

  ProcessSignal.sigint.watch().listen((event) async {
    await reporter.end(flush: true);
    exit(0);
  });
}
