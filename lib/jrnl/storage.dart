import 'package:path_provider/path_provider.dart';
import 'package:dropbox_client/dropbox_client.dart';

Future initDropbox() async {
  await Dropbox.init("x5n2gzpbeie9gyp", "x5n2gzpbeie9gyp",
      String.fromEnvironment('DROPBOX_SECRET'));
}

Future<bool> isLoggedIn() async {
  return await Dropbox.getCredentials() != null;
}

Future loginDropbox() async {
  final credentials = await Dropbox.getCredentials();
  if (credentials == null) {
    await Dropbox.authorizePKCE();
    return;
  }
  await Dropbox.authorizeWithCredentials(credentials);
}

Future logoutDropbox() async {
  await Dropbox.unlink();
}

Future<List<DropboxFile>> listFolder() async {
  final List<Object?> objResult = await Dropbox.listFolder('');
  final List<DropboxFile> result = List.from(objResult.map(
    (e) {
      final Map<Object?, Object?> json = e as Map<Object?, Object?>;
      return DropboxFile(
        filesize: e["filesize"] as int,
        pathDisplay: e["pathDisplay"] as String,
        serverModified: e["serverModified"] as String,
        clientModified: e["clientModified"] as String,
        name: e["name"] as String,
        pathLower: e["pathLower"] as String,
      );
    },
  ));
  return result;
}

Future<DropboxFile> fetchRemoteFileMetadata() async {
  final files = await listFolder();
  return files.firstWhere((element) => element.name == "journal.txt");
}

Future upload(String localPath, {String suffix = ""}) async {
  await Dropbox.upload(
      localPath, suffix == "" ? "/journal.txt" : "/journal$suffix.txt");
}

Future<DropboxFile> download(String? localPathToSave) async {
  final journal = await fetchRemoteFileMetadata();
  final localPath = localPathToSave ?? await _localJournalPath;
  await Dropbox.download("/journal.txt", localPath);
  journal.localPath = localPath;
  return journal;
}

class DropboxFile {
  int filesize;
  String pathDisplay;
  String serverModified; // 20230611 100204,
  String clientModified; // 20230611 100203
  String name;
  String pathLower;
  String? localPath;

  DropboxFile({
    required this.filesize,
    required this.pathDisplay,
    required this.serverModified,
    required this.clientModified,
    required this.name,
    required this.pathLower,
  });
}

Future<String> get _localJournalPath async {
  return '${await _localPath}/journal.txt';
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
