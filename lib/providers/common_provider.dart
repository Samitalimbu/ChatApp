import 'package:firebase/providers/common_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'common_provider.dart';

final mode = StateNotifierProvider.autoDispose<AutoProvider, AutovalidateMode>(
    (ref) => AutoProvider(AutovalidateMode.disabled));

class AutoProvider extends StateNotifier<AutovalidateMode> {
  AutoProvider(super.state);

  void toogle() {
    state = AutovalidateMode.onUserInteraction;
  }
  void disable() {
    state = AutovalidateMode.disabled;
  }
}

final loginProvider =
    StateNotifierProvider<CommonProvider, bool>((ref) => CommonProvider(true));

class CommonProvider extends StateNotifier<bool> {
  CommonProvider(super.state);

  void toogle() {
    state = !state;
  }
}

final imageProvider =
    StateNotifierProvider<ImageProvider, XFile?>((ref) => ImageProvider(null));

class ImageProvider extends StateNotifier<XFile?> {
  ImageProvider(super.state);

  void ImagePick(bool isCamera) async {
    final ImagePicker _picker = ImagePicker();
    if (isCamera) {
      state = await _picker.pickImage(source: ImageSource.camera);
    } else {
      state = await _picker.pickVideo(source: ImageSource.gallery);
    }
  }
}
