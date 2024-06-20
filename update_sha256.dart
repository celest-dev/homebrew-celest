import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

Future<void> main() async {
  final architectures = {
    'macos_arm64':
        'https://releases.celest.dev/macos_arm64/latest/celest-latest-macos_arm64.pkg',
    'macos_x64':
        'https://releases.celest.dev/macos_x64/latest/celest-latest-macos_x64.pkg',
    'linux_arm64':
        'https://releases.celest.dev/linux_arm64/latest/celest-latest-linux_arm64.deb',
    'linux_x64':
        'https://releases.celest.dev/linux_x64/latest/celest-latest-linux_x64.deb'
  };

  final sha256s = <String, String>{};

  for (final arch in architectures.entries) {
    final fileName = arch.key.split('_').join('-');
    final filePath = await downloadFile(arch.value, fileName);
    final sha256 = await calculateSha256(filePath);
    sha256s[arch.key] = sha256;
    print("\nSHA-256 checksum for $fileName: $sha256");
  }

  await updateFormula(sha256s);
  print('\nHomebrew formula updated with new SHA-256 checksums.');
}

Future<String> downloadFile(String url, String fileName) async {
  String tempPath = Directory.systemTemp.path;

  final file = File(path.join(tempPath, fileName));

  // check if the file already exists, if so skip the download
  // if (file.existsSync()) {
  //   print('\nFile ${fileName} already exists, skipping download.');
  //   return file.path;
  // }

  final client = http.Client();
  final request = await client.send(http.Request('GET', Uri.parse(url)));

  int totalBytes = 0;
  final stopwatch = Stopwatch()..start();

  final sink = file.openWrite();
  final contentLength = int.parse(request.headers['content-length']!);

  final completer = Completer<void>();

  request.stream.listen((chunk) {
    totalBytes += chunk.length;
    sink.add(chunk);
    print(
        '\rDownloading $fileName... ${(totalBytes / contentLength * 100).toStringAsFixed(2)}%');
  }, onDone: () async {
    stopwatch.stop();
    await sink.close();
    completer.complete();
  }, onError: (error) {
    completer.completeError(error);
  });

  await completer.future;
  return file.path;
}

Future<String> calculateSha256(String filePath) async {
  final file = File(filePath);
  final bytes = await file.readAsBytes();
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<void> updateFormula(Map<String, String> sha256s) async {
  final formulaTemplatePath = 'celest.rb.template';
  final formulaPath = 'celest.rb';
  final formulaTemplateFile = File(formulaTemplatePath);
  final formulaFile = File(formulaPath);
  final formulaTemplate = await formulaTemplateFile.readAsString();

  // null check the sha256s
  if (sha256s['macos_arm64'] == null ||
      sha256s['macos_x64'] == null ||
      sha256s['linux_arm64'] == null ||
      sha256s['linux_x64'] == null) {
    throw Exception('SHA-256 checksums are null.');
  }

  final updatedFormula = formulaTemplate
      .replaceFirst(RegExp(r'SHA256_CHECKSUM_OF_ARM64_MACOS_PKG'),
          sha256s['macos_arm64']!)
      .replaceFirst(
          RegExp(r'SHA256_CHECKSUM_OF_X86_64_MACOS_PKG'), sha256s['macos_x64']!)
      .replaceFirst(RegExp(r'SHA256_CHECKSUM_OF_ARM64_LINUX_DEB'),
          sha256s['linux_arm64']!)
      .replaceFirst(RegExp(r'SHA256_CHECKSUM_OF_X86_64_LINUX_DEB'),
          sha256s['linux_x64']!);

  // write the formula to a file named celest.rb
  await formulaFile.writeAsString(updatedFormula);
}
