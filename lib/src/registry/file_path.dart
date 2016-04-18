part of registry;

/// Returns a URI for a path package down.
Uri toUri(List<String> pathString) {
  path.Context ctx = new path.Context();
  List<String> parts = new List()
    ..add(ctx.current)
    ..addAll(pathString);
 String completePath = ctx.joinAll(parts);
  if (path.extension(completePath) == null) {
    return new Uri.directory(completePath);
  } else {
    return new Uri.file(completePath);
  }
}


/// Verifies the file in the URI actually exist.
Future<bool> isFileAccessible(Uri file) async {
  FileSystemEntity testFile = new File.fromUri(file);
  return await testFile.exists();
}

/// Verifies the directory in the URI actually exist.
Future<bool> dirExist(Uri dir) async {
  var testDirectory = new Directory.fromUri(dir);
  return await testDirectory.exists();
}
