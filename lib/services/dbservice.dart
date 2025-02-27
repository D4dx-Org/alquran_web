import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class DBService {
  static final DBService dbProvider = DBService();
  Database? db;
  static const NEW_DB_VERSION = 4;

  Future<Database> initDB({
    String path = "alquran4.db",
    bool absolutePath = false,
    bool verbose = true,
    String fromAsset = "assets/alquran4.db", // Changed from zip to direct db file
    bool debug = false
  }) async {
    /// The [path] is where the database file will be stored. It is by
    /// default relative to the documents directory unless [absolutePath]
    /// is true.
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
        thafdb.close();
        // Delete outdated database
        if (verbose) print("Deleting old database version");
        await deleteDatabase(dbpath);
      } else {
        thafdb.close();
      }
    }

    // Copy database from assets if it doesn't exist or was deleted due to version
    if (!await databaseExists(dbpath)) {
      if (verbose) print("Copying database from assets");
      try {
        // Read database file from assets
        ByteData data = await rootBundle.load(fromAsset);
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        
        // Create directories if needed
        File file = File(dbpath);
        if (!file.parent.existsSync()) {
          file.parent.createSync(recursive: true);
        }
        
        // Write database file
        await file.writeAsBytes(bytes, flush: true);
      } catch (e) {
        throw ("Unable to copy database from asset: $e");
      }
    }

    // Open the database
    var myDatabase = await openDatabase(
      dbpath, 
      version: NEW_DB_VERSION, 
      readOnly: false,
      onCreate: (Database db, int version) async {
        db.setVersion(NEW_DB_VERSION);
        this.db = db;
      }
    );
    
    if (verbose) print("Database opened successfully");
    return myDatabase;
  }

  Future openDB() async {
    try {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'alquran4.db');
      final exist = await databaseExists(path);
      if (exist) {
        var db = await openDatabase(
          path,
          version: NEW_DB_VERSION,
        );
        this.db = db;
      } else {
        // If the database doesn't exist in the system path, initialize it
        return await initDB();
      }
      // open the database
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  get database async {
    db ??= await initDB();
    return db!;
  }

  close() async {
    var db = await database;
    var result = db.close();
    return result;
  }
}