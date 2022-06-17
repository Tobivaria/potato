import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RecentProjectRepository {
  // recently opened projects
  Future<List<String>?> getRecentProjects();
  Future<void> setRecentProjects(List<String> val);
}

final Provider<RecentProjectsRepo> recentProjectsRepositoryProvider =
    Provider<RecentProjectsRepo>((ProviderRef<RecentProjectsRepo> ref) {
  return RecentProjectsRepo();
});

class RecentProjectsRepo implements RecentProjectRepository {
  //##############################
  // recent projects
  //##############################

  static const String _recent = 'recentProjects';

  @override
  Future<List<String>?> getRecentProjects() {
    return _getStringList(_recent);
  }

  @override
  Future<void> setRecentProjects(List<String> val) {
    return _setStringList(_recent, val);
  }

  Future<List<String>?> _getStringList(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(key);
  }

  Future<void> _setStringList(String key, List<String> value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(key, value);
  }
}
