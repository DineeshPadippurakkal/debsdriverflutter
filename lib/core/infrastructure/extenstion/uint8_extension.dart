import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

extension Uint8ListToFile on Uint8List {
  /// Converts Uint8List bytes into a physical File in the temporary directory.
  Future<File> toFile({String? prefix}) async {
    // 1. Get the temporary directory
    final tempDir = await getTemporaryDirectory();

    // 2. Generate a unique name (prefix helps identify if it's a signature or photo)
    final name = prefix ?? 'file';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${tempDir.path}/${name}_$timestamp.png';

    // 3. Create and write the file
    final file = File(filePath);
    return await file.writeAsBytes(this);
  }
}