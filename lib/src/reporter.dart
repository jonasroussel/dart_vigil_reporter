import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:system_resources/system_resources.dart';

import 'logger.dart';

class VigilReporter {
  /// Vigil Reporter
  VigilReporter({
    required this.url,
    required this.token,
    required this.probeId,
    required this.nodeId,
    required this.replicaId,
    this.interval = 30,
    this.logger,
  }) {
    if (url.endsWith('/')) url = url.substring(0, url.length - 1);

    _scheduleNextPoll(Duration(seconds: 10), false);
  }

  /// `page_url` from Vigil `config.cfg`
  String url;

  /// `reporter_token` from Vigil `config.cfg`
  final String token;

  /// Probe ID containing the parent Node for Replica
  final String probeId;

  /// Node ID containing Replica
  final String nodeId;

  /// Unique Replica ID for instance (ie. your IP on the LAN)
  final String replicaId;

  /// Reporting interval (in seconds; defaults to 30 seconds if not set)
  final int interval;

  /// Logger if you need to debug issues
  final VigilLogger? logger;

  Timer? _pollTicker;

  /// Stop polling requests
  ///
  /// `flush` Whether to flush replica from Vigil upon teardown
  Future<void> end({bool flush = false}) async {
    _pollTicker?.cancel();

    if (flush) {
      await _dispatchFlushRequest();
    }
  }

  void _scheduleNextPoll(Duration duration, bool failed) {
    if (failed) {
      duration = Duration(milliseconds: duration.inMilliseconds ~/ 2);
      logger?.warn(
          'Last request failed, scheduled next request sooner in ${duration.inSeconds} secs');
    } else {
      logger?.info('Scheduled next request in ${duration.inSeconds} secs');
    }

    _pollTicker ??= Timer(duration, () async {
      _pollTicker = null;

      logger?.info(
          'Executing next request now (after wait of ${duration.inSeconds} secs)');

      await _dispatchPollRequest();
    });
  }

  Future<void> _dispatchPollRequest() async {
    final cpu = SystemResources.cpuLoadAvg();
    final ram = SystemResources.memUsage();

    final uri = Uri.parse(
      '$url/reporter/$probeId/$nodeId',
    );
    final rawData = {
      'replica': replicaId,
      'interval': interval,
      'load': {'cpu': cpu, 'ram': ram},
    };
    final auth = base64.encode(utf8.encode(':$token'));

    logger?.info('Built request raw data', rawData);

    final body = jsonEncode(rawData);

    logger?.info('Will dispatch request', {
      'host': uri.host,
      'port': uri.port,
      'path': uri.path,
      'method': 'POST',
      'auth': ':$token',
      'timeout': 10000,
      'headers': {
        'Content-Type': 'application/json; charset=utf-8',
        'Content-Length': body.length,
      }
    });

    try {
      final res = await http.post(
        uri,
        body: body,
        headers: {
          'Host': uri.host,
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Basic $auth',
        },
      ).timeout(Duration(seconds: 10));

      if (res.statusCode >= 400) {
        throw StateError('${res.statusCode} ${res.reasonPhrase}');
      }

      logger?.info('Request succeeded', rawData);

      _scheduleNextPoll(Duration(seconds: interval), false);
    } catch (ex) {
      logger?.error('Failed dispatching request', ex.toString());

      _scheduleNextPoll(Duration(seconds: interval), true);
    }
  }

  Future<void> _dispatchFlushRequest() async {
    final uri = Uri.parse(
      '$url/reporter/$probeId/$nodeId/$replicaId',
    );
    final auth = base64.encode(utf8.encode(':$token'));

    logger?.info('Will dispatch request', {
      'host': uri.host,
      'port': uri.port,
      'path': uri.path,
      'method': 'DELETE',
      'auth': ':$token',
      'timeout': 5000,
    });

    try {
      final res = await http.delete(
        uri,
        headers: {
          'Host': uri.host,
          'Authorization': 'Basic $auth',
        },
      ).timeout(Duration(seconds: 5));

      if (res.statusCode >= 400) {
        throw StateError('${res.statusCode} ${res.reasonPhrase}');
      }

      logger?.info('Request succeeded');
    } catch (ex) {
      logger?.error('Failed dispatching request', ex.toString());

      rethrow;
    }
  }
}
