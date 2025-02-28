import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:archive/archive.dart';

class DBService {
  static final DBService dbProvider = DBService();
  Database? _db;
  bool _isInitializing = false;
  static const NEW_DB_VERSION = 4;

  Future<Database> initDB(
      {String path = "alquran4.db",
      bool absolutePath = false,
      bool verbose = true,
      String fromAsset = "assets/alquran.zip",
      bool debug = false}) async {
    if (_isInitializing) {
      // Wait until initialization is complete
      while (_isInitializing) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      if (_db != null) return _db!;
    }

    _isInitializing = true;
    try {
      if (debug) Sqflite.setDebugModeOn(true);
      String dbpath = path;
      String oldDbPath = "alquran3.db";
      if (!absolutePath) {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        oldDbPath = "${documentsDirectory.path}/alquran3.db";
        dbpath = "${documentsDirectory.path}/$path";
      }

      /// delete if version is old
      if (await databaseExists(oldDbPath)) await deleteDatabase(oldDbPath);

      // Check if database already exists and its version
      if (await databaseExists(dbpath)) {
        var thafdb = await openDatabase(dbpath);
        if (await thafdb.getVersion() < NEW_DB_VERSION) {
          await thafdb.close();
          // Delete outdated database
          if (verbose) print("Deleting old database version");
          await deleteDatabase(dbpath);
        } else {
          await thafdb.close();
        }
      }

      // Extract and copy database from zip if it doesn't exist or was deleted due to version
      if (!await databaseExists(dbpath)) {
        if (verbose) print("Extracting database from zip file");
        try {
          // Read zip file from assets
          ByteData data = await rootBundle.load(fromAsset);
          List<int> bytes =
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

          // Decode the zip file
          final archive = ZipDecoder().decodeBytes(bytes);

          // Find the database file in the archive
          final dbFile = archive.findFile('alquran4.db');
          if (dbFile == null)
            throw Exception('Database file not found in zip archive');

          // Create directories if needed
          File file = File(dbpath);
          if (!file.parent.existsSync()) {
            file.parent.createSync(recursive: true);
          }

          // Write the extracted database file
          await file.writeAsBytes(dbFile.content as List<int>, flush: true);
        } catch (e) {
          _isInitializing = false;
          throw ("Unable to extract database from zip: $e");
        }
      }

      // Open the database
      _db = await openDatabase(dbpath, version: NEW_DB_VERSION, readOnly: false,
          onCreate: (Database db, int version) async {
        await db.setVersion(NEW_DB_VERSION);
      });

      if (verbose) print("Database opened successfully");
      return _db!;
    } finally {
      _isInitializing = false;
    }
  }

  Future<bool> openDB() async {
    try {
      if (_db != null && _db!.isOpen) return true;

      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'alquran4.db');
      final exist = await databaseExists(path);

      if (exist) {
        _db = await openDatabase(
          path,
          version: NEW_DB_VERSION,
        );
      } else {
        // If the database doesn't exist in the system path, initialize it
        await initDB();
      }
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<void> close() async {
    final db = _db;
    if (db != null && db.isOpen) {
      await db.close();
      _db = null;
    }
  }
}
