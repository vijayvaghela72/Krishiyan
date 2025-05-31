import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/helper/alert_helper.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/frm/widget/farmer_profile.dart';

secondTabData(BuildContext context, Function update) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          buildTranslate("farmerRegistration")!,
          softWrap: true,
          style: const TextStyle(
              color: Color(0xFF3FC041),
              fontSize: 20,
              fontFamily: 'poppins-medium'),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      // name
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Text(
          buildTranslate("name")!,
          style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF666666),
              fontFamily: 'poppins-semibold'),
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: TextFormField(
          decoration: InputDecoration(
            alignLabelWithHint: true,
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            hintText: buildTranslate("enterName")!,
            hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.green, width: 0.5),
            ),
          ),
          validator: (value) =>
              value!.isEmpty ? 'Please, fill this field.' : null,
          controller: frmProvider!.nameController,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      // whats app number
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Text(
          buildTranslate("whatsappNumber")!,
          style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF666666),
              fontFamily: 'poppins-semibold'),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: TextFormField(
          maxLength: 10,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            //To remove first '0'
            FilteringTextInputFormatter.deny(RegExp(r'^0+')),
            //To remove first '94' or your country code
            FilteringTextInputFormatter.deny(RegExp(r'^94+')),
          ],
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            enabled: true,
            alignLabelWithHint: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: buildTranslate("mobileNumber"),
            hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.green, width: 0.5),
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 35),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: frmProvider!.isOtpButtonEnabled
                      ? const Color(0xFF3FC041)
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(buildTranslate("getOtp")!),
                onPressed: () {
                  frmProvider!.otpVisible = true;
                  update();
                  if (frmProvider!.whatsAppNumberController.text.isNotEmpty) {
                    if (frmProvider!.isOtpButtonEnabled) {
                      frmProvider!.getOtpApiCall(context);
                    } else {
                      AlertHelper.showToast(
                          "Please wait before requesting again.", context);
                    }
                  } else {
                    AlertHelper.showToast("Please enter details.", context);
                  }
                },
              ),
            ),
          ),
          validator: (value) =>
              value!.isEmpty ? 'Please, fill this field.' : null,
          controller: frmProvider!.whatsAppNumberController,
        ),
      ),
      // Display the countdown timer if the button is disabled
      Visibility(
        visible: !frmProvider!.isOtpButtonEnabled,
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Text(
            frmProvider!.countdownText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      // verify otp
      frmProvider!.otpVisible
          ? Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("verifyOtp")!,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontFamily: 'poppins-semibold'),
              ),
            )
          : Container(),
      frmProvider!.otpVisible
          ? const SizedBox(
              height: 20,
            )
          : Container(),
      frmProvider!.otpVisible
          ? Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: OTPTextField(
                  controller: frmProvider!.otpController,
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldWidth: 55,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 10,
                  style: TextStyle(fontSize: 17),
                  onChanged: (code) {
                    print("Changed: " + code);
                  },
                  onCompleted: (code) {
                    frmProvider!.enteredOtp = code;
                    print("Completed: " + frmProvider!.enteredOtp);
                  }),
            )
          : Container(),
      const SizedBox(
        height: 25,
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: ElevatedButton(
          onPressed: () async {
            bool isOtpVerified = await frmProvider!.verifyOtp(
                frmProvider!.whatsAppNumberController.text,
                frmProvider!.enteredOtp,
                context);
            if (isOtpVerified) {
              AlertHelper.showToast("OTP verified", context);
              if (frmProvider!.nameController.text.trim().isNotEmpty &&
                  frmProvider!.whatsAppNumberController.text
                      .trim()
                      .isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FarmerProfilePage(
                      farmerName: frmProvider!.nameController.text.toString(),
                      farmerWhatsappNumber:
                          frmProvider!.whatsAppNumberController.text.toString(),
                    ),
                  ),
                );
              } else {
                AlertHelper.showToast("Please enter details.", context);
              }
            } else {
              AlertHelper.showToast(
                  "OTP verification failed. Please try again.", context);
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
            textStyle: const TextStyle(fontSize: 18),
            backgroundColor: const Color(0xFF3FC041),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            buildTranslate('SUBMIT')!,
            style: const TextStyle(fontSize: 18, fontFamily: 'poppins-medium'),
          ),
        ),
      ),
    ],
  );
}
