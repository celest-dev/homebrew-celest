import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

String getPrettyJSONString(jsonObject){
  var encoder = new JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}

Future<String> downloadDescriptor(String url) async {
  final client = http.Client();
  var response = await client.get(Uri.parse(url));
  return response.body;
}

Future<String> downloadFile(String url, String fileName) async {
  String tempPath = Directory.systemTemp.path;

  final file = File(path.join(tempPath, fileName));

  // check if the file already exists, if so skip the download
  if (file.existsSync()) {
    print('\nFile ${fileName} already exists, skipping download.');
    return file.path;
  }

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

    var percentage = (totalBytes / contentLength * 100).toStringAsFixed(0);
    // only print percentage once when it is a multiple of 5
    if (int.parse(percentage) % 5 == 0) {
      print('\rDownloading ${fileName}: $percentage%');
    }
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

Future<void> updateFormula(String version, Map<String, String> sha256s, Map<String, String> pkgUrls,
    {bool isLatest = false}) async {
  final formulaTemplatePath = 'celest.rb.template';
  var formulaPath = 'celest@${version}.rb';

  if (isLatest) {
    formulaPath = 'celest.rb';
  }

  final formulaTemplateFile = File(formulaTemplatePath);
  final formulaFile = File(formulaPath);
  final formulaTemplate = await formulaTemplateFile.readAsString();

  // null check the sha256s
  if (sha256s['macos_arm64'] == null ||
      sha256s['macos_x64'] == null ||
      sha256s['linux_arm64'] == null ||
      sha256s['linux_x64'] == null) {
    // throw Exception('SHA-256 checksums are null.');
    print('SHA-256 checksums are null.');
    return;
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

  // replace the pkg urls
  final updatedFormulaWithPkgUrls = updatedFormula
      .replaceFirst(RegExp(r'ARM64_MACOS_PKG_URL'), pkgUrls['macos_arm64']!)
      .replaceFirst(RegExp(r'X86_64_MACOS_PKG_URL'), pkgUrls['macos_x64']!)
      .replaceFirst(RegExp(r'ARM64_LINUX_PKG_URL'), pkgUrls['linux_arm64']!)
      .replaceFirst(RegExp(r'X86_64_LINUX_PKG_URL'), pkgUrls['linux_x64']!);

  // also replace the version
  final updatedFormulaWithVersion = updatedFormulaWithPkgUrls.replaceAll(RegExp(r'CELEST_VERSION'), version);

  // replace the SANITIZED_VERSION
  var sanitizedVersion = "AT${version.replaceAll(RegExp(r'[^\w\s]+'), '')}";
  if (isLatest) {
    sanitizedVersion = '';
  }

  final updatedFormulaWithSanitizedVersion = updatedFormulaWithVersion.replaceAll(RegExp(r'SANITIZED_VERSION'), sanitizedVersion);

  // write the formula to a file named celest-{version}.rb
  await formulaFile.writeAsString(updatedFormulaWithSanitizedVersion);
}

Future<void> main() async {
  // download the following files

  var releaseDescriptors = {
    "macos_arm64": "https://releases.celest.dev/macos_arm64/releases.json",
    "macos_x64": "https://releases.celest.dev/macos_x64/releases.json",
    "linux_arm64": "https://releases.celest.dev/linux_arm64/releases.json",
    "linux_x64": "https://releases.celest.dev/linux_x64/releases.json"
  };

  // download the files
  var downloadedFiles = <String, dynamic>{};

  for (var releaseDescriptor in releaseDescriptors.entries) {
    var descriptor = await downloadDescriptor(releaseDescriptor.value);
    var descriptorJson = jsonDecode(descriptor);
    downloadedFiles[releaseDescriptor.key] = descriptorJson;
  }

  // format json with read
  var formattedJson = getPrettyJSONString(downloadedFiles);
  print(formattedJson);

  // determine all the version available across all platforms
  var allVersions = <String>{};
  for (var releaseDescriptor in downloadedFiles.entries) {
    var descriptor = releaseDescriptor.value['releases'] as Map;
    for (var version in descriptor.keys) {
      allVersions.add(version);
    }
  }

  var installers = <String, dynamic>{};

  for (var version in allVersions) {
    var versionInstallers = <String, dynamic>{};
    for (var releaseDescriptor in downloadedFiles.entries) {
      var descriptor = releaseDescriptor.value['releases'] as Map;
      if (descriptor.containsKey(version)) {
        if (descriptor[version].containsKey('installer')) {
          versionInstallers[releaseDescriptor.key] =
          "https://releases.celest.dev/${descriptor[version]['installer']}";
        } else {
          versionInstallers[releaseDescriptor.key] = null;
        }
      }
    }
    installers[version] = versionInstallers;
  }

  print(installers);

  // if any of the entries per version is null, remove it
  var installersWithoutNulls = <String, dynamic>{};
  for (var installer in installers.entries) {
    var version = installer.key;
    var versionInstallers = installer.value;
    if (versionInstallers.values.contains(null)) {
      continue;
    }
    installersWithoutNulls[version] = versionInstallers;
  }

  // for each version, download the installer and calculate the sha256
  var sha256s = <String, dynamic>{};
  var pkgUrls = <String, String>{};
  for (var installer in installersWithoutNulls.entries) {
    var version = installer.key;
    var versionInstallers = installer.value;
    var versionSha256s = <String, String>{};
    for (var versionInstaller in versionInstallers.entries) {
      // make the fileName unique to this version
      var fileName = "celest-$version-${versionInstaller.key}";
      var filePath = await downloadFile(versionInstaller.value, fileName);
      var sha256 = await calculateSha256(filePath);
      versionSha256s[versionInstaller.key] = sha256;
      print("\nSHA-256 checksum for $fileName: $sha256");

      // store the pkg urls
      pkgUrls[versionInstaller.key] = versionInstaller.value;
    }
    sha256s[version] = versionSha256s;

    // now update the formula
    await updateFormula(version, versionSha256s, pkgUrls);
  }

  // now find the latest version
  var latestVersion = allVersions.reduce((value, element) {
    return value.compareTo(element) > 0 ? value : element;
  });

  print('Latest version is $latestVersion');

  // now update the formula with the latest version
  Map<String, String> latestVersionSha256s = sha256s[latestVersion];
  Map<String, String> latestVersionPkgUrls = Map<String, String>.from(installersWithoutNulls[latestVersion]);
  await updateFormula(latestVersion, latestVersionSha256s, latestVersionPkgUrls, isLatest: true);


}




//
//   final sha256s = <String, String>{};
//
//   for (final arch in architectures.entries) {
//     final fileName = arch.key.split('_').join('-');
//     final filePath = await downloadFile(arch.value, fileName);
//     final sha256 = await calculateSha256(filePath);
//     sha256s[arch.key] = sha256;
//     print("\nSHA-256 checksum for $fileName: $sha256");
//   }
//
//   await updateFormula(sha256s);
//   print('\nHomebrew formula updated with new SHA-256 checksums.');
// }
//

//

