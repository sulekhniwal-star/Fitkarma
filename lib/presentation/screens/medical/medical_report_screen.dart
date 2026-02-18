import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/medical_report_entity.dart';
import '../../providers/medical/medical_report_bloc.dart';
import '../../providers/auth/auth_bloc.dart';
import '../../../core/constants/app_colors.dart';

class MedicalReportScreen extends StatefulWidget {
  const MedicalReportScreen({super.key});

  @override
  State<MedicalReportScreen> createState() => _MedicalReportScreenState();
}

class _MedicalReportScreenState extends State<MedicalReportScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      if (mounted) {
        context.read<MedicalReportBloc>().add(
          ExtractReportRequested(File(image.path)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as Authenticated).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Medical Reports')),
      body: BlocConsumer<MedicalReportBloc, MedicalReportState>(
        listener: (context, state) {
          if (state is MedicalReportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report saved successfully!')),
            );
            context.read<MedicalReportBloc>().add(GetReportsRequested(user.id));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
              ),
              if (state is MedicalReportLoading)
                const Center(child: CircularProgressIndicator())
              else if (state is MedicalReportExtracted)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Extracted Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...state.report.extractedData.entries.map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text('${e.key}: ${e.value}'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.indianGreen,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                final reportToSave = state.report;
                                // Fill in the user ID
                                final updatedReport = MedicalReportEntity(
                                  id: reportToSave.id,
                                  userId: user.id,
                                  reportTitle: reportToSave.reportTitle,
                                  extractedData: reportToSave.extractedData,
                                  date: reportToSave.date,
                                );
                                context.read<MedicalReportBloc>().add(
                                  SaveReportRequested(updatedReport),
                                );
                              },
                              child: const Text('Save Report'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // List of previous reports
              const Expanded(
                child: Center(child: Text('Past reports will appear here')),
              ),
            ],
          );
        },
      ),
    );
  }
}
