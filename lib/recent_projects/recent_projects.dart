import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/recent_projects/project_link.dart';
import 'package:potato/recent_projects/recent_project_controller.dart';

class RecentProjects extends ConsumerWidget {
  const RecentProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(recentProjectsProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          const Text(
            'Recent projects',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          for (var project in projects) ProjectLink(path: project),
        ],
      ),
    );
  }
}
