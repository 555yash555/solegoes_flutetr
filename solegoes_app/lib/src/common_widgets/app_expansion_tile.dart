import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class AppExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;

  final bool? isExpanded;

  const AppExpansionTile({
    super.key,
    required this.title,
    this.children = const [],
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.icon,
    this.padding,
    this.isExpanded,
  });

  @override
  State<AppExpansionTile> createState() => _AppExpansionTileState();
}

class _AppExpansionTileState extends State<AppExpansionTile> {
  late bool _isExpanded;

  bool get _currentExpandedState => widget.isExpanded ?? _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _handleTap() {
    if (widget.isExpanded != null) {
      widget.onExpansionChanged?.call(!widget.isExpanded!);
    } else {
      setState(() {
        _isExpanded = !_isExpanded;
      });
      widget.onExpansionChanged?.call(_isExpanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.surfaceHover,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _currentExpandedState ? AppColors.borderFocus : AppColors.borderGlass,
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 16),
                  ],
                  Expanded(child: widget.title),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: _currentExpandedState ? 0.5 : 0,
                    child: Icon(
                      LucideIcons.chevronDown,
                      size: 20,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            // Expandable content
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _currentExpandedState
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppRadius.lg),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: AppColors.borderGlass),
                    const SizedBox(height: 8),
                    ...widget.children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
