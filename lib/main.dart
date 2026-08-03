import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'storage/storage_service.dart';
import 'audio/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  final storage = StorageService();
  await storage.init();
  
  // Initialize audio
  final audioService = AudioService();
  final settings = storage.getSettings();
  await audioService.init(settings);
  
  runApp(const ProviderScope(child: BrickFallApp()));
}