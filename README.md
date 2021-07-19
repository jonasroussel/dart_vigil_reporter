# Dart Vigil Reporter

[![pub package](https://img.shields.io/pub/v/vigil_reporter.svg)](https://pub.dev/packages/vigil_reporter)
[![likes](https://badges.bar/vigil_reporter/likes)](https://pub.dev/packages/vigil_reporter/score)
[![popularity](https://badges.bar/vigil_reporter/popularity)](https://pub.dev/packages/vigil_reporter/score)
[![pub points](https://badges.bar/vigil_reporter/pub%20points)](https://pub.dev/packages/vigil_reporter/score)

**Vigil Reporter for Dart. Used in pair with Vigil, the Microservices Status Page.**

Vigil Reporter is used to actively submit health information to Vigil from your apps. Apps are best monitored via application probes, which are able to report detailed system information such as CPU and RAM load. This lets Vigil show if an application host system is under high load.

**🇫🇷 Crafted in France, Nantes.**

## Who uses it?

<table>
	<tr>
		<td align="center">
			<a href="https://pikomit.com/">
				<img src="https://cdn.pikomit.com/vigil/icon.jpg" width="64" />
			</a>
		</td>
	</tr>
	<tr>
		<td align="center">Pikomit</td>
	</tr>
</table>

_👋 You use vigil_reporter and you want to be listed there? [Email me](mailto:go.jroussel@gmail.com)._

## How to install?

Include `vigil_reporter` in your `pubspec.yaml` dependencies.

```yaml
dependencies:
  vigil_reporter: ^1.2.1
```

Alternatively, you can run `dart pub add vigil_reporter`.

## How to use?

### 1. Create reporter

`vigil_reporter` can be instantiated as such:

```dart
import 'package:vigil_reporter/vigil_reporter.dart';

final vigilReporter = VigilReporter(
  url: 'https://status.example.com',
  token: 'YOUR_TOKEN_SECRET',
  probeId: 'relay',
  nodeId: 'socket-client',
  replicaId: '192.168.1.10',
  interval: 30,
  logger: VigilLogger(),
);
```

### 2. Teardown reporter

If you need to teardown an active reporter, you can use the `end({bool flush = false})` method to unbind it.

```dart
vigilReporter.end(flush: false)
  .then(() {
    // Handle end there
  }).catchError(() {
    // Handle error there
  });
```

## What is Vigil?

ℹ️ **Wondering what Vigil is?** Check out **[valeriansaliou/vigil](https://github.com/valeriansaliou/vigil)**.
