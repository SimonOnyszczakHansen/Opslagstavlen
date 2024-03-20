abstract class ImageRepository {
  Future<void> saveImagePath(String path);
  Future<List<String>> fetchImagePaths();
}