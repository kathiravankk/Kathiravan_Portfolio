import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import '../../../../data/models/recruiter_flow/syllabus_view_data_model.dart';

class ChatSyllabusUpdateScreen extends StatefulWidget {
  const ChatSyllabusUpdateScreen({super.key});

  @override
  State<ChatSyllabusUpdateScreen> createState() =>
      _ChatSyllabusUpdateScreenState();
}

class _ChatSyllabusUpdateScreenState extends State<ChatSyllabusUpdateScreen> {
  final InternshipPostController applicationController =
      Get.find<InternshipPostController>();

  SyllabusViewData? syllabusData;
  String chatId = "";

  final TextEditingController chatTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<ChatMessage> chatList = [];

  List<String> availableOptions = [];
  List<String> suggestionTopics = [];

  String studentId = "";
  String jobId = "";

  @override
  void initState() {
    super.initState();
    syllabusData = Get.arguments["syllabusData"];
    studentId = Get.arguments["studentId"] ?? "";
    jobId = Get.arguments["jobId"] ?? "";
    getInitialChatData();
  }

  // ================= INITIAL LOAD =================

  Future<void> getInitialChatData() async {
    try {
      await applicationController.getSyllabusChatData(
        syllabusData: syllabusData!,
      );

      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        chatId = applicationController.syllabusChatModel.syllabus!.userId ?? "";

        chatList.add(
          ChatMessage(
            text:
                applicationController.syllabusChatModel.syllabus?.response ??
                "",
            isBot: true,
          ),
        );

        availableOptions =
            applicationController.syllabusChatModel.syllabus?.option ?? [];
        suggestionTopics = [];
      } else {
        AppFunctions.apiErrorHandling(
          applicationController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        applicationController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  // ================= CHAT SEND =================

  Future<void> syllabusChatMessage({required String message}) async {
    if (message.trim().isEmpty) return;

    chatList.add(ChatMessage(text: message, isBot: false));

    setState(() {
      availableOptions = [];
      suggestionTopics = [];
    });

    chatTextController.clear();
    scrollToBottom();
    FocusScope.of(context).unfocus();

    try {
      await applicationController.syllabusChatMessage(
        chatId: chatId,
        message: message,
      );

      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        final aiResponse = applicationController.aiChatResponseModel.aiResponse;

        chatList.add(
          ChatMessage(text: aiResponse?.response ?? "Nill", isBot: true),
        );

        availableOptions = aiResponse?.option ?? [];
        suggestionTopics = aiResponse?.suggestionTopics ?? [];

        scrollToBottom();
        if (aiResponse!.status == "completed") {
          await applicationController.updateSyllabusChatMessage(
            syllabusData: aiResponse.finalData!,
            studentId: studentId,
            jobId: jobId,
          );
          if (applicationController.getResponseCode() == 200 ||
              applicationController.getResponseCode() == 201) {
            AppAlertUtils.showToast(message: "Syllabus updated successfully!");
            Get.back();
            Get.back();
          }
          else{
            AppFunctions.apiErrorHandling(
              applicationController.getResponseCode(),
              "Something went wrong, Failed to update syllabus!",
            );
          }
        }
      } else {
        AppFunctions.apiErrorHandling(
          applicationController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        applicationController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  // ================= SINGLE SELECT OPTION TAP =================

  Future<void> onOptionTap(String message) async {
    // if (message == "Finish & Save") {
    //   chatList.add(ChatMessage(text: message, isBot: false));
    //   setState(() {
    //     availableOptions = [];
    //     suggestionTopics = [];
    //   });
    //   scrollToBottom();
    //
    //   /// Part-2
    //   return;
    // }

    await syllabusChatMessage(message: message);
  }

  // ================= SCROLL =================

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.chatScreenBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
          title: Text(
            "Syllabus Update AI Agent",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => applicationController.syllabusChatLoading
              ? AppAlertUtils.customLoader()
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: chatList.length,
                          itemBuilder: (context, i) =>
                              _buildChatBubble(chatList[i]),
                        ),
                      ),

                      if (applicationController.chatMessageLoading)
                        loadingContainer(),

                      if (suggestionTopics.isNotEmpty ||
                          availableOptions.isNotEmpty)
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 400),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (suggestionTopics.isNotEmpty)
                                  _buildSuggestionTopics(),

                                if (availableOptions.isNotEmpty)
                                  _buildOptionsChips(),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),

                      _buildInputArea(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ================= OPTIONS CHIPS (SINGLE SELECT) =================

  Widget _buildOptionsChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableOptions.map((option) {
        return GestureDetector(
          onTap: applicationController.chatMessageLoading
              ? null
              : () => onOptionTap(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.chatGradient3,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              option.replaceAll("_", " "),
              style: AppStyles.customTextStyle(
                size: 13,
                weight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ================= SUGGESTION TOPICS (SINGLE SELECT) =================

  Widget _buildSuggestionTopics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Suggested Topics",
          style: AppStyles.customTextStyle(
            size: 14,
            weight: FontWeight.w600,
            color: AppColors.whiteColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestionTopics.map((topic) {
            return GestureDetector(
              onTap: applicationController.chatMessageLoading
                  ? null
                  : () => onOptionTap(topic),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  topic,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    weight: FontWeight.w500,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ================= INPUT AREA =================

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.chatGradient3,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatTextController,
              enabled: !applicationController.chatMessageLoading,
              style: AppStyles.customTextStyle(
                size: 14,
                weight: FontWeight.w400,
                color: AppColors.whiteColor,
              ),
              cursorColor: AppColors.primaryColor,
              decoration: InputDecoration(
                hintText: availableOptions.isNotEmpty
                    ? 'Select an option above or type here...'
                    : 'Type here...',
                hintStyle: AppStyles.customTextStyle(
                  color: AppColors.chatTextColor,
                  size: 12,
                ),
                border: InputBorder.none,
              ),
              onSubmitted: (value) async {
                await syllabusChatMessage(message: chatTextController.text);
              },
            ),
          ),
          IconButton(
            icon: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.send_outlined,
                color: AppColors.whiteColor,
              ),
            ),
            onPressed: applicationController.chatMessageLoading
                ? null
                : () async {
                    await syllabusChatMessage(message: chatTextController.text);
                  },
          ),
        ],
      ),
    );
  }

  // ================= CHAT BUBBLE =================

  Widget _buildChatBubble(ChatMessage msg) {
    bool isBot = msg.isBot;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        spacing: 5,
        crossAxisAlignment: isBot
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            isBot ? "Sharks Bot" : "You",
            style: AppStyles.customTextStyle(
              color: AppColors.chatTextColor,
              size: 12,
              weight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: isBot
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (isBot)
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(AssetImages.aiBotImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isBot
                          ? [AppColors.chatGradient3, AppColors.chatGradient3]
                          : [AppColors.chatGradient1, AppColors.chatGradient2],
                    ),
                    borderRadius: isBot
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                  ),
                  child: Text(
                    msg.text,
                    style: AppStyles.customTextStyle(
                      lineSpace: 1.2,
                      size: 14,
                      weight: FontWeight.w400,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget loadingContainer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sharks Bot",
            style: AppStyles.customTextStyle(
              color: AppColors.chatTextColor,
              size: 12,
              weight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(AssetImages.appIconImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.chatGradient3,
                        AppColors.chatGradient3,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Shark Bot typing...",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  ChatMessage({required this.text, required this.isBot});

  final String text;
  final bool isBot;
}
