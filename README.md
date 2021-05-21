# Vigil Reporter

[![pub package](https://img.shields.io/pub/v/vigil_reporter.svg)](https://pub.dev/packages/vigil_reporter)

**Vigil Reporter for Dart. Used in pair with Vigil, the Microservices Status Page.**

Vigil Reporter is used to actively submit health information to Vigil from your apps. Apps are best monitored via application probes, which are able to report detailed system information such as CPU and RAM load. This lets Vigil show if an application host system is under high load.

## Import

```dart
import 'package:vigil_reporter/vigil_reporter.dart';
```

## Usage

### 1. Create reporter

`vigil_reporter` can be instantiated as such:

```dart
final reporter = VigilReporter(
  url: 'https://status.example.com',
  token: 'YOUR_TOKEN_SECRET',
  probeId: 'relay',
  nodeId: 'socket-client',
  replicaId: '192.168.1.10',
  interval: 30,
);
```

### 2. Teardown reporter

If you need to teardown an active reporter, you can use the `end(...)` method to unbind it.

```dart
reporter.end(flush: true)
  .then(() { ... })
  .catch(() { ... });
```

## What is Vigil?

ℹ️ **Wondering what Vigil is?** Check out **[valeriansaliou/vigil](https://github.com/valeriansaliou/vigil)**.
