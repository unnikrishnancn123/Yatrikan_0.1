import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/photo_add_model.dart';

const photoTable = 'Photo';

class DbService {
  static Database? _db;
  static final DbService instance = DbService._init();
  DbService._init();

  Future<Database> get db async {
    _db = await createDatabase();
    return _db!;
  }
  Future<Database> createDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'photo.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: onUpgrade);
    return db;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
      // Perform necessary database upgrade tasks here
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Photo (id INTEGER PRIMARY KEY AUTOINCREMENT, photo_code TEXT, location TEXT)');
    stderr.writeln('print me');
  }

  Future<PhotoAddModel> addPhoto(PhotoAddModel photo) async {
    try {
      final dbClient = await instance.db;
      var photoId = await dbClient.insert(photoTable, photo.toMap());
      photo.id = photoId;
      return photo;
    } catch (e) {
      rethrow; // Re-throw the exception to propagate it further if necessary
    }
  }

  Future<List<PhotoAddModel>> getphoto() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(photoTable);
    List<PhotoAddModel> photos = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        photos.add(PhotoAddModel.fromMap(maps[i]));
      }
    }
    return photos;
  }

  Future<List<PhotoAddModel>>getphotos({int page = 1}) async {
    const int perPage = 100; // Number of photos per page
    final int offset = (page - 1) * perPage; // Calculate the offset
    final dbClient = await instance.db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      photoTable,
      offset: offset, // Use offset as named parameter
      limit: perPage, // Use limit as named parameter
    );
    List<PhotoAddModel> photos = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        photos.add(PhotoAddModel.fromMap(maps[i]));
      }
    }
    return photos;
  }

  Future<int> deletePhoto(int id) async {
    var dbClient = await db;
    return await dbClient.delete(photoTable, where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<List<PhotoAddModel>> getphotosByLocation(String searchQuery) async {
    var dbClient = await db;
    final maps = await dbClient.query(
      photoTable,
      where: 'location LIKE ?',
      whereArgs: ['%$searchQuery%'], // Use % before and after the search query for partial matching
    );

    List<PhotoAddModel> photos = [];
    if (maps.isNotEmpty) {
      for (var map in maps) {
        photos.add(PhotoAddModel.fromMap(map));
      }
    }
    return photos;
  }


}
