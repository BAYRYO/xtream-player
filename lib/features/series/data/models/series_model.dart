import '../../domain/entities/series.dart';

class SeriesModel extends Series {
  const SeriesModel({
    required super.id,
    required super.name,
    super.nameTranslated,
    super.year,
    super.rating,
    super.plot,
    super.plotTranslated,
    super.genre,
    super.imageUrl,
    super.backdropUrl,
    super.categoryId,
    super.categoryName,
    super.cast,
    super.director,
    super.releaseDate,
    super.seasons,
    super.favorite,
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json, {String? serverUrl}) {
    // Xtream API format
    return SeriesModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? json['title'] ?? '',
      nameTranslated: json['name'],
      year: json['year']?.toString(),
      rating: json['rating']?.toString(),
      plot: json['plot'] ?? json['description'],
      plotTranslated: json['plot'],
      genre: json['genre'] ?? json['category'],
      imageUrl: json['image_url'] != null 
          ? '$serverUrl${json['image_url']}' 
          : json['cover'],
      backdropUrl: json['backdrop_path'] != null 
          ? '$serverUrl${json['backdrop_path']}' 
          : json['backdrop'],
      categoryId: json['category_id']?.toString(),
      categoryName: json['category'] ?? json['category_name'],
      cast: json['cast'],
      director: json['director'],
      releaseDate: json['releasedate'] ?? json['releaseDate'],
      favorite: json['favorite'] == true || json['favorite'] == 1,
    );
  }

  factory SeriesModel.fromJsonWithSeasons(
    Map<String, dynamic> json, 
    Map<String, dynamic> seasonsData, 
    {String? serverUrl}
  ) {
    List<Season>? seasons;
    if (seasonsData['seasons'] != null) {
      seasons = (seasonsData['seasons'] as List)
          .map((s) => SeasonModel.fromJson(s, serverUrl: serverUrl))
          .toList();
    }

    return SeriesModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? json['title'] ?? '',
      nameTranslated: json['name'],
      year: json['year']?.toString(),
      rating: json['rating']?.toString(),
      plot: json['plot'] ?? json['description'],
      plotTranslated: json['plot'],
      genre: json['genre'] ?? json['category'],
      imageUrl: json['image_url'] != null 
          ? '$serverUrl${json['image_url']}' 
          : json['cover'],
      backdropUrl: json['backdrop_path'] != null 
          ? '$serverUrl${json['backdrop_path']}' 
          : json['backdrop'],
      categoryId: json['category_id']?.toString(),
      categoryName: json['category'] ?? json['category_name'],
      cast: json['cast'],
      director: json['director'],
      releaseDate: json['releasedate'] ?? json['releaseDate'],
      seasons: seasons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameTranslated': nameTranslated,
      'year': year,
      'rating': rating,
      'plot': plot,
      'plotTranslated': plotTranslated,
      'genre': genre,
      'imageUrl': imageUrl,
      'backdropUrl': backdropUrl,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'cast': cast,
      'director': director,
      'releaseDate': releaseDate,
      'favorite': favorite,
    };
  }
}

class SeasonModel extends Season {
  const SeasonModel({
    required super.id,
    required super.seasonNumber,
    super.name,
    super.imageUrl,
    super.episodes,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json, {String? serverUrl}) {
    return SeasonModel(
      id: int.tryParse(json['id']?.toString() ?? json['season_number']?.toString() ?? '0') ?? 0,
      seasonNumber: int.tryParse(json['season_number']?.toString() ?? '1') ?? 1,
      name: json['name'] ?? 'Season ${json['season_number']}',
      imageUrl: json['image_url'] != null 
          ? '$serverUrl${json['image_url']}' 
          : json['cover'],
    );
  }
}

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.id,
    required super.episodeNumber,
    required super.title,
    super.description,
    super.duration,
    super.imageUrl,
    super.streamUrl,
    required super.seasonId,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json, {String? serverUrl, required int seasonId}) {
    return EpisodeModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      episodeNumber: int.tryParse(json['episode_num']?.toString() ?? '1') ?? 1,
      title: json['title'] ?? 'Episode ${json['episode_num']}',
      description: json['description'] ?? json['plot'],
      duration: json['duration']?.toString(),
      imageUrl: json['image_url'] != null 
          ? '$serverUrl${json['image_url']}' 
          : json['thumbnail'],
      streamUrl: json['stream_url'] ?? json['src'],
      seasonId: seasonId,
    );
  }
}

class SeriesCategoryModel extends SeriesCategory {
  const SeriesCategoryModel({
    required super.id,
    required super.name,
    super.parentId,
  });

  factory SeriesCategoryModel.fromJson(Map<String, dynamic> json) {
    final pid = json['parent_id'];
    return SeriesCategoryModel(
      id: int.tryParse(json['category_id']?.toString() ?? json['id']?.toString() ?? '0') ?? 0,
      name: json['category_name'] ?? json['name'] ?? '',
      parentId: pid != null ? int.tryParse(pid.toString()) : null,
    );
  }
}
