import 'package:image_picker/image_picker.dart';
import 'package:teslo_shop/features/shared/infrastructure/drivers/adapters/adapters.dart';

class CameraGalleryAdapterImpl extends CameraGalleryAdapter {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<String?> selectPhoto() async {
    return _imagePicker
        .pickImage(source: ImageSource.gallery, imageQuality: 80)
        .then((pickedFile) => pickedFile?.path);
  }

  @override
  Future<String?> takePhoto() async {
    return _imagePicker
        .pickImage(
            source: ImageSource.camera,
            imageQuality: 80,
            preferredCameraDevice: CameraDevice.rear)
        .then((pickedFile) => pickedFile?.path);
  }
}
