import 'package:flutter/material.dart';

class SuccessAppointmentDialog extends StatelessWidget {
  const SuccessAppointmentDialog({
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    this.onDone,
    this.onEdit,
    super.key,
  });

  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;
  final VoidCallback? onDone;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thumbs up icon in circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD6E4FF),
                ),
                child: const Icon(
                  Icons.thumb_up,
                  size: 60,
                  color: Color(0xFF2145BF),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Cảm ơn !',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'Bạn đã đặt lịch thành công',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5B6B82),
                ),
              ),
              const SizedBox(height: 16),

              // Appointment details
              Text(
                'Bạn đã đặt cuộc hẹn với $doctorName\nvào ngày $appointmentDate, lúc $appointmentTime',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8A8A8A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Done button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onDone ?? () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2145BF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Hoàn thành',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Edit link
              TextButton(
                onPressed: onEdit,
                child: const Text(
                  'Edit your appointment',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A8A8A),
                    decoration: TextDecoration.underline,
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
