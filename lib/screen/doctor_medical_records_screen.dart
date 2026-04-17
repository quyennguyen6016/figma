import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../services/appointment_service.dart';

class DoctorMedicalRecordsScreen extends StatefulWidget {
  const DoctorMedicalRecordsScreen({this.highlightAppointmentId, super.key});

  final String? highlightAppointmentId;

  @override
  State<DoctorMedicalRecordsScreen> createState() =>
      _DoctorMedicalRecordsScreenState();
}

class _DoctorMedicalRecordsScreenState
    extends State<DoctorMedicalRecordsScreen> {
  List<Appointment> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final all = await AppointmentService().getAllAppointments();
    if (!mounted) return;

    setState(() {
      _records = all.where((item) => item.status == 'completed').toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: const Text(
          'Bệnh án',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _records.isEmpty
            ? const Center(
                child: Text(
                  'Chưa có bệnh án nào',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xFF7A7A7A),
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _records.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final record = _records[i];
                  final highlighted =
                      record.id == widget.highlightAppointmentId;

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: highlighted
                          ? const Color(0xFFEAF1FF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: highlighted
                            ? const Color(0xFF2145BF)
                            : const Color(0xFFE8E8E8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${record.patientName} - ${record.patientAge} tuổi, ${record.patientGender}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${record.specialty} | ${record.appointmentDate} | ${record.appointmentTime}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Color(0xFF5F6875),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Ghi chú khám',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2145BF),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.medicalNote.trim().isEmpty
                              ? 'Không có ghi chú'
                              : record.medicalNote,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Color(0xFF1B1D22),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
