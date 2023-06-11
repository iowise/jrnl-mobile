import 'package:path_provider/path_provider.dart';
import 'package:dropbox_client/dropbox_client.dart';

Future initDropbox() async {
  await Dropbox.init("x5n2gzpbeie9gyp", "x5n2gzpbeie9gyp", String.fromEnvironment('DROPBOX_SECRET'));
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

Future testListFolder() async {
  final result = await Dropbox.listFolder('');
  print(result);
  return await download();
}

final journalFile = '/journal.txt';
Future upload() async {
  final localPath = await _localJournalPath;
  await Dropbox.upload(localPath, journalFile);
}

Future<String> download() async {
  final localPath = await _localJournalPath;
  print(localPath);
  final result = await Dropbox.download(journalFile, localPath);
  print(result);
  return localPath;
}

Future<String> get _localJournalPath async {
  return '${await _localPath}$journalFile';
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
