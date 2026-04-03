import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AdminDataGrid extends StatelessWidget {
  const AdminDataGrid({
    super.key,
    required this.columns,
    required this.source,
    this.rowHeight = 64,
    this.headerRowHeight = 46,
    this.columnWidthMode = ColumnWidthMode.fill,
    this.allowSorting = true,
  });

  final List<GridColumn> columns;
  final DataGridSource source;
  final double rowHeight;
  final double headerRowHeight;
  final ColumnWidthMode columnWidthMode;
  final bool allowSorting;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: cs.primaryContainer.withValues(alpha: 0.34),
        gridLineColor: cs.outlineVariant.withValues(alpha: 0.22),
        selectionColor: cs.primary.withValues(alpha: 0.08),
        currentCellStyle: DataGridCurrentCellStyle(
          borderColor: Colors.transparent,
          borderWidth: 0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SfDataGrid(
            source: source,
            columns: columns,
            rowHeight: rowHeight,
            headerRowHeight: headerRowHeight,
            columnWidthMode: columnWidthMode,
            allowSorting: allowSorting,
            allowColumnsResizing: true,
            gridLinesVisibility: GridLinesVisibility.horizontal,
            headerGridLinesVisibility: GridLinesVisibility.horizontal,
            selectionMode: SelectionMode.none,
            shrinkWrapRows: true,
          ),
        ),
      ),
    );
  }
}

class AdminGridHeaderCell extends StatelessWidget {
  const AdminGridHeaderCell(
    this.label, {
    super.key,
    this.alignment = Alignment.center,
  });

  final String label;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 14.5,
      height: 1.25,
    );

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(label, overflow: TextOverflow.ellipsis, style: headerStyle),
    );
  }
}

class AdminGridCell extends StatelessWidget {
  const AdminGridCell({
    super.key,
    required this.child,
    this.alignment = Alignment.centerRight,
    this.padding,
  });

  final Widget child;
  final Alignment alignment;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: child,
    );
  }
}

class AdminGridText extends StatelessWidget {
  const AdminGridText(
    this.value, {
    super.key,
    this.maxLines = 1,
    this.style,
    this.color,
    this.textAlign,
  });

  final String value;
  final int maxLines;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: 15,
      height: 1.4,
      fontWeight: FontWeight.w500,
    );
    return Text(
      value,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: (style ?? baseStyle)?.copyWith(color: color),
    );
  }
}

class AdminGridSubText extends StatelessWidget {
  const AdminGridSubText(
    this.value, {
    super.key,
    this.maxLines = 1,
    this.color,
  });

  final String value;
  final int maxLines;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      value,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 14.5,
        height: 1.35,
        fontWeight: FontWeight.w500,
        color: color ?? cs.onSurfaceVariant,
      ),
    );
  }
}

class AdminGridBadge extends StatelessWidget {
  const AdminGridBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? cs.primaryContainer.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 14.5,
          color: foregroundColor ?? cs.onSurface,
        ),
      ),
    );
  }
}

class AdminGridActionButton extends StatelessWidget {
  const AdminGridActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.filled = false,
    this.foregroundColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tint = foregroundColor ?? cs.primary;
    final sharedTextStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 14.25,
    );
    final ButtonStyle style = ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(filled ? cs.onPrimary : tint),
      backgroundColor: WidgetStatePropertyAll(
        filled ? tint : Colors.transparent,
      ),
      side: WidgetStatePropertyAll(
        filled ? null : BorderSide(color: tint.withValues(alpha: 0.28)),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      minimumSize: const WidgetStatePropertyAll(Size(0, 36)),
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      textStyle: WidgetStatePropertyAll(sharedTextStyle),
    );

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(label)],
    );

    if (filled) {
      return FilledButton(onPressed: onPressed, style: style, child: child);
    }

    return OutlinedButton(onPressed: onPressed, style: style, child: child);
  }
}

class AdminGridIconAction extends StatelessWidget {
  const AdminGridIconAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: (color ?? cs.primary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 17, color: color ?? cs.primary),
        ),
      ),
    );
  }
}

class AdminGridActionBar extends StatelessWidget {
  const AdminGridActionBar({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.start,
  });

  final List<Widget> children;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 8,
      spacing: 8,
      children: children,
    );
  }
}
