import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../services/appointment_service.dart';
import 'doctor_appointment_detail_screen.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final all = await AppointmentService().getAllAppointments();
    if (!mounted) return;
    setState(() {
      appointments = all;
    });
  }

  Future<void> _openDetail(Appointment appointment) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DoctorAppointmentDetailScreen(appointment: appointment),
      ),
    );

    if (changed == true && mounted) {
      await _loadAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
        ),
        title: const Text(
          'Lich hen',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Danh sach lich hen',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              if (appointments.isEmpty)
                Center(
                  child: Text(
                    'Khong co lich hen',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                )
              else
                ...appointments.map(
                  (appointment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AppointmentCard(
                      appointment: appointment,
                      onTap: () => _openDetail(appointment),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment, required this.onTap});

  final Appointment appointment;
  final VoidCallback onTap;

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFFF9500);
      case 'in_progress':
        return const Color(0xFF2145BF);
      case 'cancelled':
        return const Color(0xFFE53935);
      case 'completed':
        return const Color(0xFF12B76A);
      default:
        return const Color(0xFF8A8A8A);
    }
  }

  String _getDisplayStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Dang cho';
      case 'in_progress':
        return 'Dang kham';
      case 'cancelled':
        return 'Huy';
      case 'completed':
        return 'Da xong';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(appointment.status);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${appointment.patientName}, ${appointment.patientAge} tuoi, ${appointment.patientGender}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getDisplayStatus(appointment.status),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.black.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  '${appointment.appointmentTime} | ${appointment.appointmentType}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.65),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Color(0xFF98A2B3)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
