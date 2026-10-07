import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/core/widgets/page_header.dart';
import 'package:flutter_application_1/core/selection/selection_cubit.dart';
import 'package:flutter_application_1/core/selection/selection_state.dart';

class OptionListPage extends StatelessWidget {
  final String title;
  final String suggestedTitle;
  final String otherTitle;
  final List<String> suggestedIds;

  const OptionListPage({
    super.key,
    required this.title,
    required this.suggestedTitle,
    required this.otherTitle,
    required this.suggestedIds,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(title: title),
            Expanded(
              child: BlocBuilder<SelectionCubit, SelectionState>(
                builder: (context, state) => switch (state) {
                  SelectionLoading() => const Center(
                      child: CircularProgressIndicator(color: AppColors.accent)),
                  SelectionError(:final message) => Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () => context.read<SelectionCubit>().load(),
                          child: const Text('Retry'),
                        ),
                      ]),
                    ),
                  SelectionLoaded() => _List(
                      state: state,
                      suggestedTitle: suggestedTitle,
                      otherTitle: otherTitle,
                      suggestedIds: suggestedIds,
                    ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final SelectionLoaded state;
  final String suggestedTitle;
  final String otherTitle;
  final List<String> suggestedIds;
  const _List({
    required this.state,
    required this.suggestedTitle,
    required this.otherTitle,
    required this.suggestedIds,
  });

  @override
  Widget build(BuildContext context) {
    final suggested =
        state.options.where((o) => suggestedIds.contains(o.id)).toList();
    final others =
        state.options.where((o) => !suggestedIds.contains(o.id)).toList();

    Widget tile(o) => InkWell(
          onTap: () => context.read<SelectionCubit>().select(o.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(o.label,
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                if (o.id == state.selectedId)
                  const Icon(Icons.check_rounded, size: 18, color: AppColors.accent),
              ],
            ),
          ),
        );

    Widget header(String t) => Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Text(t, style: const TextStyle(color: AppColors.grey, fontSize: 10)),
        );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        if (suggested.isNotEmpty) ...[header(suggestedTitle), ...suggested.map(tile)],
        header(otherTitle),
        ...others.map(tile),
      ],
    );
  }
}