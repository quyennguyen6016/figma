import 'package:flutter/material.dart';
import '../widgets/success_appointment_dialog.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';
import '../services/auth_service.dart';
import 'package:uuid/uuid.dart';

class OphthalmologyScheduleScreen extends StatelessWidget {
  const OphthalmologyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = <Doctor>[
      const Doctor(
        name: 'Bác sĩ Phạm Văn Tân',
        title: 'BS CKII',
        experience: '10 năm kinh nghiệm',
        schedule: '9 : 00 sáng',
        accent: Color(0xFF2E7DFF),
      ),
      const Doctor(
        name: 'Bác sĩ Nguyễn Thị Hương',
        title: 'Tiến sĩ',
        experience: '14 năm kinh nghiệm',
        schedule: '8 : 30 sáng',
        accent: Color(0xFF1E88E5),
      ),
      const Doctor(
        name: 'Bác sĩ Bùi Vũ Hùng',
        title: 'Thạc sĩ',
        experience: '15 năm kinh nghiệm',
        schedule: '10 : 00 sáng',
        accent: Color(0xFF43A047),
      ),
      const Doctor(
        name: 'Bác sĩ Hoàng Thị Minh Châu',
        title: 'Bác sĩ',
        experience: '8 năm kinh nghiệm',
        schedule: '11 : 00 sáng',
        accent: Color(0xFFE53935),
      ),
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopBar(title: 'Mắt'),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              itemCount: doctors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _DoctorCard(
                doctor: doctors[i],
                brand: const Color(0xFF2145BF),
                onBook: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OphthalmologyDoctorScheduleScreen(
                        doctor: doctors[i],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OphthalmologyDoctorScheduleScreen extends StatefulWidget {
  const OphthalmologyDoctorScheduleScreen({
    required this.doctor,
    super.key,
  });

  final Doctor doctor;

  @override
  State<OphthalmologyDoctorScheduleScreen> createState() =>
      _OphthalmologyDoctorScheduleScreenState();
}

class _OphthalmologyDoctorScheduleScreenState
    extends State<OphthalmologyDoctorScheduleScreen> {
  // "today" disabled like the screenshot
  bool _dayTomorrow = true;
  String? _selectedTimeMorning;
  String? _selectedTimeAfternoon;

  final morningTimes = const [
    '8:00 PM',
    '8:30 PM',
    '9:00 PM',
    '9:30 PM',
    '10:00 PM',
    '10:30 PM',
  ];

  final afternoonTimes = const [
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final Color brand = const Color(0xFF2145BF);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           _TopBar(title: 'Mắt'),
          const SizedBox(height: 10),

          // Doctor header card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // TODO: Replace with doctor photo image asset
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: widget.doctor.accent.withOpacity(0.15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/doctor_photo.png', // TODO(IMAGE): change to doctor photo asset path.
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 44,
                              color: widget.doctor.accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.doctor.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.doctor.title,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.doctor.experience,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          Icons.star,
                          size: 18,
                          color: const Color(0xFFFFB300),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '(5/5)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8A8A8A),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFFBDBDBD)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Day selector chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _DayChip(
                    text: 'Hôm nay, 11/4',
                    subText: 'đã hết chỗ trống',
                    selected: false,
                    brand: brand,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DayChip(
                    text: 'Ngày mai, 12/4',
                    subText: 'còn chỗ trống',
                    selected: _dayTomorrow,
                    brand: brand,
                    onTap: () {
                      setState(() {
                        _dayTomorrow = true;
                        _selectedTimeMorning = null;
                        _selectedTimeAfternoon = null;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Text(
                  'Ngày mai, 12/4',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                _ShiftTimes(
                  title: 'Buổi sáng - 6 chỗ trống',
                  times: morningTimes,
                  selectedTime: _selectedTimeMorning,
                  onSelected: (t) =>
                      setState(() => _selectedTimeMorning = t),
                ),
                const SizedBox(height: 14),
                _ShiftTimes(
                  title: 'Buổi chiều - 5 chỗ trống',
                  times: afternoonTimes,
                  selectedTime: _selectedTimeAfternoon,
                  onSelected: (t) =>
                      setState(() => _selectedTimeAfternoon = t),
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),

          // Bottom booking button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final selectedTime = _selectedTimeMorning ?? _selectedTimeAfternoon;

                  if (selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn giờ khám')),
                    );
                    return;
                  }

                  final user = await AuthService().getCurrentUser();
                  if (!context.mounted) return;
                  if (user == null || !user.hasCompleteBookingProfile) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Vui lòng điền đầy đủ hồ sơ cá nhân trước khi đặt lịch.',
                        ),
                      ),
                    );
                    return;
                  }

                  final age = user.age;
                  if (age == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ngày sinh không hợp lệ, không thể đặt lịch.'),
                      ),
                    );
                    return;
                  }

                  // Create and save appointment
                  final appointment = Appointment(
                    id: const Uuid().v4(), // Generate unique ID
                    patientName: user.fullName,
                    patientAge: age,
                    patientGender: user.genderLabel,
                    doctorName: widget.doctor.name,
                    specialty: 'Mắt',
                    appointmentDate: 'ngày 12/4',
                    appointmentTime: selectedTime,
                    appointmentType: 'Tái khám định kỳ',
                    status: 'pending',
                  );

                  // Save to backend
                  final saved = await AppointmentService().saveAppointment(appointment);

                  if (!context.mounted) return;
                  if (!saved) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Không thể đặt lịch. Vui lòng kiểm tra lại hồ sơ.'),
                      ),
                    );
                    return;
                  }

                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => SuccessAppointmentDialog(
                        doctorName: widget.doctor.name,
                        appointmentDate: 'ngày 12/4',
                        appointmentTime: 'lúc $selectedTime chiều',
                        onDone: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        onEdit: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: brand,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text(
                  'ĐẶT LỊCH',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.text,
    required this.subText,
    required this.selected,
    required this.brand,
    this.onTap,
  });

  final String text;
  final String subText;
  final bool selected;
  final Color brand;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? brand : Colors.white;
    final fg = selected ? Colors.white : Colors.black;
    final subFg = selected ? Colors.white70 : const Color(0xFF8A8A8A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: selected ? null : Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: fg,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: subFg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShiftTimes extends StatelessWidget {
  const _ShiftTimes({
    required this.title,
    required this.times,
    required this.selectedTime,
    required this.onSelected,
  });

  final String title;
  final List<String> times;
  final String? selectedTime;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: times.map((t) {
            final selected = t == selectedTime;
            return InkWell(
              onTap: () => onSelected(t),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? brand : const Color(0xFFF3F6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  t,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : const Color(0xFF2145BF),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Doctor {
  final String name;
  final String title;
  final String experience;
  final String schedule;
  final Color accent;

  const Doctor({
    required this.name,
    required this.title,
    required this.experience,
    required this.schedule,
    required this.accent,
  });
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({
    required this.doctor,
    required this.brand,
    required this.onBook,
  });

  final Doctor doctor;
  final Color brand;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // TODO: Replace with doctor photo image asset
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: doctor.accent.withOpacity(0.15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/doctor_photo.png', // TODO(IMAGE): change to doctor photo asset path.
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person,
                      size: 36,
                      color: doctor.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.55),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      doctor.experience,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giờ làm việc',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.45),
                ),
              ),
              Text(
                doctor.schedule,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withOpacity(0.75),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onBook,
              style: ElevatedButton.styleFrom(
                backgroundColor: brand,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              child: const Text(
                'Đặt lịch ngay',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


