import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
class ManageLinkedAccountsPage extends StatefulWidget {
  const ManageLinkedAccountsPage({super.key});

  @override
  State<ManageLinkedAccountsPage> createState() => _ManageLinkedAccountsPageState();
}

class _ManageLinkedAccountsPageState extends State<ManageLinkedAccountsPage> {
  List<LinkedAccount> accounts = [
    LinkedAccount(
      name: 'Google',
      isLinked: true,
      icon: 'lib/assets/images/google_icon.png', // Add your Google icon
    ),
    LinkedAccount(
      name: 'LinkedIn',
      isLinked: true,
      icon: 'lib/assets/images/linkedin_icon.png', // Add your LinkedIn icon
    ),
    LinkedAccount(
      name: 'GitHub',
      isLinked: false,
      icon: 'lib/assets/images/github_icon.png', // Add your GitHub icon
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
                ),
                const SizedBox(width: 5),
                Text("Manage Linked Accounts", style: AppTextStyles.yellow24Bold),
              ],
            ),


            // Accounts List
            Expanded(
              child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  return _buildAccountCard(accounts[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(LinkedAccount account, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF3A3A3A),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Account Icon
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(account.name),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: _getAccountIcon(account.name,),
            ),
          ),
          const SizedBox(width: 16),

          // Account Name and Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  account.isLinked ? 'Linked' : 'Not Linked',
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          // Link/Unlink Button
          account.isLinked
              ? InkWell(
            onTap: () => _showUnlinkDialog(account, index),
            child: const Text(
              'Unlink',
              style: TextStyle(
                color: Color(0xFFFF4444),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
              : ElevatedButton(
            onPressed: () => _linkAccount(account, index),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Link',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getIconBackgroundColor(String accountName) {
    switch (accountName) {
      case 'Google':
        return Colors.white;
      case 'LinkedIn':
        return const Color(0xFF0A66C2);
      case 'GitHub':
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  Widget _getAccountIcon(String accountName) {
    // You can replace these with actual image assets
    switch (accountName) {
      case 'Google':
        return const Icon(Icons.g_mobiledata, color: Colors.blue, size: 40);
      case 'LinkedIn':
        return const Text(
          'in',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'GitHub':
        return const Icon(Icons.code, color: Colors.black, size: 32);
      default:
        return const Icon(Icons.link, color: Colors.white, size: 32);
    }
  }

  void _linkAccount(LinkedAccount account, int index) {
    setState(() {
      accounts[index].isLinked = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${account.name} linked successfully')),
    );
  }

  void _showUnlinkDialog(LinkedAccount account, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Unlink Account',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to unlink ${account.name}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                accounts[index].isLinked = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${account.name} unlinked successfully')),
              );
            },
            child: const Text(
              'Unlink',
              style: TextStyle(color: Color(0xFFFF4444)),
            ),
          ),
        ],
      ),
    );
  }
}

class LinkedAccount {
  String name;
  bool isLinked;
  String icon;

  LinkedAccount({
    required this.name,
    required this.isLinked,
    required this.icon,
  });
}