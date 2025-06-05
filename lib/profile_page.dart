import 'package:flutter/material.dart';
import 'dart:io';
import 'registration_page.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> formData;

  const ProfilePage({super.key, required this.formData});

  @override
  Widget build(BuildContext context) {
    final File? profilePhoto = formData['profilePhoto'] as File?;
    final String firstName = formData['firstName'] ?? '';
    final String middleName = formData['middleName'] ?? '';
    final String lastName = formData['lastName'] ?? '';
    final String fullName = [
      firstName,
      middleName,
      lastName,
    ].where((s) => s.isNotEmpty).join(' ');
    final String introduction = formData['introduction'] ?? '';
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      profilePhoto != null ? FileImage(profilePhoto) : null,
                  child:
                      profilePhoto == null
                          ? const Icon(Icons.person, size: 48)
                          : null,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => RegistrationPage(
                                        key: UniqueKey(),
                                        formData: formData,
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Profile'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Implement share profile functionality
                            },
                            icon: const Icon(Icons.share),
                            label: const Text('Share Profile'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Introduction',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(introduction, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
