import 'package:flutter/material.dart';
import 'package:krishiyan/screen/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Delete Account",
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'poppins-semibold',
              fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded,
                size: 60, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              "Are you sure you want to delete your account?",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 20),
            const Text(
              "Please read the following before proceeding:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              "• Your account and all associated data will be permanently deleted within 48 hours.\n"
              "• You will not be able to access your account or recover any data after this period.\n"
              "• This action is irreversible.",
              style:
                  TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever),
              label: const Text("Confirm Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                // Navigate to a confirmation screen or back to login
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Account Deletion Requested"),
                    content: const Text(
                        "Your request has been received. Your account will be permanently deleted within 48 hours."),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.clear(); // Clear user data

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
