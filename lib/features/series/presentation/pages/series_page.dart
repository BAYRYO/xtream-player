import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/series_bloc.dart';
import '../bloc/series_event.dart';
import '../bloc/series_state.dart';

class SeriesPage extends StatelessWidget {
  const SeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SeriesBloc>()..add(SeriesCategoriesRequested()),
      child: const SeriesPageContent(),
    );
  }
}

class SeriesPageContent extends StatefulWidget {
  const SeriesPageContent({super.key});

  @override
  State<SeriesPageContent> createState() => _SeriesPageContentState();
}

class _SeriesPageContentState extends State<SeriesPageContent> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search series...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppTheme.textHint),
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
                onChanged: (query) {
                  context.read<SeriesBloc>().add(SeriesSearchRequested(query));
                },
              )
            : const Text('Series'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<SeriesBloc>().add(SeriesCategoriesRequested());
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<SeriesBloc, SeriesState>(
        builder: (context, state) {
          if (state.status == SeriesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SeriesStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'An error occurred'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SeriesBloc>().add(SeriesCategoriesRequested());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show search results
          if (state.isSearching) {
            if (state.seriesList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 48, color: AppTheme.textHint),
                    const SizedBox(height: 16),
                    Text(
                      'No results for "${state.searchQuery}"',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              );
            }

            return _SeriesGrid(seriesList: state.seriesList);
          }

          // Show categories or series by category
          if (state.currentCategoryId == null) {
            return _CategoryGrid(
              categories: state.categories,
              onCategorySelected: (id, name) {
                context.read<SeriesBloc>().add(
                      SeriesListRequested(categoryId: id, categoryName: name),
                    );
              },
            );
          }

          // Show series in category
          return Column(
            children: [
              // Category header with back button
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        context.read<SeriesBloc>().add(SeriesCategoriesRequested());
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.currentCategoryName ?? 'Series',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              // Series grid
              Expanded(
                child: state.seriesList.isEmpty
                    ? const Center(child: Text('No series found'))
                    : _SeriesGrid(seriesList: state.seriesList),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final List<dynamic> categories;
  final Function(String id, String name) onCategorySelected;

  const _CategoryGrid({
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryCard(
          name: category.name,
          onTap: () => onCategorySelected(
            category.id.toString(),
            category.name,
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _CategoryCard({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF03A9F4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

class _SeriesGrid extends StatelessWidget {
  final List<dynamic> seriesList;

  const _SeriesGrid({required this.seriesList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: seriesList.length,
      itemBuilder: (context, index) {
        final series = seriesList[index];
        return _SeriesCard(series: series);
      },
    );
  }
}

class _SeriesCard extends StatelessWidget {
  final dynamic series;

  const _SeriesCard({required this.series});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to series details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Poster
                  series.imageUrl != null
                      ? Image.network(
                          series.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _PlaceholderPoster(),
                        )
                      : _PlaceholderPoster(),
                  // Season count badge
                  if (series.seasons != null && series.seasons.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${series.seasons.length} Seasons',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            series.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (series.year != null)
            Text(
              series.year!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
        ],
      ),
    );
  }
}

class _PlaceholderPoster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.cardColor,
      child: const Center(
        child: Icon(Icons.tv, size: 48, color: AppTheme.textHint),
      ),
    );
  }
}
