import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _introductionController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _registrationNoController = TextEditingController();
  final _aadharController = TextEditingController();
  final _mobileController = TextEditingController();
  final _referenceController = TextEditingController();

  String? _selectedGender;
  String? _maritalStatus;
  String? _onBehalfOf;
  DateTime? _selectedDate;
  File? _imageFile;

  final _genders = const ['Male', 'Female', 'Other'];
  final _maritalStatuses = const [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
    'Separated',
  ];
  final _onBehalfOptions = const ['Myself', 'Parents'];

  // Validation rules
  static final _nameRegExp = RegExp(r'^[a-zA-Z ]{2,30}$');
  static final _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final _aadharRegExp = RegExp(r'^\d{12}$');
  static final _mobileRegExp = RegExp(r'^\d{10}$');
  static final _registrationNoRegExp = RegExp(r'^[A-Z0-9]{6,}$');

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    if (!_nameRegExp.hasMatch(value)) {
      return '$fieldName must be 2-30 characters long and contain only letters';
    }
    return null;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Image picking error: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(122, 31, 31, 1), // Deep maroon
              Color.fromRGBO(200, 80, 80, 0.85), // Lighter maroon
              Color.fromRGBO(240, 180, 180, 0.7), // Very light maroon/pink
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Photo Section
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                                  _imageFile != null
                                      ? FileImage(_imageFile!)
                                      : null,
                              child:
                                  _imageFile == null
                                      ? const Icon(Icons.person, size: 60)
                                      : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: _showImageSourceDialog,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Basic Information Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '1. Basic Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(122, 31, 31, 1),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _registrationNoController,
                              decoration: const InputDecoration(
                                labelText: 'Registration Number*',
                                hintText: 'Enter offline registration number',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.numbers),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter registration number';
                                }
                                if (!_registrationNoRegExp.hasMatch(value)) {
                                  return 'Invalid registration number format';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _aadharController,
                              decoration: const InputDecoration(
                                labelText: 'Aadhar Number*',
                                hintText: '12-digit Aadhar number',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.credit_card),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Aadhar number';
                                }
                                if (!_aadharRegExp.hasMatch(value)) {
                                  return 'Invalid Aadhar number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _onBehalfOf,
                              decoration: const InputDecoration(
                                labelText: 'Registering on behalf of*',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              items:
                                  _onBehalfOptions.map((option) {
                                    return DropdownMenuItem(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _onBehalfOf = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select an option';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _mobileController,
                              decoration: const InputDecoration(
                                labelText: 'Mobile Number*',
                                hintText: '10-digit mobile number',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter mobile number';
                                }
                                if (!_mobileRegExp.hasMatch(value)) {
                                  return 'Invalid mobile number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _referenceController,
                              decoration: const InputDecoration(
                                labelText: 'Reference',
                                hintText: 'How did you hear about us?',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.people_outline),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Personal Information Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '2. Personal Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(122, 31, 31, 1),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'First Name*',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator:
                                        (value) =>
                                            _validateName(value, 'first name'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: _middleNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Middle Name',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.person_outline),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name*',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator:
                                  (value) => _validateName(value, 'last name'),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedGender,
                                    decoration: const InputDecoration(
                                      labelText: 'Gender*',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.people),
                                    ),
                                    items:
                                        _genders.map((gender) {
                                          return DropdownMenuItem(
                                            value: gender,
                                            child: Text(gender),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select gender';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: _dateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Date of Birth*',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.calendar_today),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _selectedDate ?? DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (picked != null &&
                                          picked != _selectedDate) {
                                        setState(() {
                                          _selectedDate = picked;
                                          _dateController.text = DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(picked);
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select date';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email*',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                if (!_emailRegExp.hasMatch(value)) {
                                  return 'Invalid email format';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _maritalStatus,
                              decoration: const InputDecoration(
                                labelText: 'Marital Status*',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.family_restroom),
                              ),
                              items:
                                  _maritalStatuses.map((status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _maritalStatus = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select marital status';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Introduction Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '3. Introduction',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(122, 31, 31, 1),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _introductionController,
                              maxLines: 4,
                              maxLength: 500,
                              decoration: const InputDecoration(
                                hintText:
                                    'Write a brief introduction about yourself...',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value != null && value.length < 10) {
                                  return 'Introduction must be at least 10 characters';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                              122,
                              31,
                              31,
                              1,
                            ),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final formData = {
                                'registrationNo':
                                    _registrationNoController.text,
                                'aadharNo': _aadharController.text,
                                'onBehalfOf': _onBehalfOf,
                                'mobileNo': _mobileController.text,
                                'reference': _referenceController.text,
                                'firstName': _firstNameController.text,
                                'middleName': _middleNameController.text,
                                'lastName': _lastNameController.text,
                                'gender': _selectedGender,
                                'dateOfBirth': _dateController.text,
                                'email': _emailController.text,
                                'maritalStatus': _maritalStatus,
                                'introduction': _introductionController.text,
                                'hasProfilePhoto': _imageFile != null,
                              };

                              debugPrint('Form Data: $formData');

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing Registration'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Submit Registration',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _introductionController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    _registrationNoController.dispose();
    _aadharController.dispose();
    _mobileController.dispose();
    _referenceController.dispose();
    super.dispose();
  }
}
