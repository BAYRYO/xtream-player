import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/movie.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<MovieBloc>()..add(MovieCategoriesRequested()),
      child: const MoviesPageContent(),
    );
  }
}

class MoviesPageContent extends StatefulWidget {
  const MoviesPageContent({super.key});

  @override
  State<MoviesPageContent> createState() => _MoviesPageContentState();
}

class _MoviesPageContentState extends State<MoviesPageContent> {
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
                  hintText: 'Search movies...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppTheme.textHint),
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
                onChanged: (query) {
                  context.read<MovieBloc>().add(MovieSearchRequested(query));
                },
              )
            : const Text('Movies'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<MovieBloc>().add(MovieCategoriesRequested());
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.status == MovieStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == MovieStatus.error) {
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
                      context.read<MovieBloc>().add(MovieCategoriesRequested());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show search results
          if (state.isSearching) {
            if (state.movies.isEmpty) {
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

            return _MovieGrid(movies: state.movies);
          }

          // Show categories or movies by category
          if (state.currentCategoryId == null) {
            return _CategoryGrid(
              categories: state.categories,
              onCategorySelected: (id, name) {
                context.read<MovieBloc>().add(
                      MovieListRequested(categoryId: id, categoryName: name),
                    );
              },
            );
          }

          // Show movies in category
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
                        context.read<MovieBloc>().add(MovieCategoriesRequested());
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.currentCategoryName ?? 'Movies',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              // Movies grid
              Expanded(
                child: state.movies.isEmpty
                    ? const Center(child: Text('No movies found'))
                    : _MovieGrid(movies: state.movies),
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
          gradient: AppTheme.primaryGradient,
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

class _MovieGrid extends StatelessWidget {
  final List<dynamic> movies;

  const _MovieGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _MovieCard(movie: movie);
      },
    );
  }
}

class _MovieCard extends StatelessWidget {
  final dynamic movie;

  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    // Get image URL safely
    String? imageUrl;
    if (movie is Movie) {
      imageUrl = movie.imageUrl;
    } else if (movie is Map) {
      imageUrl = movie['stream_icon'] ?? movie['cover'] ?? movie['image_url'];
    }
    
    // Get title safely
    String title = '';
    if (movie is Movie) {
      title = movie.title;
    } else if (movie is Map) {
      title = movie['name'] ?? movie['title'] ?? '';
    }
    
    // Get rating for quality badges
    String? rating;
    if (movie is Movie) {
      rating = movie.rating;
    } else if (movie is Map) {
      rating = movie['rating']?.toString();
    }
    
    final titleLower = title.toLowerCase();
    final is4K = titleLower.contains('4k') || titleLower.contains('uhd');
    final isHdr = titleLower.contains('hdr') || titleLower.contains('hdr10') || titleLower.contains('hdr10+');
    final isDolbyVision = titleLower.contains('dolby vision') || titleLower.contains('dolbyvision');

    return GestureDetector(
      onTap: () {
        // Navigate to movie details
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
                  imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _PlaceholderPoster(),
                        )
                      : _PlaceholderPoster(),
                  // Quality badges
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      children: [
                        if (is4K)
                          _QualityBadge(label: '4K', color: AppTheme.uhdColor),
                        if (isDolbyVision)
                          _QualityBadge(label: 'DV', color: AppTheme.dolbyVisionColor),
                        if (isHdr && !isDolbyVision)
                          _QualityBadge(label: 'HDR', color: AppTheme.hdr10Color),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (movie.year != null)
            Text(
              movie.year!,
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
        child: Icon(Icons.movie, size: 48, color: AppTheme.textHint),
      ),
    );
  }
}

class _QualityBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _QualityBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
