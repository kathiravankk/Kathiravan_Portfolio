import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/modules/internship/controller/internship_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class MyCertificatesScreen extends StatefulWidget {
  const MyCertificatesScreen({super.key});

  @override
  State<MyCertificatesScreen> createState() => _MyCertificatesScreenState();
}

class _MyCertificatesScreenState extends State<MyCertificatesScreen> {
  final InternshipController internController =
      Get.find<InternshipController>();

  @override
  void initState() {
    super.initState();
    getAllCertificates();
  }

  Future<void> getAllCertificates() async {
    try {
      await internController.getAllCertificates();
      if (internController.getResponseCode() != 200 &&
          internController.getResponseCode() != 201) {
        AppFunctions.showToast(
          message: "Failed to fetch your certificates!",
          isError: true,
        );
      }
    } catch (e) {
      AppFunctions.showToast(
        message: "Failed to fetch your certificates!",
        isError: true,
      );
    }
  }

  Future<void> _downloadCertificate(String url) async {
    try {
      final hasPermission = await _requestStoragePermission();

      if (!hasPermission) {
        AppFunctions.showToast(message: "Permission denied", isError: true);
        return;
      }

      final response = await HttpClient().getUrl(Uri.parse(url));
      final res = await response.close();
      final bytes = await consolidateHttpClientResponseBytes(res);

      Directory downloadDir;

      if (Platform.isAndroid) {
        downloadDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadDir = await getApplicationDocumentsDirectory();
      }

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final file = File(
        '${downloadDir.path}/certificate_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await file.writeAsBytes(bytes);

      AppFunctions.showToast(message: "Saved to Downloads");
    } catch (e) {
      AppFunctions.showToast(message: "Download failed", isError: true);
    }
  }

  Future<void> _shareCertificate(String url) async {
    try {
      final response = await HttpClient().getUrl(Uri.parse(url));
      final res = await response.close();
      final bytes = await consolidateHttpClientResponseBytes(res);

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/certificate_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(file.path, mimeType: 'image/jpeg')]);
    } catch (e) {
      AppFunctions.showToast(message: "Share failed", isError: true);
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final sdk = await _getAndroidSdkVersion();

    if (sdk >= 33) return true;
    if (sdk >= 29) return true;

    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<int> _getAndroidSdkVersion() async {
    return 33;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.appBgColor_2,
      color: AppColors.primaryColor,
      onRefresh: () => getAllCertificates(),
      child: Scaffold(
        backgroundColor: AppColors.appBgColor_2,
        appBar: AppBar(
          backgroundColor: AppColors.appBgColor_2,
          elevation: 0,
          title: Text(
            "My Certificates",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          if (internController.certificateLoading) {
            return Center(
              child: CupertinoActivityIndicator(
                color: AppColors.secondaryColor,
              ),
            );
          }
          final list = internController.certificateModel.certificatesList;

          if (list == null || list.isEmpty) {
            return const CustomEmptyWidget();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];

              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.fieldBgColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.contBorderColor),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            item.certificate ??
                                "https://static.vecteezy.com/system/resources/thumbnails/002/349/754/small_2x/modern-elegant-certificate-template-free-vector.jpg",
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Container(
                                height: 200,
                                color: AppColors.thirdColor,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors
                                        .primaryColor,
                                    value:
                                    loadingProgress
                                        .expectedTotalBytes !=
                                        null
                                        ? loadingProgress
                                        .cumulativeBytesLoaded /
                                        loadingProgress
                                            .expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 10,
                    child: downloadShareContainer(
                      certificate: item.certificate ?? "",
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  Widget downloadShareContainer({required String certificate}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.creditContColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.creditBorderColor),
      ),
      padding: EdgeInsets.all(5),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 10,
        children: [
          iconWidget(
            icon: Icons.share_outlined,
            onTap: () async {
              await _shareCertificate(certificate);
            },
          ),
          iconWidget(
            icon: Icons.download,
            onTap: () async {
              await _downloadCertificate(certificate);
            },
          ),
        ],
      ),
    );
  }

  Widget iconWidget({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColors.whiteColor, size: 20),
    );
  }
}
