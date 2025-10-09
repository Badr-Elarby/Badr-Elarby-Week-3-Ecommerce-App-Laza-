import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ConfirmCode extends StatefulWidget {
  final String email;
  const ConfirmCode({super.key, required this.email});

  @override
  State<ConfirmCode> createState() => _ConfirmCodeState();
}

class _ConfirmCodeState extends State<ConfirmCode> {
  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;
  Timer? _timer;
  int _countdown = 20;
  bool _canResend = false;
  @override
  void initState() {
    super.initState();
    controllers = List.generate(6, (_) => TextEditingController());
    focusNodes = List.generate(6, (_) => FocusNode());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get otp => controllers.map((c) => c.text).join();

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < controllers.length - 1) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void _resendCode() {
    if (_canResend) {
      setState(() {
        _countdown = 20;
        _canResend = false;
      });
      _startTimer();
      // TODO: Implement actual resend logic
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verification code sent!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                          size: 20.sp,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // Title
                Text(
                  'Verification Code',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 60.h),

                // Cloud with lock illustration
                _buildCloudWithLock(),

                SizedBox(height: 60.h),

                // Code input fields
                _buildCodeInputFields(),

                SizedBox(height: 40.h),

                // Resend timer/text
                _buildResendSection(),

                const Spacer(),

                // Confirm button
                _buildConfirmButton(),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloudWithLock() {
    return Container(
      width: 150.w,
      height: 120.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cloud shapes
          Positioned(
            left: 20.w,
            child: Container(
              width: 80.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.3),
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
          ),
          Positioned(
            right: 20.w,
            child: Container(
              width: 90.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.4),
                borderRadius: BorderRadius.circular(45.r),
              ),
            ),
          ),
          // Lock icon
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700), // Gold color
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock, color: Colors.white, size: 24.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          width: 45.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
          ),
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) => _onOtpChanged(value, index),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildResendSection() {
    return GestureDetector(
      onTap: _canResend ? _resendCode : null,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '00:${_countdown.toString().padLeft(2, '0')} ',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: 'resend confirmation code',
              style: TextStyle(
                fontSize: 14.sp,
                color: _canResend ? const Color(0xFF8B5CF6) : Colors.grey,
                fontWeight: FontWeight.w500,
                decoration: _canResend
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: () {
          if (controllers.every((c) => c.text.isNotEmpty)) {
            FocusScope.of(context).unfocus();
            // Static UI only - no confirm logic
          } else {
            print('ConfirmCode: Not all fields are filled');
          }
        },
        child: Text(
          'Confirm Code',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
