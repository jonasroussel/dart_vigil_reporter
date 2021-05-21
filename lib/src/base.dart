import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:system_resources/system_resources.dart';

class VigilReporter {
  VigilReporter({
    required this.url,
    required this.token,
    required this.probeId,
    required this.nodeId,
    required this.replicaId,
    this.interval = 30,
  }) {
    if (url.endsWith('/')) url = url.substring(0, url.length - 1);

    _scheduleNextPoll(Duration(seconds: 10));
  }

  String url;
  String token;
  String probeId;
  String nodeId;
  String replicaId;
  int interval;

  Timer? _pollTicker;

  Future<void> end({bool flush = false}) async {
    _pollTicker?.cancel();

    if (flush) {
      final uri = Uri.parse(
        '$url/reporter/$probeId/$nodeId/$replicaId',
      );
      final auth = base64.encode(utf8.encode(':$token'));

      await http.delete(
        uri,
        headers: {
          'Host': uri.host,
          'Authorization': 'Basic $auth',
        },
      ).timeout(Duration(seconds: 5));
    }
  }

  void _scheduleNextPoll(Duration duration) {
    _pollTicker ??= Timer(duration, () {
      _pollTicker = null;

      _dispatchPollRequest();
    });
  }

  void _dispatchPollRequest() async {
    final cpu = SystemResources.cpuLoadAvg();
    final ram = SystemResources.memUsage();

    final uri = Uri.parse(
      '$url/reporter/$probeId/$nodeId',
    );
    final body = {
      'replica': replicaId,
      'interval': interval,
      'load': {'cpu': cpu, 'ram': ram},
    };
    final auth = base64.encode(utf8.encode(':$token'));

    await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Host': uri.host,
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic $auth',
      },
    ).timeout(Duration(seconds: 10));

    _scheduleNextPoll(Duration(seconds: interval));
  }
}
