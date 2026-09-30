import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import '../../data/models/genre_model.dart';

class CategoriesList extends StatelessWidget {
  final List<GenreModel> genres;
  final int selectedId;
  final ValueChanged<int> onSelected;
  const CategoriesList({
    super.key,
    required this.genres,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final all = [GenreModel(id: 0, name: 'All'), ...genres];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: all.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final g = all[i];
          final selected = g.id == selectedId;
          return GestureDetector(
            onTap: () => onSelected(g.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.accent.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(g.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: selected ? AppColors.accent : AppColors.grey,
                  )),
            ),
          );
        },
      ),
    );
  }
}