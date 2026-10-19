import 'package:connectivity_plus/connectivity_plus.dart';

/// Reports whether the device has any network interface up. This doesn't
/// prove the server is reachable; a failed sync handles that case.
abstract interface class ConnectivityService {
  Future<bool> isOnline();

  Stream<bool> get onlineChanges;
}

class ConnectivityPlusService implements ConnectivityService {
  ConnectivityPlusService([Connectivity? connectivity]) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _hasNetwork(List<ConnectivityResult> results) => results.any((r) => r != ConnectivityResult.none);

  @override
  Future<bool> isOnline() async => _hasNetwork(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onlineChanges => _connectivity.onConnectivityChanged.map(_hasNetwork).distinct();
}
