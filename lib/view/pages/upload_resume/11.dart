import 'package:flutter/material.dart';

class ResumePreviewScreen extends StatefulWidget {
  const ResumePreviewScreen({Key? key}) : super(key: key);

  @override
  State<ResumePreviewScreen> createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Resume',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFC107),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.emoji_events, size: 14, color: Colors.black),
                SizedBox(width: 4),
                Text(
                  'Credit : 100',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Resume Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Decorative dots at top
                        Padding(
                          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: Row(
                            children: [
                              _buildDot(Colors.green),
                              const SizedBox(width: 4),
                              _buildDot(Colors.yellow),
                              const SizedBox(width: 4),
                              _buildDot(Colors.orange),
                              const SizedBox(width: 4),
                              _buildDot(Colors.red),
                              const SizedBox(width: 4),
                              _buildDot(Colors.purple),
                              const SizedBox(width: 4),
                              _buildDot(Colors.blue),
                            ],
                          ),
                        ),
                        // Resume Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              const Center(
                                child: Text(
                                  'Anantha Krishnan',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Title
                              const Center(
                                child: Text(
                                  'Flutter Developer',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Contact Info
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8,
                                  children: const [
                                    Text('Chennai, Tamil Nadu', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                    Text('|', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                    Text('anantha@email.com', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                    Text('|', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                    Text('9876543210', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Divider(height: 1, color: Colors.black12),
                              const SizedBox(height: 16),

                              // Career Summary
                              _buildSectionTitle('CAREER SUMMARY'),
                              const SizedBox(height: 8),
                              _buildBodyText(
                                'A Flutter Developer with 2+ years of experience in developing and deploying scalable, cross-platform mobile applications. Skilled in Dart, Flutter framework, state management, and API integration. Proven track record of delivering high-quality applications with clean code and efficient performance.',
                              ),
                              const SizedBox(height: 16),

                              // Skills
                              _buildSectionTitle('SKILLS'),
                              const SizedBox(height: 8),
                              _buildBodyText(
                                '• Dart, Flutter, Firebase, iOS, Mobilebeacon, REST APIs\n'
                                    '• State Management: Provider, Riverpod, GetX\n'
                                    '• Git, GitHub, CI/CD, Agile, Scrum, Jira\n'
                                    '• UI/UX Design, Responsive Design, Material Design, Cubit/Bloc, E-Comm',
                              ),
                              const SizedBox(height: 16),

                              // Experience
                              _buildSectionTitle('EXPERIENCE'),
                              const SizedBox(height: 8),
                              _buildBodyText(
                                'ABC Chennai\n'
                                    'Flutter Developer | Jan 2022 - Present\n\n'
                                    '• Developed and maintained multiple cross-platform mobile applications\n'
                                    '• Collaborated with designers and backend developers to implement features\n'
                                    '• Optimized app performance and reduced loading times by 40%\n'
                                    '• Implemented state management using Riverpod and GetX',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton(Icons.favorite_border, () {}),
                        const SizedBox(width: 16),
                        _buildActionButton(Icons.share_outlined, () {}),
                        const SizedBox(width: 16),
                        _buildActionButton(Icons.download_outlined, () {}),
                        const SizedBox(width: 16),
                        _buildActionButton(Icons.more_vert, () {}),
                        const SizedBox(width: 16),
                        _buildAIButton(() {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Wow Text
                  const Text(
                    'Wow! Your Ready to Impress..!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Your resume stands out, perfectly crafted to catch employer\'s eyes, highlighting your unique strengths and achievements. You\'re ready to make a lasting impression!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // AI Resume Assistant Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF00BCD4).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'AI Resume Assistant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Revise and improve my resume. Make it professional, well-formatted, ATS-friendly. Suggest better phrasing, remove errors, improve tone and word choices. Strengthen my resume to get noticed by employers.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00BCD4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Continue Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BCD4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildAIButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Color(0xFF00BCD4),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.auto_awesome,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}