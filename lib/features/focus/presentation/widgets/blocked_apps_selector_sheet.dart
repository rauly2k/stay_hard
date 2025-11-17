import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/data/models/focus_session_model.dart';
import '../providers/focus_providers.dart';

class BlockedAppsSelectorSheet extends ConsumerStatefulWidget {
  const BlockedAppsSelectorSheet({super.key});

  @override
  ConsumerState<BlockedAppsSelectorSheet> createState() =>
      _BlockedAppsSelectorSheetState();
}

class _BlockedAppsSelectorSheetState
    extends ConsumerState<BlockedAppsSelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _tempSelectedApps = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedApps = List.from(ref.read(selectedBlockedAppsProvider));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final installedAppsAsync = ref.watch(installedAppsProvider);
    final appBlockingService = ref.watch(appBlockingServiceProvider);
    final categories = appBlockingService.getCommonAppCategories();

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select Apps to Block',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _tempSelectedApps.clear();
                          });
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_tempSelectedApps.length} apps selected',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search apps...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: installedAppsAsync.when(
                data: (apps) {
                  if (apps.isEmpty) {
                    return _buildEmptyState(theme);
                  }

                  // Filter apps by search query
                  final filteredApps = _searchQuery.isEmpty
                      ? apps
                      : apps
                          .where((app) =>
                              app.name.toLowerCase().contains(_searchQuery) ||
                              app.packageName.toLowerCase().contains(_searchQuery))
                          .toList();

                  if (_searchQuery.isNotEmpty) {
                    return _buildAppList(theme, filteredApps, scrollController);
                  }

                  // Show categories when not searching
                  return _buildCategorizedList(
                    theme,
                    apps,
                    categories,
                    scrollController,
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading apps',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          error.toString(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: _tempSelectedApps.isEmpty
                            ? null
                            : () {
                                ref.read(selectedBlockedAppsProvider.notifier).state =
                                    _tempSelectedApps;
                                Navigator.pop(context);
                              },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Select ${_tempSelectedApps.length} Apps',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategorizedList(
    ThemeData theme,
    List<InstalledAppInfo> apps,
    Map<String, List<String>> categories,
    ScrollController scrollController,
  ) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        // Quick select from categories
        ...categories.entries.map((category) {
          final categoryApps = apps
              .where((app) => category.value.contains(app.packageName))
              .toList();

          if (categoryApps.isEmpty) return const SizedBox.shrink();

          final allSelected = categoryApps.every(
            (app) => _tempSelectedApps.contains(app.packageName),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  category.key,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${categoryApps.length} apps',
                  style: theme.textTheme.bodySmall,
                ),
                trailing: TextButton(
                  onPressed: () {
                    setState(() {
                      if (allSelected) {
                        // Deselect all
                        for (final app in categoryApps) {
                          _tempSelectedApps.remove(app.packageName);
                        }
                      } else {
                        // Select all
                        for (final app in categoryApps) {
                          if (!_tempSelectedApps.contains(app.packageName)) {
                            _tempSelectedApps.add(app.packageName);
                          }
                        }
                      }
                    });
                  },
                  child: Text(allSelected ? 'Deselect All' : 'Select All'),
                ),
              ),
              ...categoryApps.map((app) => _buildAppTile(theme, app)),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),

        // Other apps
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Other Apps',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...apps
            .where((app) => !categories.values
                .any((packages) => packages.contains(app.packageName)))
            .map((app) => _buildAppTile(theme, app))
            .toList(),
      ],
    );
  }

  Widget _buildAppList(
    ThemeData theme,
    List<InstalledAppInfo> apps,
    ScrollController scrollController,
  ) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        return _buildAppTile(theme, apps[index]);
      },
    );
  }

  Widget _buildAppTile(ThemeData theme, InstalledAppInfo app) {
    final isSelected = _tempSelectedApps.contains(app.packageName);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (checked) {
          setState(() {
            if (checked == true) {
              _tempSelectedApps.add(app.packageName);
            } else {
              _tempSelectedApps.remove(app.packageName);
            }
          });
        },
        secondary: _buildAppIcon(app),
        title: Text(
          app.name,
          style: theme.textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          app.packageName,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildAppIcon(InstalledAppInfo app) {
    if (app.icon != null && app.icon!.isNotEmpty) {
      try {
        final bytes = base64Decode(app.icon!);
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: MemoryImage(bytes),
              fit: BoxFit.cover,
            ),
          ),
        );
      } catch (e) {
        // Fallback to default icon
      }
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.apps, size: 24),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.apps_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No Apps Found',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'No installed apps were detected on your device',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
