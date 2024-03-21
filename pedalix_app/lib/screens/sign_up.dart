import 'package:pedalix_app/widgets/custom_phone_number.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:pedalix_app/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:pedalix_app/core/app_export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Country selectedCountry = CountryPickerUtils.getCountryByPhoneCode('94');

  TextEditingController phoneNumberController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google SignIn"),
      ),
      body: _user != null ? _userInfo() : _signInScreen(),
    );
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_user!.photoURL!),
              ),
            ),
          ),
          Text(_user!.email!),
          Text(_user!.displayName ?? ""),
          MaterialButton(
            color: Colors.red,
            child: const Text("Sign Out"),
            onPressed: _auth.signOut,
          )
        ],
      ),
    );
  }

  Widget _signInScreen() {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 1.v),
              Text(
                "Enter your number",
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 19.v),
              CustomPhoneNumber(
                country: selectedCountry,
                controller: phoneNumberController,
                onTap: (Country value) {
                  selectedCountry = value;
                },
              ),
              SizedBox(height: 34.v),
              _buildOR(context),
              SizedBox(height: 36.v),
              CustomOutlinedButton(
                text: "Sign in with Google",
                onPressed: _handleGoogleSignIn,
                leftIcon: Container(
                  margin: EdgeInsets.only(right: 30.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgGooglecoloricon1,
                    height: 30.v,
                    width: 32.h,
                  ),
                ),
              ),
              SizedBox(height: 14.v),
              CustomOutlinedButton(
                text: "Sign in with Facebook",
                leftIcon: Container(
                  margin: EdgeInsets.only(right: 30.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgFacebookroundcoloricon1,
                    height: 30.v,
                    width: 32.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildOR(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 10.v,
            bottom: 9.v,
          ),
          child: SizedBox(
            width: 170.h,
            child: Divider(),
          ),
        ),
        Text(
          "OR",
          style: theme.textTheme.titleSmall,
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 10.v,
            bottom: 9.v,
          ),
          child: SizedBox(
            width: 171.h,
            child: Divider(),
          ),
        ),
      ],
    );
  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}