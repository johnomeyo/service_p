import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_p/mainscreen.dart';
import 'dart:io';

import 'package:service_p/pages/home_page.dart'; // Required for File

// --- 1. Data Model for Collected Information ---
// This model will hold all the data gathered during onboarding.
class OnboardedBusinessProfile {
  String name;
  String? logoPath; // Path to the uploaded image
  String about;
  String description;
  String openingTime;
  String closingTime;
  String location;
  List<String> availableServices;

  OnboardedBusinessProfile({
    this.name = '',
    this.logoPath,
    this.about = '',
    this.description = '',
    this.openingTime = '',
    this.closingTime = '',
    this.location = '',
    this.availableServices = const [],
  });

  // A method to convert the collected data to a map (useful for sending to backend)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logoPath': logoPath,
      'about': about,
      'description': description,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'location': location,
      'availableServices': availableServices,
    };
  }
}

// --- 2. Main Onboarding Page (Stateful Widget) ---
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final _formKeys = List.generate(4, (index) => GlobalKey<FormState>()); // One form key per step
  int _currentPage = 0;
  final OnboardedBusinessProfile _profileData = OnboardedBusinessProfile();
  File? _pickedLogo; // To hold the actual file for display

  // Image Picker instance
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedLogo = File(image.path);
        _profileData.logoPath = image.path; // Store path in data model
      });
    }
  }

  // Handle Time Picking
  Future<void> _pickTime(BuildContext context, bool isOpeningTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final formattedTime = picked.format(context);
        if (isOpeningTime) {
          _profileData.openingTime = formattedTime;
        } else {
          _profileData.closingTime = formattedTime;
        }
      });
    }
  }

  void _nextPage() {
    if (_formKeys[_currentPage].currentState?.validate() ?? false) {
      _formKeys[_currentPage].currentState?.save(); 
      if (_currentPage < 3) { 
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        _submitOnboarding();
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _submitOnboarding() {
    // This is where you would typically send _profileData to your backend
    // For this example, we'll just print it and show a success message.
    debugPrint('Onboarding Data: ${_profileData.toJson()}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile created successfully for ${_profileData.name}!',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
    // You might navigate to the main app page here
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Mainscreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Business Profile',
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                // Step 1: Basic Information
                OnboardingStep(
                  formKey: _formKeys[0],
                  title: 'Tell Us About Your Business',
                  fields: [
                    CustomTextField(
                      labelText: 'Business Name',
                      hintText: 'e.g., Elite Barber & Spa',
                      validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
                      onSaved: (value) => _profileData.name = value!,
                    ),
                    const SizedBox(height: 16),
                    CustomImagePicker(
                      labelText: 'Business Logo',
                      pickedImage: _pickedLogo,
                      onPickImage: _pickImage,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      labelText: 'About Your Business (Tagline)',
                      hintText: 'e.g., Your premier destination for grooming and relaxation.',
                      validator: (value) => value!.isEmpty ? 'About section cannot be empty' : null,
                      onSaved: (value) => _profileData.about = value!,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      labelText: 'Detailed Description',
                      hintText: 'Describe your services, unique selling points, etc.',
                      maxLines: 4,
                      validator: (value) => value!.isEmpty ? 'Description cannot be empty' : null,
                      onSaved: (value) => _profileData.description = value!,
                    ),
                  ],
                ),

                // Step 2: Location & Hours
                OnboardingStep(
                  formKey: _formKeys[1],
                  title: 'Where & When You Operate',
                  fields: [
                    CustomTextField(
                      labelText: 'Business Location / Address',
                      hintText: 'e.g., 123 Main St, Anytown, CA',
                      validator: (value) => value!.isEmpty ? 'Location cannot be empty' : null,
                      onSaved: (value) => _profileData.location = value!,
                    ),
                    const SizedBox(height: 16),
                    CustomTimePickerField(
                      labelText: 'Opening Time',
                      timeValue: _profileData.openingTime,
                      onTap: () => _pickTime(context, true),
                      validator: (value) => value!.isEmpty ? 'Opening time is required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTimePickerField(
                      labelText: 'Closing Time',
                      timeValue: _profileData.closingTime,
                      onTap: () => _pickTime(context, false),
                      validator: (value) => value!.isEmpty ? 'Closing time is required' : null,
                    ),
                  ],
                ),

                // Step 3: Available Services
                OnboardingStep(
                  formKey: _formKeys[2],
                  title: 'What Services Do You Offer?',
                  fields: [
                    ServicesInput(
                      initialServices: _profileData.availableServices,
                      onServicesChanged: (services) {
                        _profileData.availableServices = services;
                      },
                    ),
                  ],
                ),

                // Step 4: Ready to Go!
                OnboardingStep(
                  formKey: _formKeys[3], 
                  title: '',
                  fields: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 32),
                          Text("Congratulations!", 
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 24),
                          Icon(
                            Icons.check_circle_outline,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Your business profile is ready!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'You can always edit your information later from your profile page.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Progress Indicator (Dots)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => _buildDot(index, context)),
            ),
          ),
          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousPage,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        side: BorderSide(color: Theme.of(context).colorScheme.outline),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_currentPage == 3 ? 'Finish' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

// --- 3. Reusable Widgets for Onboarding Steps ---

/// A generic container for each onboarding step.
class OnboardingStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  final List<Widget> fields;

  const OnboardingStep({
    super.key,
    required this.formKey,
    required this.title,
    required this.fields,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            ...fields, // Spread the list of field widgets
          ],
        ),
      ),
    );
  }
}

/// Custom styled TextFormField.
class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.hintText = '',
    this.maxLines = 1,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      cursorColor: Theme.of(context).colorScheme.primary,
    );
  }
}

/// Widget for picking and displaying an image (e.g., business logo).
class CustomImagePicker extends StatelessWidget {
  final String labelText;
  final File? pickedImage;
  final VoidCallback onPickImage;

  const CustomImagePicker({
    super.key,
    required this.labelText,
    this.pickedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: pickedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      pickedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to upload logo',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

/// Custom styled TextFormField for displaying and picking time.
class CustomTimePickerField extends StatelessWidget {
  final String labelText;
  final String timeValue;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  const CustomTimePickerField({
    super.key,
    required this.labelText,
    required this.timeValue,
    required this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true, // Make it read-only so user can only pick time
      controller: TextEditingController(text: timeValue),
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      onTap: onTap,
      validator: validator,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      cursorColor: Theme.of(context).colorScheme.primary,
    );
  }
}

/// Widget for adding and displaying a list of services using chips.
class ServicesInput extends StatefulWidget {
  final List<String> initialServices;
  final ValueChanged<List<String>> onServicesChanged;

  const ServicesInput({
    super.key,
    required this.initialServices,
    required this.onServicesChanged,
  });

  @override
  State<ServicesInput> createState() => _ServicesInputState();
}

class _ServicesInputState extends State<ServicesInput> {
  final TextEditingController _serviceController = TextEditingController();
  final List<String> _services = []; // Internal state for services

  @override
  void initState() {
    super.initState();
    _services.addAll(widget.initialServices); // Initialize with passed services
  }

  void _addService() {
    if (_serviceController.text.trim().isNotEmpty) {
      setState(() {
        _services.add(_serviceController.text.trim());
        _serviceController.clear();
        widget.onServicesChanged(_services); // Notify parent
      });
    }
  }

  void _removeService(String service) {
    setState(() {
      _services.remove(service);
      widget.onServicesChanged(_services); // Notify parent
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _serviceController,
                labelText: 'Add a Service',
                hintText: 'e.g., Haircut, Massage, Nail Care',
                onSaved: (value) {}, // Not using onSaved for this field directly
                validator: (value) {
                  // Only validate if no services have been added yet
                  if (_services.isEmpty && value!.trim().isEmpty) {
                    return 'Please add at least one service.';
                  }
                  return null;
                },
                // onFieldSubmitted: (_) => _addService(), // Add on enter
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 56, // Match text field height
              child: ElevatedButton(
                onPressed: _addService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_services.isEmpty)
          Text(
            'No services added yet. Add at least one to continue.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _services.map((service) {
            return Chip(
              label: Text(service),
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              onDeleted: () => _removeService(service),
              deleteIcon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _serviceController.dispose();
    super.dispose();
  }
}