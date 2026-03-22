import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'app.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize media_kit
  MediaKit.ensureInitialized();
  
  // Initialize dependencies
  await di.initializeDependencies();
  
  runApp(const StreamXtreamApp());
}
