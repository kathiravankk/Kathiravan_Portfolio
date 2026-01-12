// import 'package:flutter/material.dart';
// import 'package:internsharks/const_file/app_colors.dart';
// import 'package:internsharks/const_file/app_text_style.dart';
// import 'package:internsharks/pages/upload_resume/resume_completed_page.dart';
//
// class Message {
//   final String text;
//   final bool isBot;
//   final List<String>? options;
//   final String? userInput;
//
//   Message({
//     required this.text,
//     required this.isBot,
//     this.options,
//     this.userInput,
//   });
// }
//
// class ResumeChat extends StatefulWidget {
//   @override
//   _ResumeChatState createState() => _ResumeChatState();
// }
//
// class _ResumeChatState extends State<ResumeChat> {
//   final List<Message> messages = [];
//   final TextEditingController textController = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//
//   int currentQuestion = 0;
//   Map<String, dynamic> resumeData = {};
//
//   final List<Map<String, dynamic>> questions = [
//     {
//       'question': 'Hello! I\'m here to help you build your resume. Let\'s start with your full name.',
//       'key': 'fullName',
//       'type': 'text',
//     },
//     {
//       'question': 'Great! What\'s your email address?',
//       'key': 'email',
//       'type': 'text',
//     },
//     {'question': 'What\'s your phone number?', 'key': 'phone', 'type': 'text'},
//     {
//       'question': 'Great! Now, let\'s list your skills. What are you good at?',
//       'key': 'skills',
//       'type': 'chips',
//     },
//     {
//       'question': 'What\'s your highest education qualification?',
//       'key': 'education',
//       'type': 'text',
//     },
//     {
//       'question': 'Which college/university did you attend?',
//       'key': 'institution',
//       'type': 'text',
//     },
//     {
//       'question': 'What\'s your current job title or the position you\'re applying for?',
//       'key': 'jobTitle',
//       'type': 'text',
//     },
//     {
//       'question': 'Tell me about your work experience. Where have you worked?',
//       'key': 'experience',
//       'type': 'text',
//     },
//     {
//       'question': 'What are your key achievements or projects?',
//       'key': 'achievements',
//       'type': 'text',
//     },
//     {
//       'question': 'Finally, write a brief summary about yourself for your resume.',
//       'key': 'summary',
//       'type': 'text',
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(milliseconds: 500), () {
//       askQuestion();
//     });
//   }
//
//   void askQuestion() {
//     if (currentQuestion < questions.length) {
//       setState(() {
//         messages.add(
//           Message(text: questions[currentQuestion]['question'], isBot: true),
//         );
//       });
//       scrollToBottom();
//     } else {
//       setState(() {
//         messages.add(
//           Message(
//             text:
//             'Awesome! Your resume is ready.\n\n'
//                 'Name: ${resumeData['fullName']}\n'
//                 'Email: ${resumeData['email']}\n'
//                 'Phone: ${resumeData['phone']}\n'
//                 'Skills: ${resumeData['skills']}\n'
//                 'Education: ${resumeData['education']}\n'
//                 'Institution: ${resumeData['institution']}\n'
//                 'Job Title: ${resumeData['jobTitle']}\n'
//                 'Experience: ${resumeData['experience']}\n'
//                 'Achievements: ${resumeData['achievements']}\n'
//                 'Summary: ${resumeData['summary']}',
//             isBot: true,
//           ),
//         );
//       });
//
//       scrollToBottom();
//
//       /// 🔥 AUTO NAVIGATE TO HOMEPAGE AFTER 2 SECONDS
//       Future.delayed(Duration(seconds: 2), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => ResumeCompletedPage()),
//         );
//       });
//     }
//   }
//
//   void handleAnswer(String answer) {
//     if (currentQuestion >= questions.length) return;
//
//     setState(() {
//       messages.add(Message(text: answer, isBot: false, userInput: answer));
//
//       resumeData[questions[currentQuestion]['key']] = answer;
//       currentQuestion++;
//     });
//
//     textController.clear();
//     scrollToBottom();
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       askQuestion();
//     });
//   }
//
//   void scrollToBottom() {
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 45),
//         child: Column(
//           children: [
//             Row(
//               children: [
//
//          IconButton(
//                     icon: Icon(Icons.arrow_back,size: 25,color: Colors.white,),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//
//                 SizedBox(width: 20),
//                 Text("Create a resume", style: AppTextStyles.white24Bold),
//               ],
//             ),
//             SizedBox(height: 15),
//             SizedBox(
//               width: 300,
//               child: LinearProgressIndicator(
//                 value: currentQuestion / questions.length,
//                 minHeight: 8,
//                 backgroundColor: Colors.grey[800],
//                 borderRadius: BorderRadiusGeometry.circular(50),
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
//               ),
//             ),
//             SizedBox(height: 15),
//
//             Expanded(
//               child: ListView.builder(
//                 controller: scrollController,
//                 padding: EdgeInsets.all(16),
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   final message = messages[index];
//                   return MessageBubble(message: message);
//                 },
//               ),
//             ),
//
//             /// 🔵 Input bar (single rounded container)
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Color(0xFF2D3E50),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: textController,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         hintText: 'Type and press enter',
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                         border: InputBorder.none,
//                       ),
//                       onSubmitted: (value) {
//                         if (value.trim().isNotEmpty) {
//                           handleAnswer(value.trim());
//                         }
//                       },
//                     ),
//                   ),
//
//                   GestureDetector(
//                     onTap: () {
//                       if (textController.text.trim().isNotEmpty) {
//                         handleAnswer(textController.text.trim());
//                       }
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: AppColors.appBlue,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(Icons.send, color: Colors.white, size: 20),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class MessageBubble extends StatelessWidget {
//   final Message message;
//
//   const MessageBubble({Key? key, required this.message}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment:
//         message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
//         children: [
//           if (message.isBot) ...[
//             CircleAvatar(
//               backgroundColor: AppColors.appBlue,
//               radius: 20,
//               child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
//             ),
//             SizedBox(width: 8),
//           ],
//           Flexible(
//             child: Column(
//               crossAxisAlignment:
//               message.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//               children: [
//                 if (message.isBot)
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 4, left: 4),
//                     child: Text('Internsharks',
//                         style: TextStyle(color: Colors.grey[400], fontSize: 12)),
//                   ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: message.isBot
//                         ? Color(0xFF2D3E50)
//                         : Color(0xFF00BCD4),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Text(
//                     message.text,
//                     style: TextStyle(color: Colors.white, fontSize: 15),
//                   ),
//                 ),
//                 if (!message.isBot)
//                   Padding(
//                     padding: EdgeInsets.only(top: 4, right: 4),
//                     child: Text('You',
//                         style: TextStyle(color: Colors.grey[400], fontSize: 12)),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:internsharks/view/pages/upload_resume/resume_completed_page.dart';

class Message {
  final String text;
  final bool isBot;
  final List<String>? options; // Selection buttons-kaaga

  Message({required this.text, required this.isBot, this.options});
}

class ResumeChat extends StatefulWidget {
  @override
  _ResumeChatState createState() => _ResumeChatState();
}

class _ResumeChatState extends State<ResumeChat> {
  final List<Message> messages = [];
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int mainIndex = 0;
  int subIndex = -1;
  String currentCategory = 'main'; // main, project, education
  Map<String, dynamic> resumeData = {
    'projects': [],
    'education': [],
    'certificates': [],
    'papers': [],
  };

  // --- Questions Configuration ---
  final List<Map<String, dynamic>> mainQuestions = [
    {'key': 'name', 'question': 'What is your full name?', 'validate': (v) => v.length >= 3, 'error': 'Name must be at least 3 characters'},
    {'key': 'role', 'question': 'What is your current status?', 'options': ['Student', 'Fresher', 'Intern']},
    {'key': 'phone', 'question': 'What is your phone number?', 'keyboard': TextInputType.phone, 'validate': (v) => RegExp(r'^[6-9]\d{9}$').hasMatch(v), 'error': 'Enter a valid 10-digit number'},
    {'key': 'email', 'question': 'What is your email address?', 'validate': (v) => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v), 'error': 'Enter a valid email address'},
    {'key': 'profile_summary', 'question': 'Write a short summary about yourself (min 20 chars).', 'validate': (v) => v.length >= 20, 'error': 'Summary too short'},
    {'key': 'has_education', 'question': 'Would you like to add education details?', 'options': ['yes', 'no']},
    {'key': 'has_projects', 'question': 'Have you done any projects?', 'options': ['yes', 'no']},
  ];

  final List<Map<String, dynamic>> educationQs = [
    {'key': 'college', 'question': 'What is your College/University name?'},
    {'key': 'degree', 'question': 'What is your Degree? (e.g. BE, BSC)'},
    {'key': 'percentage', 'question': 'What is your Percentage or CGPA?', 'keyboard': TextInputType.number},
  ];

  final List<Map<String, dynamic>> projectQs = [
    {'key': 'title', 'question': 'What is the project title?'},
    {'key': 'technologies', 'question': 'Technologies used (comma separated)'},
    {'key': 'description', 'question': 'Describe the project in 2–3 lines.'},
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () => askQuestion());
  }

  void askQuestion() {
    String text = "";
    List<String>? options;

    if (currentCategory == 'main' && mainIndex < mainQuestions.length) {
      text = mainQuestions[mainIndex]['question'];
      options = mainQuestions[mainIndex]['options'];
    } else if (currentCategory == 'education' && subIndex < educationQs.length) {
      text = educationQs[subIndex]['question'];
    } else if (currentCategory == 'project' && subIndex < projectQs.length) {
      text = projectQs[subIndex]['question'];
    } else {
      finishChat();
      return;
    }
    setState(() => messages.add(Message(text: text, isBot: true, options: options)));
    scrollToBottom();
  }

  void handleAnswer(String val) {
    String input = val.trim();
    if (input.isEmpty) return;

    if (currentCategory == 'main') {
      var currentQ = mainQuestions[mainIndex];
      if (currentQ['validate'] != null && !currentQ['validate'](input)) {
        _showError(input, currentQ['error']);
        return;
      }
      setState(() {
        messages.add(Message(text: input, isBot: false));
        resumeData[currentQ['key']] = input;
      });

      // Branching logic
      if (currentQ['key'] == 'has_education' && input.toLowerCase() == 'yes') {
        currentCategory = 'education';
        subIndex = 0;
        resumeData['tempEdu'] = {};
      } else if (currentQ['key'] == 'has_projects' && input.toLowerCase() == 'yes') {
        currentCategory = 'project';
        subIndex = 0;
        resumeData['tempProject'] = {};
      } else {
        mainIndex++;
      }
    } else if (currentCategory == 'education') {
      setState(() {
        messages.add(Message(text: input, isBot: false));
        resumeData['tempEdu'][educationQs[subIndex]['key']] = input;
        subIndex++;
      });
      if (subIndex >= educationQs.length) {
        resumeData['education'].add(resumeData['tempEdu']);
        currentCategory = 'main';
        mainIndex++;
      }
    } else if (currentCategory == 'project') {
      setState(() {
        messages.add(Message(text: input, isBot: false));
        resumeData['tempProject'][projectQs[subIndex]['key']] = input;
        subIndex++;
      });
      if (subIndex >= projectQs.length) {
        resumeData['projects'].add(resumeData['tempProject']);
        currentCategory = 'main';
        mainIndex++;
      }
    }

    textController.clear();
    Future.delayed(Duration(milliseconds: 600), () => askQuestion());
  }

  void _showError(String input, String error) {
    setState(() {
      messages.add(Message(text: input, isBot: false));
      messages.add(Message(text: "❌ $error", isBot: true));
    });
    textController.clear();
    scrollToBottom();
  }

  void finishChat() {
    setState(() => messages.add(Message(text: 'Awesome! Redirecting to templates...', isBot: true)));
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResumeCompletedPage(userData: resumeData)),
      );
    });
  }

  void scrollToBottom() {
    Timer(Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keyboard type logic
    TextInputType currentKeyboard = TextInputType.text;
    if (currentCategory == 'main' && mainQuestions[mainIndex]['keyboard'] != null) {
      currentKeyboard = mainQuestions[mainIndex]['keyboard'];
    } else if (currentCategory == 'education' && subIndex >= 0 && educationQs[subIndex]['keyboard'] != null) {
      currentKeyboard = educationQs[subIndex]['keyboard'];
    }

    return Scaffold(
      backgroundColor: Color(0xFF101820),
      body: Column(
        children: [
          SizedBox(height: 25),
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: messages.length,
              itemBuilder: (context, i) => _buildChatBubble(messages[i]),
            ),
          ),
          _buildInputArea(currentKeyboard),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(children: [
            IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
            Text("Create Resume", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ]),
          LinearProgressIndicator(
            value: (mainIndex + 1) / mainQuestions.length,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Message msg) {
    bool isBot = msg.isBot;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(isBot ? "Internsharks" : "You", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          Row(
            mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (isBot) CircleAvatar(backgroundColor: Colors.cyanAccent, radius: 15, child: Icon(Icons.smart_toy, size: 18, color: Colors.black)),
              SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isBot ? Color(0xFF2D3E50) : Colors.cyanAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(msg.text, style: TextStyle(color: isBot ? Colors.white : Colors.black)),
                ),
              ),
            ],
          ),
          if (isBot && msg.options != null)
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 10),
              child: Wrap(
                spacing: 8,
                children: msg.options!.map((opt) => ActionChip(
                  label: Text(opt, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.cyanAccent,
                  onPressed: () => handleAnswer(opt),
                )).toList(),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildInputArea(TextInputType kType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Color(0xFF1E2732), borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              keyboardType: kType,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(hintText: 'Type here...', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 15)),
              onSubmitted: handleAnswer,
            ),
          ),
          IconButton(icon: Icon(Icons.send, color: Colors.cyanAccent), onPressed: () => handleAnswer(textController.text)),
        ],
      ),
    );
  }
}