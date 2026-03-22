import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    super.titleTranslated,
    super.year,
    super.rating,
    super.duration,
    super.plot,
    super.plotTranslated,
    super.genre,
    super.imageUrl,
    super.backdropUrl,
    super.streamUrl,
    super.categoryId,
    super.categoryName,
    super.director,
    super.cast,
    super.releaseDate,
    super.favorite,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json, {String? serverUrl}) {
    // Xtream API format
    return MovieModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      titleTranslated: json['titleTranslated'] ?? json['title'],
      year: json['year']?.toString(),
      rating: json['rating']?.toString(),
      duration: json['duration']?.toString(),
      plot: json['plot'] ?? json['description'],
      plotTranslated: json['plot'],
      genre: json['genre'] ?? json['category'],
      imageUrl: json['image_url'] != null 
          ? '$serverUrl${json['image_url']}' 
          : json['cover'],
      backdropUrl: json['backdrop_path'] != null 
          ? '$serverUrl${json['backdrop_path']}' 
          : json['backdrop'],
      streamUrl: json['stream_url'] ?? json['src_url'],
      categoryId: json['category_id']?.toString(),
      categoryName: json['category'] ?? json['category_name'],
      director: json['director'],
      cast: json['cast'],
      releaseDate: json['releasedate'] ?? json['releaseDate'],
      favorite: json['favorite'] == true || json['favorite'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleTranslated': titleTranslated,
      'year': year,
      'rating': rating,
      'duration': duration,
      'plot': plot,
      'plotTranslated': plotTranslated,
      'genre': genre,
      'imageUrl': imageUrl,
      'backdropUrl': backdropUrl,
      'streamUrl': streamUrl,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'director': director,
      'cast': cast,
      'releaseDate': releaseDate,
      'favorite': favorite,
    };
  }

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      titleTranslated: movie.titleTranslated,
      year: movie.year,
      rating: movie.rating,
      duration: movie.duration,
      plot: movie.plot,
      plotTranslated: movie.plotTranslated,
      genre: movie.genre,
      imageUrl: movie.imageUrl,
      backdropUrl: movie.backdropUrl,
      streamUrl: movie.streamUrl,
      categoryId: movie.categoryId,
      categoryName: movie.categoryName,
      director: movie.director,
      cast: movie.cast,
      releaseDate: movie.releaseDate,
      favorite: movie.favorite,
    );
  }
}

class MovieCategoryModel extends MovieCategory {
  const MovieCategoryModel({
    required super.id,
    required super.name,
    super.parentId,
  });

  factory MovieCategoryModel.fromJson(Map<String, dynamic> json) {
    final pid = json['parent_id'];
    return MovieCategoryModel(
      id: int.tryParse(json['category_id']?.toString() ?? json['id']?.toString() ?? '0') ?? 0,
      name: json['category_name'] ?? json['name'] ?? '',
      parentId: pid != null ? int.tryParse(pid.toString()) : null,
    );
  }
}
