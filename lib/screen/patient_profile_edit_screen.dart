import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class PatientProfileEditScreen extends StatefulWidget {
  const PatientProfileEditScreen({super.key});

  @override
  State<PatientProfileEditScreen> createState() =>
      _PatientProfileEditScreenState();
}

class _PatientProfileEditScreenState extends State<PatientProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _insuranceNumberController = TextEditingController();
  final _addressController = TextEditingController();

  final Future<User?> _userFuture = AuthService().getCurrentUser();

  DateTime? _selectedDate;
  String? _selectedGender;
  bool _isInitialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _dateController.dispose();
    _phoneNumberController.dispose();
    _insuranceNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  DateTime? _parseDate(String value) {
    if (value.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;

    final parts = value.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }

  Future<void> _pickDate() async {
    final initialDate = _selectedDate ?? DateTime(2004, 10, 21);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final updatedUser = await AuthService().updateCurrentUser({
      'full_name': _fullNameController.text.trim(),
      'date_of_birth': _selectedDate?.toIso8601String().split('T').first,
      'gender': _selectedGender ?? '',
      'phone_number': _phoneNumberController.text.trim(),
      'insurance_number': _insuranceNumberController.text.trim(),
      'address': _addressController.text.trim(),
    });

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (updatedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể lưu thông tin, vui lòng thử lại.'),
        ),
      );
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF2145BF);

    return FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting &&
            !_isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (user != null && !_isInitialized) {
          _fullNameController.text = user.fullName;
          _dateController.text = _formatDate(_parseDate(user.dateOfBirth));
          _phoneNumberController.text = user.phoneNumber;
          _insuranceNumberController.text = user.insuranceNumber;
          _addressController.text = user.address;
          _selectedDate = _parseDate(user.dateOfBirth);
          _selectedGender = user.gender.isEmpty ? null : user.gender;
          _isInitialized = true;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF2F2F2),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: const Color(0xFFEDEDED),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    height: 70,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: _isSaving
                                ? null
                                : () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 26,
                              color: Color(0xFF191C22),
                            ),
                          ),
                        ),
                        const Text(
                          'Chỉnh sửa hồ sơ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B1D22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProfileField(
                            label: 'Họ và tên',
                            controller: _fullNameController,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                ? 'Vui lòng nhập họ và tên'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: _pickDate,
                            decoration: _inputDecoration('Ngày sinh').copyWith(
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedGender,
                            decoration: _inputDecoration('Giới tính'),
                            items: const [
                              DropdownMenuItem(
                                value: 'male',
                                child: Text('Nam'),
                              ),
                              DropdownMenuItem(
                                value: 'female',
                                child: Text('Nữ'),
                              ),
                              DropdownMenuItem(
                                value: 'other',
                                child: Text('Khác'),
                              ),
                            ],
                            onChanged: _isSaving
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  },
                          ),
                          const SizedBox(height: 16),
                          _ProfileField(
                            label: 'Số điện thoại',
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          _ProfileField(
                            label: 'Số BHYT',
                            controller: _insuranceNumberController,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          _ProfileField(
                            label: 'Địa chỉ',
                            controller: _addressController,
                            textInputAction: TextInputAction.done,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: brand,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Lưu thay đổi',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      maxLines: maxLines,
      decoration: _inputDecoration(label),
    );
  }
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );
}
