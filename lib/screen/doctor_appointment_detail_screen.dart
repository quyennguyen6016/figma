import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../services/appointment_service.dart';
import 'doctor_medical_records_screen.dart';

class DoctorAppointmentDetailScreen extends StatefulWidget {
  const DoctorAppointmentDetailScreen({required this.appointment, super.key});

  final Appointment appointment;

  @override
  State<DoctorAppointmentDetailScreen> createState() =>
      _DoctorAppointmentDetailScreenState();
}

class _DoctorAppointmentDetailScreenState
    extends State<DoctorAppointmentDetailScreen> {
  late String _selectedStatus;
  late TextEditingController _medicalNoteController;
  bool _isSaving = false;

  bool get _isLocked => widget.appointment.status == 'completed';

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.appointment.status;
    _medicalNoteController = TextEditingController(
      text: widget.appointment.medicalNote,
    );
  }

  @override
  void dispose() {
    _medicalNoteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });

    final success = await AppointmentService().updateAppointmentById(
      widget.appointment.id,
      status: _selectedStatus,
      medicalNote: _medicalNoteController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể cập nhật lịch hẹn.')),
      );
      return;
    }

    if (_selectedStatus == 'completed') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DoctorMedicalRecordsScreen(
            highlightAppointmentId: widget.appointment.id,
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF2145BF);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDEDED),
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
          'Lịch Hẹn',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF191C22),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'THÔNG TIN BỆNH NHÂN',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          // TODO(IMAGE): Replace this patient avatar icon with the patient's photo from profile.
                          Container(
                            width: 86,
                            height: 86,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF2563EB),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/patient_avatar.png', // TODO(IMAGE): change to your patient avatar asset path.
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.appointment.patientName,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.appointment.patientAge} tuổi, ${widget.appointment.patientGender}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    color: Color(0xFF475467),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Mã BN: ${widget.appointment.id.substring(0, 8).toUpperCase()}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
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
                const Divider(height: 1, color: Color(0xFFE4E7EC)),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CHI TIẾT CUỘC HẸN',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InfoLine(
                        icon: Icons.schedule,
                        text:
                            'Thời gian: ${widget.appointment.appointmentDate}, ${widget.appointment.appointmentTime}',
                      ),
                      const SizedBox(height: 12),
                      _InfoLine(
                        icon: Icons.medical_services_outlined,
                        text: 'Loại: ${widget.appointment.appointmentType}',
                      ),
                      const SizedBox(height: 12),
                      const _InfoLine(
                        icon: Icons.description_outlined,
                        text: 'Lý do:',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE4E7EC)),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.assignment_outlined, color: brand),
                          SizedBox(width: 8),
                          Text(
                            'THÔNG TIN KHÁM',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF101828),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _medicalNoteController,
                        enabled: !_isLocked,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Nhập kết quả khám, chẩn đoán, ghi chú...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF98A2B3),
                          ),
                          filled: true,
                          fillColor: _isLocked
                              ? const Color(0xFFF8FAFC)
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'SET TRẠNG THÁI LỊCH HẸN',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStatus,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.access_time,
                            color: brand,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFB2CCFF),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFB2CCFF),
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFEAF1FF),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'pending',
                            child: Text('Trạng thái: Chưa đến'),
                          ),
                          DropdownMenuItem(
                            value: 'in_progress',
                            child: Text('Trạng thái: Đang khám'),
                          ),
                          DropdownMenuItem(
                            value: 'completed',
                            child: Text('Trạng thái: Đã xong'),
                          ),
                          DropdownMenuItem(
                            value: 'cancelled',
                            child: Text('Trạng thái: Đã hủy'),
                          ),
                        ],
                        onChanged: _isLocked
                            ? null
                            : (value) {
                                if (value == null) return;
                                setState(() {
                                  _selectedStatus = value;
                                });
                              },
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLocked || _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brand,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _isLocked
                                      ? 'Đã hoàn thành'
                                      : 'Cập nhật trạng thái',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      if (_isLocked)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Lịch hẹn đã hoàn thành, không thể chỉnh sửa thêm.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF2563EB), size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              color: Color(0xFF101828),
            ),
          ),
        ),
      ],
    );
  }
}
