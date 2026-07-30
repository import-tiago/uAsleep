import 'package:package_info_plus/package_info_plus.dart';

abstract interface class AppInfoProvider {
  Future<String> version();
}

class PackageAppInfoProvider implements AppInfoProvider {
  const PackageAppInfoProvider();

  @override
  Future<String> version() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return '${info.version}+${info.buildNumber}';
  }
}
