import 'package:equatable/equatable.dart';

class Series extends Equatable {
  final int id;
  final String name;
  final String? nameTranslated;
  final String? year;
  final String? rating;
  final String? plot;
  final String? plotTranslated;
  final String? genre;
  final String? imageUrl;
  final String? backdropUrl;
  final String? categoryId;
  final String? categoryName;
  final String? cast;
  final String? director;
  final String? releaseDate;
  final List<Season>? seasons;
  final bool favorite;

  const Series({
    required this.id,
    required this.name,
    this.nameTranslated,
    this.year,
    this.rating,
    this.plot,
    this.plotTranslated,
    this.genre,
    this.imageUrl,
    this.backdropUrl,
    this.categoryId,
    this.categoryName,
    this.cast,
    this.director,
    this.releaseDate,
    this.seasons,
    this.favorite = false,
  });

  Series copyWith({
    int? id,
    String? name,
    String? nameTranslated,
    String? year,
    String? rating,
    String? plot,
    String? plotTranslated,
    String? genre,
    String? imageUrl,
    String? backdropUrl,
    String? categoryId,
    String? categoryName,
    String? cast,
    String? director,
    String? releaseDate,
    List<Season>? seasons,
    bool? favorite,
  }) {
    return Series(
      id: id ?? this.id,
      name: name ?? this.name,
      nameTranslated: nameTranslated ?? this.nameTranslated,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      plot: plot ?? this.plot,
      plotTranslated: plotTranslated ?? this.plotTranslated,
      genre: genre ?? this.genre,
      imageUrl: imageUrl ?? this.imageUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      cast: cast ?? this.cast,
      director: director ?? this.director,
      releaseDate: releaseDate ?? this.releaseDate,
      seasons: seasons ?? this.seasons,
      favorite: favorite ?? this.favorite,
    );
  }

  // Quality indicators
  bool get is4K => name.toLowerCase().contains('4k') || 
                   name.toLowerCase().contains('uhd');

  bool get isHdr => name.toLowerCase().contains('hdr') || 
                    name.toLowerCase().contains('hdr10') ||
                    name.toLowerCase().contains('hdr10+');

  bool get isDolbyVision => name.toLowerCase().contains('dolby vision') || 
                            name.toLowerCase().contains('dolbyvision');

  @override
  List<Object?> get props => [
        id,
        name,
        nameTranslated,
        year,
        rating,
        plot,
        plotTranslated,
        genre,
        imageUrl,
        backdropUrl,
        categoryId,
        categoryName,
        cast,
        director,
        releaseDate,
        seasons,
        favorite,
      ];
}

class Season extends Equatable {
  final int id;
  final int seasonNumber;
  final String? name;
  final String? imageUrl;
  final List<Episode>? episodes;

  const Season({
    required this.id,
    required this.seasonNumber,
    this.name,
    this.imageUrl,
    this.episodes,
  });

  Season copyWith({
    int? id,
    int? seasonNumber,
    String? name,
    String? imageUrl,
    List<Episode>? episodes,
  }) {
    return Season(
      id: id ?? this.id,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      episodes: episodes ?? this.episodes,
    );
  }

  @override
  List<Object?> get props => [id, seasonNumber, name, imageUrl, episodes];
}

class Episode extends Equatable {
  final int id;
  final int episodeNumber;
  final String title;
  final String? description;
  final String? duration;
  final String? imageUrl;
  final String? streamUrl;
  final int seasonId;

  const Episode({
    required this.id,
    required this.episodeNumber,
    required this.title,
    this.description,
    this.duration,
    this.imageUrl,
    this.streamUrl,
    required this.seasonId,
  });

  Episode copyWith({
    int? id,
    int? episodeNumber,
    String? title,
    String? description,
    String? duration,
    String? imageUrl,
    String? streamUrl,
    int? seasonId,
  }) {
    return Episode(
      id: id ?? this.id,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      streamUrl: streamUrl ?? this.streamUrl,
      seasonId: seasonId ?? this.seasonId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        episodeNumber,
        title,
        description,
        duration,
        imageUrl,
        streamUrl,
        seasonId,
      ];
}

class SeriesCategory extends Equatable {
  final int id;
  final String name;
  final int? parentId;

  const SeriesCategory({
    required this.id,
    required this.name,
    this.parentId,
  });

  @override
  List<Object?> get props => [id, name, parentId];
}
