import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import '../../../../data/models/recruiter_flow/syllabus_data_model.dart';

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
  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  List<ChatMessage> chatList = [];

  bool isTyping = false;

  bool isLoading = false;
  final List<String> selectedOptions = [];

  bool isWaitingResponse = false;

  bool get isOptionSelection =>
      chatList.isNotEmpty &&
      (chatList.last.options.isNotEmpty ||
          chatList.last.suggestionTopics.isNotEmpty);

  bool get isMultiSelect => chatList.isNotEmpty && chatList.last.multiselect;

  @override
  void initState() {
    super.initState();
    syllabusData = Get.arguments["syllabusData"];
    getInitialChatData();
  }

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
            message:
                applicationController.syllabusChatModel.syllabus?.response ??
                "",
            isUser: false,
            options:
                applicationController.syllabusChatModel.syllabus?.option ?? [],
            multiselect:
                applicationController.syllabusChatModel.syllabus?.multiselect ??
                false,
          ),
        );

        setState(() {});
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

  Future<void> syllabusChatMessage({required String message}) async {
    try {
      await applicationController.syllabusChatMessage(
        chatId: chatId,
        message: message,
      );
      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        chatList.add(
          ChatMessage(
            message:
                applicationController
                    .aiChatResponseModel
                    .aiResponse
                    ?.response ??
                "",

            isUser: false,

            options:
                applicationController.aiChatResponseModel.aiResponse?.option ??
                [],

            suggestionTopics:
                applicationController
                    .aiChatResponseModel
                    .aiResponse
                    ?.suggestionTopics ??
                [],

            multiselect:
                applicationController
                    .aiChatResponseModel
                    .aiResponse
                    ?.multiselect ??
                false,
          ),
        );

        setState(() {});

        scrollToBottom();
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

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

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
              Icons.arrow_back_ios,
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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: scrollController,

                  children: [
                    ...chatList.map((e) {
                      return e.isUser ? userBubble(e) : aiBubble(e);
                    }),

                    if (isTyping) typingWidget(),
                  ],
                ),
              ),

              inputWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    final text = messageController.text.trim();

    chatList.add(ChatMessage(message: text, isUser: true));

    messageController.clear();

    setState(() {});

    scrollToBottom();

    await syllabusChatMessage(message: text);
  }

  Widget inputWidget() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,

          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),

        child: Row(
          children: [
            Expanded(
              child: TextField(
                enabled: !isOptionSelection,

                controller: messageController,

                minLines: 1,

                maxLines: 5,

                textInputAction: TextInputAction.send,

                onSubmitted: (_) => sendMessage(),

                decoration: InputDecoration(
                  hintText: isOptionSelection
                      ? "Select an option below"
                      : "Ask AI...",

                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(width: 10),

            InkWell(
              onTap: sendMessage,

              borderRadius: BorderRadius.circular(100),

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),

                width: 52,

                height: 52,

                decoration: BoxDecoration(
                  color: isOptionSelection
                      ? Colors.grey
                      : AppColors.primaryColor,

                  shape: BoxShape.circle,
                ),

                child: IconButton(
                  onPressed: isOptionSelection ? null : sendMessage,

                  icon: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget aiBubble(ChatMessage item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryColor,
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(.18),

                        Colors.white.withOpacity(.08),
                      ],
                    ),

                    border: Border.all(color: Colors.white24),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.15),

                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    item.message,
                    style: AppStyles.customTextStyle(
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),

                if (item.options.isNotEmpty) buildOptions(item),

                if (item.suggestionTopics.isNotEmpty)
                  buildSuggestionTopics(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userBubble(ChatMessage item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,

                    AppColors.primaryColor.withOpacity(.75),
                  ],
                ),

                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                item.message,
                style: AppStyles.customTextStyle(size: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptions(ChatMessage item) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.options.map((option) {
              return InkWell(
                onTap: () {
                  if(item.multiselect){

                    if(selectedOptions.contains(option)){
                      selectedOptions.remove(option);
                    }else{
                      selectedOptions.add(option);
                    }

                    setState((){});

                  }else{

                    onOptionTap(option);

                  }
                },

                borderRadius: BorderRadius.circular(30),

                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),

                    color: AppColors.primaryColor,
                  ),

                  child: Text(
                    option,

                    style: AppStyles.customTextStyle(size: 14, color: selectedOptions.contains(option)
                        ? Colors.white
                        : AppColors.primaryColor,),
                  ),
                ),
              );
            }).toList(),
          ),
          if(item.multiselect)

            Padding(

              padding: const EdgeInsets.only(top:15),

              child: ElevatedButton(

                onPressed: selectedOptions.isEmpty
                    ? null
                    : () {

                  onOptionTap(
                    selectedOptions.join(","),
                  );

                  selectedOptions.clear();

                },

                child: const Text("Continue"),

              ),

            )
        ],
      ),

    );
  }

  Widget buildSuggestionTopics(ChatMessage item) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "Suggested Topics",

            style: AppStyles.customTextStyle(
              size: 15,

              weight: FontWeight.w600,

              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          ...item.suggestionTopics.map((topic) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: ListTile(
                title: Text(topic),

                trailing: const Icon(Icons.arrow_forward_ios, size: 18),

                onTap: () {
                  onOptionTap(topic);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> onOptionTap(String message) async {
    chatList.add(ChatMessage(message: message, isUser: true));

    setState(() {});

    scrollToBottom();

    if (message == "Finish & Save") {
      /// Part-2
      return;
    }

    await syllabusChatMessage(message: message);
  }

  Widget typingWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),

      child: Row(
        children: [
          CircleAvatar(
            radius: 18,

            backgroundColor: AppColors.primaryColor,

            child: const Icon(Icons.smart_toy, color: Colors.white),
          ),

          const SizedBox(width: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),
            ),

            child: const SizedBox(
              width: 20,

              height: 20,

              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  ChatMessage({
    required this.message,
    required this.isUser,
    this.options = const [],
    this.suggestionTopics = const [],
    this.multiselect = false,
  });

  final String message;

  final bool isUser;

  final List<String> options;

  final List<String> suggestionTopics;

  final bool multiselect;
}
