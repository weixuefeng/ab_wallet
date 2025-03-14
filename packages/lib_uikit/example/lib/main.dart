import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.lightTheme, home: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  void _submit() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      ABCustomToast.show(
        context: context,
        message: 'Input: ${_controller.text}',
        position: ToastPosition.top,
      );
    } else {
      ABCustomToast.show(
        context: context,
        message: 'Input is empty!',
        position: ToastPosition.top,
      );
    }
  }

  bool _isLoading = false;
  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ABCustomDialog(
          title: 'Custom Dialog',
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ABBodyText(text: 'This is a custom dialog.'),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Enter something'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('Confirmed!');
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const ABHeadingText(text: 'UIKit Example')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ABBodyText(text: 'Welcome to UIKit!'),

                const SizedBox(height: 20),
                ABPrimaryButton(
                  text: 'Click Me',
                  onPressed: () {
                    _showCustomDialog(context);
                  },
                ),
                const SizedBox(height: 10),
                ABSecondaryButton(
                  text: 'Cancel',
                  onPressed: () {
                    print('Cancel clicked!');
                  },
                ),
                ABCustomIconButton(
                  icon: Icons.settings,
                  onPressed: () {
                    print('Settings button clicked!');
                  },
                  color: Colors.blue,
                  iconSize: 32.0,
                  tooltip: 'Settings',
                ),
                ABCustomCard(
                  child: Column(
                    children: [
                      const ABBodyText(text: 'This is a custom card.'),
                      const SizedBox(height: 10),
                      ABPrimaryButton(
                        text: 'Click Me',
                        onPressed: () {
                          print('Button clicked!');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ABCustomCard(
                  color: Colors.blue.withValues(alpha: 0.5),
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.all(24.0),
                  child: const ABBodyText(
                    text: 'Another custom card with custom styles.',
                  ),
                ),
                ABPrimaryButton(
                  text: 'Show Bottom Toast',
                  onPressed: () {
                    ABCustomToast.show(
                      context: context,
                      message: 'This is a bottom toast!',
                      position: ToastPosition.bottom,
                    );
                  },
                ),
                const SizedBox(height: 20),
                ABPrimaryButton(
                  text: 'Show Top Toast',
                  onPressed: () {
                    ABCustomToast.show(
                      context: context,
                      message: 'This is a top toast!',
                      position: ToastPosition.top,
                    );
                  },
                ),
                ABPrimaryButton(
                  text: _isLoading ? 'Hide Loading' : 'Show Loading',
                  onPressed: _toggleLoading,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ABTextField(
                          controller: _controller,
                          hintText: 'Enter your email',
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ABPrimaryButton(text: 'Submit', onPressed: _submit),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) const ABLoading(message: 'Loading...'),
        ],
      ),
    );
  }
}
