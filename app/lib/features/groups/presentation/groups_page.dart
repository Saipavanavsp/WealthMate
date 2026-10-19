import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
import 'groups_cubit.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navGroups)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewGroup(context),
        icon: const Icon(Icons.group_add_outlined),
        label: Text(l10n.newGroup),
      ),
      body: BlocConsumer<GroupsCubit, GroupsState>(
        listenWhen: (p, n) => n.failure != null && p.failure != n.failure,
        listener: (context, state) => showMessage(context, state.failure!.message),
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          if (state.groups.isEmpty) return EmptyState(icon: Icons.groups_outlined, message: l10n.noGroups);
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
            itemCount: state.groups.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final summary = state.groups[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () => context.push('/groups/${summary.group.id}'),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(summary.group.name.characters.first.toUpperCase()),
                  ),
                  title: Text(summary.group.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(l10n.membersCount(summary.memberCount)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(l10n.totalSpent, style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        formatMoney(context, summary.totalSpent),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showNewGroup(BuildContext context) {
    final cubit = context.read<GroupsCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(value: cubit, child: const _NewGroupSheet()),
    );
  }
}

class _NewGroupSheet extends StatefulWidget {
  const _NewGroupSheet();

  @override
  State<_NewGroupSheet> createState() => _NewGroupSheetState();
}

class _NewGroupSheetState extends State<_NewGroupSheet> {
  final _name = TextEditingController();
  final _member = TextEditingController();
  final _members = <String>['You'];

  @override
  void dispose() {
    _name.dispose();
    _member.dispose();
    super.dispose();
  }

  void _addMember() {
    final name = _member.text.trim();
    if (name.isEmpty || _members.contains(name)) return;
    setState(() => _members.add(name));
    _member.clear();
  }

  Future<void> _create() async {
    final router = GoRouter.of(context);
    final navigator = Navigator.of(context);
    final id = await context.read<GroupsCubit>().create(_name.text, _members);
    if (id == null) return;
    navigator.pop();
    await router.push('/groups/$id');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.newGroup, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.groupName),
          ),
          const SizedBox(height: 16),
          Text(l10n.members, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in _members)
                InputChip(
                  label: Text(m),
                  onDeleted: _members.length > 1 ? () => setState(() => _members.remove(m)) : null,
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _member,
            textCapitalization: TextCapitalization.words,
            onSubmitted: (_) => _addMember(),
            decoration: InputDecoration(
              labelText: l10n.memberNameHint,
              suffixIcon: IconButton(
                tooltip: l10n.addMember,
                icon: const Icon(Icons.person_add_alt),
                onPressed: _addMember,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _create, child: Text(l10n.save)),
        ],
      ),
    );
  }
}
