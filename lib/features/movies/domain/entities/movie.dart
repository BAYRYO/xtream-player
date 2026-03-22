import 'package:equatable/equatable.dart';

enum ContentType {
  movie,
  series,
  live,
}

class Movie extends Equatable {
  final int id;
  final String title;
  final String? titleTranslated;
  final String? year;
  final String? rating;
  final String? duration;
  final String? plot;
  final String? plotTranslated;
  final String? genre;
  final String? imageUrl;
  final String? backdropUrl;
  final String? streamUrl;
  final String? categoryId;
  final String? categoryName;
  final String? director;
  final String? cast;
  final String? releaseDate;
  final bool favorite;

  const Movie({
    required this.id,
    required this.title,
    this.titleTranslated,
    this.year,
    this.rating,
    this.duration,
    this.plot,
    this.plotTranslated,
    this.genre,
    this.imageUrl,
    this.backdropUrl,
    this.streamUrl,
    this.categoryId,
    this.categoryName,
    this.director,
    this.cast,
    this.releaseDate,
    this.favorite = false,
  });

  Movie copyWith({
    int? id,
    String? title,
    String? titleTranslated,
    String? year,
    String? rating,
    String? duration,
    String? plot,
    String? plotTranslated,
    String? genre,
    String? imageUrl,
    String? backdropUrl,
    String? streamUrl,
    String? categoryId,
    String? categoryName,
    String? director,
    String? cast,
    String? releaseDate,
    bool? favorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      titleTranslated: titleTranslated ?? this.titleTranslated,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      duration: duration ?? this.duration,
      plot: plot ?? this.plot,
      plotTranslated: plotTranslated ?? this.plotTranslated,
      genre: genre ?? this.genre,
      imageUrl: imageUrl ?? this.imageUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      streamUrl: streamUrl ?? this.streamUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      director: director ?? this.director,
      cast: cast ?? this.cast,
      releaseDate: releaseDate ?? this.releaseDate,
      favorite: favorite ?? this.favorite,
    );
  }

  // Quality indicators based on metadata
  bool get is4K => title.toLowerCase().contains('4k') || 
                   title.toLowerCase().contains('uhd') ||
                   (rating != null && double.tryParse(rating!) != null && double.parse(rating!) >= 8.5);

  bool get isHdr => title.toLowerCase().contains('hdr') || 
                    title.toLowerCase().contains('hdr10') ||
                    title.toLowerCase().contains('hdr10+');

  bool get isDolbyVision => title.toLowerCase().contains('dolby vision') || 
                            title.toLowerCase().contains('dolbyvision');

  @override
  List<Object?> get props => [
        id,
        title,
        titleTranslated,
        year,
        rating,
        duration,
        plot,
        plotTranslated,
        genre,
        imageUrl,
        backdropUrl,
        streamUrl,
        categoryId,
        categoryName,
        director,
        cast,
        releaseDate,
        favorite,
      ];
}

class MovieCategory extends Equatable {
  final int id;
  final String name;
  final int? parentId;

  const MovieCategory({
    required this.id,
    required this.name,
    this.parentId,
  });

  @override
  List<Object?> get props => [id, name, parentId];
}
