import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_text_classification/tflite_text_classification.dart';

class EmotionDetector {
  final _tfliteTextClassificationPlugin = TfliteTextClassification();

  Future<String?> detectEmotion(String text) async {
    try {
      TextClassifierParams params = TextClassifierParams(
        text: text,
        modelPath:
            await _copyAssetFileToCacheDirectory('assets/mymodel.tflite'),
        modelType: ModelType.mobileBert,
        delegate: 0,
      );

      ClassificationResult? result =
          await _tfliteTextClassificationPlugin.classifyText(params: params);

      return _getPredictedEmotion(result);
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  String? _getPredictedEmotion(ClassificationResult? result) {
    if (result == null) return null;

    double maxScore = 0.0;
    String? predictedEmotion;
    for (var category in result.categories) {
      if (category.score > maxScore) {
        maxScore = category.score;
        predictedEmotion = category.label;
      }
    }
    return predictedEmotion;
  }

  Future<String> _copyAssetFileToCacheDirectory(String assetPath) async {
    Directory cacheDir = await getTemporaryDirectory();
    String fileName = assetPath.split('/').last;
    File cacheFile = File('${cacheDir.path}/$fileName');

    ByteData assetData = await rootBundle.load(assetPath);
    await cacheFile.writeAsBytes(assetData.buffer.asUint8List());

    return cacheFile.path;
  }
}
