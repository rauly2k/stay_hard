import 'package:flutter/material.dart';

enum FocusMode {
  pomodoro,
  appLimits,
}

class FocusModeSelector extends StatelessWidget {
  final FocusMode selectedMode;
  final Function(FocusMode) onModeChanged;

  const FocusModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildModeButton(
              context,
              mode: FocusMode.pomodoro,
              label: 'Pomodoro Timer',
              icon: Icons.timer,
              isSelected: selectedMode == FocusMode.pomodoro,
            ),
          ),
          Expanded(
            child: _buildModeButton(
              context,
              mode: FocusMode.appLimits,
              label: 'App Limits',
              icon: Icons.app_blocking,
              isSelected: selectedMode == FocusMode.appLimits,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context, {
    required FocusMode mode,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onModeChanged(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
