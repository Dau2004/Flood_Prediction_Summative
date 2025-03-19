import 'package:flutter/material.dart';
import '../services/api_service.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, int> inputValues = {};
  // Add controllers to keep track of values
  final Map<String, TextEditingController> _controllers = {};
  bool isLoading = false;
  String? errorMessage;
  
  // Define all required parameters with descriptions
  final List<Map<String, String>> parameters = [
    {'name': 'MonsoonIntensity', 'description': 'Intensity of monsoon (0-15)'},
    {'name': 'TopographyDrainage', 'description': 'Quality of topography drainage (0-15)'},
    {'name': 'RiverManagement', 'description': 'Quality of river management (0-15)'},
    {'name': 'Deforestation', 'description': 'Level of deforestation (0-15)'},
    {'name': 'Urbanization', 'description': 'Level of urbanization (0-15)'},
    {'name': 'ClimateChange', 'description': 'Impact of climate change (0-15)'},
    {'name': 'DamsQuality', 'description': 'Quality of dams (0-15)'},
    {'name': 'Siltation', 'description': 'Level of siltation (0-15)'},
    {'name': 'AgriculturalPractices', 'description': 'Quality of agricultural practices (0-15)'},
    {'name': 'Encroachments', 'description': 'Level of encroachments (0-15)'},
    {'name': 'IneffectiveDisasterPreparedness', 'description': 'Level of ineffective disaster preparedness (0-15)'},
    {'name': 'DrainageSystems', 'description': 'Quality of drainage systems (0-15)'},
    {'name': 'CoastalVulnerability', 'description': 'Level of coastal vulnerability (0-15)'},
    {'name': 'Landslides', 'description': 'Risk of landslides (0-15)'},
    {'name': 'Watersheds', 'description': 'Quality of watersheds (0-15)'},
    {'name': 'DeterioratingInfrastructure', 'description': 'Level of deteriorating infrastructure (0-15)'},
    {'name': 'PopulationScore', 'description': 'Population density score (0-15)'},
    {'name': 'WetlandLoss', 'description': 'Level of wetland loss (0-15)'},
    {'name': 'InadequatePlanning', 'description': 'Level of inadequate planning (0-15)'},
    {'name': 'PoliticalFactors', 'description': 'Impact of political factors (0-15)'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for all fields with default values
    for (var param in parameters) {
      // Default value of 7 (middle of the range)
      _controllers[param['name']!] = TextEditingController(text: "7");
    }
  }
  
  @override
  void dispose() {
    // Clean up controllers
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Assessment Factors'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: parameters.length,
                        itemBuilder: (context, index) {
                          final param = parameters[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: _controllers[param['name']],  // Use the controller
                              decoration: InputDecoration(
                                labelText: param['name'],
                                helperText: param['description'],
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                final number = int.tryParse(value);
                                if (number == null) {
                                  return 'Please enter a valid number';
                                }
                                if (number < 0 || number > 15) {
                                  return 'Value must be between 0 and 15';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                inputValues[param['name']!] = int.parse(value!);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Predict', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Make sure all fields are included by getting values directly from controllers
      for (var param in parameters) {
        String fieldName = param['name']!;
        String value = _controllers[fieldName]!.text;
        inputValues[fieldName] = int.parse(value);
      }
      
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      try {
        print("Submitting data: ${inputValues}");  // Debug print
        final result = await ApiService.predictFlood(inputValues);
        if (!mounted) return;
        
        Navigator.pushNamed(
          context, 
          '/results',
          arguments: result,
        );
      } catch (e) {
        setState(() {
          errorMessage = 'Error: ${e.toString()}';
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}