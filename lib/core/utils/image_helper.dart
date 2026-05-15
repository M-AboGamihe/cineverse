class ImageHelper {
  static const String baseUrl = "https://image.tmdb.org/t/p/";

  static String? poster(String path, {String size = "w500"}) {
    if (path.isEmpty) return null;
    return "$baseUrl$size$path";
  }
}
