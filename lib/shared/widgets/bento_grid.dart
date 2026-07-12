import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:fitkarma/core/theme/app_spacing.dart';

/// Wrapper class to represent an item in a [BentoGrid].
class BentoGridItem {
  final Widget child;
  final int columnSpan;
  final int rowSpan;

  const BentoGridItem({
    required this.child,
    this.columnSpan = 1,
    this.rowSpan = 1,
  });
}

/// A responsive Bento Grid layout primitive matching spacing configurations.
class BentoGrid extends StatelessWidget {
  final List<BentoGridItem> items;
  
  /// The number of columns. If null, automatically selects columns based on layout width:
  /// - Width >= 950: 4 columns
  /// - Width >= 600: 2 columns
  /// - Width < 600: 1 column
  final int? crossAxisCount;
  
  /// Spacing between grid elements
  final double spacing;
  
  /// Height of a single row block
  final double rowHeight;

  const BentoGrid({
    super.key,
    required this.items,
    this.crossAxisCount,
    this.spacing = AppSpacing.bentoGap,
    this.rowHeight = 135.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        
        final int cols;
        if (crossAxisCount != null) {
          cols = crossAxisCount!;
        } else {
          if (width >= 950) {
            cols = 4;
          } else if (width >= 600) {
            cols = 2;
          } else {
            cols = 1;
          }
        }

        final double cellWidth = (width - (spacing * (cols - 1))) / cols;
        
        final List<List<bool>> occupied = [];
        final List<Widget> positionedWidgets = [];
        int maxRowReached = 0;

        for (var item in items) {
          final int colSpan = (cols == 1) ? 1 : item.columnSpan.clamp(1, cols);
          final int rowSpan = (cols == 1 && item.columnSpan > 1 && item.rowSpan == 1) 
              ? 1 
              : item.rowSpan.clamp(1, 100);

          int targetRow = 0;
          int targetCol = 0;
          bool found = false;

          while (!found) {
            while (occupied.length <= targetRow) {
              occupied.add(List.generate(cols, (_) => false));
            }

            if (targetCol + colSpan <= cols) {
              bool fits = true;
              
              for (int r = 0; r < rowSpan; r++) {
                while (occupied.length <= targetRow + r) {
                  occupied.add(List.generate(cols, (_) => false));
                }
                for (int c = 0; c < colSpan; c++) {
                  if (occupied[targetRow + r][targetCol + c]) {
                    fits = false;
                    break;
                  }
                }
                if (!fits) break;
              }

              if (fits) {
                for (int r = 0; r < rowSpan; r++) {
                  for (int c = 0; c < colSpan; c++) {
                    occupied[targetRow + r][targetCol + c] = true;
                  }
                }
                found = true;
                break;
              }
            }

            targetCol++;
            if (targetCol >= cols) {
              targetCol = 0;
              targetRow++;
            }
          }

          final double left = targetCol * (cellWidth + spacing);
          final double top = targetRow * (rowHeight + spacing);
          final double itemWidth = colSpan * cellWidth + (colSpan - 1) * spacing;
          final double itemHeight = rowSpan * rowHeight + (rowSpan - 1) * spacing;

          maxRowReached = math.max(maxRowReached, targetRow + rowSpan);

          positionedWidgets.add(
            Positioned(
              left: left,
              top: top,
              width: itemWidth,
              height: itemHeight,
              child: item.child,
            ),
          );
        }

        final double totalHeight = maxRowReached * rowHeight + (maxRowReached - 1).clamp(0, 1000000) * spacing;

        return SizedBox(
          height: totalHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: positionedWidgets,
          ),
        );
      },
    );
  }
}
