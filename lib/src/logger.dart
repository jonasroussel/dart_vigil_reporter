import 'dart:io';
import 'dart:convert';

class VigilLogger {
  /// Vigil Logger
  VigilLogger({
    this.infoPrefix = '[Vigil Reporter] [INFO]',
    this.warnPrefix = '[Vigil Reporter] [WARN]',
    this.errorPrefix = '[Vigil Reporter] [ERROR]',
  });

  /// Prefix for `info` logs
  final String infoPrefix;

  /// Prefix for `warning` logs
  final String warnPrefix;

  /// Prefix for `error` logs
  final String errorPrefix;

  /// Write `info` log into `stdout`
  void info(String msg, [Object? obj]) {
    stdout.write('$infoPrefix $msg');
    stdout.write(obj != null ? ' ${_encodeObject(obj)}\n' : '\n');
  }

  /// Write `warn` log into `stdout`
  void warn(String msg, [Object? obj]) {
    stdout.write('$warnPrefix $msg');
    stdout.write(obj != null ? ' ${_encodeObject(obj)}\n' : '\n');
  }

  /// Write `error` log into `stderr`
  void error(String msg, [Object? obj]) {
    stderr.write('$errorPrefix $msg\n');
    stderr.write(obj != null ? ' ${_encodeObject(obj)}\n' : '\n');
  }

  String _encodeObject(Object obj) {
    return JsonEncoder.withIndent('  ').convert(obj);
  }
}
