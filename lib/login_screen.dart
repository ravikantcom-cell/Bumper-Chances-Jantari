import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  final Widget Function() onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  late final Future<void> _googleSignInReady;

  @override
  void initState() {
    super.initState();
    _googleSignInReady = GoogleSignIn.instance.initialize();
  }

  Future<void> _loginWithGoogle() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await _googleSignInReady;

      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final idToken = googleAuth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw FirebaseAuthException(
          code: 'missing-google-id-token',
          message: 'Google ID token नहीं मिला।',
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.onLoginSuccess()),
      );
    } on GoogleSignInException catch (e) {
      if (!mounted) return;

      String message = 'Google login नहीं हो पाया।';

      if (e.code == GoogleSignInExceptionCode.canceled) {
        message = 'Google login cancel कर दिया गया।';
      } else if (e.code ==
          GoogleSignInExceptionCode.clientConfigurationError) {
        message = 'Google Sign-In configuration में समस्या है।';
      } else if (e.description != null && e.description!.isNotEmpty) {
        message = e.description!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      final message = switch (e.code) {
        'account-exists-with-different-credential' =>
          'इस email का Firebase account किसी दूसरे login provider से जुड़ा है।',
        'operation-not-allowed' =>
          'Firebase में Google Sign-In अभी enabled नहीं है।',
        'invalid-credential' => 'Google credential valid नहीं है।',
        'network-request-failed' => 'Internet connection check करें।',
        _ => e.message ?? 'Firebase Google login नहीं हो पाया।',
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login नहीं हो पाया: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050A13),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Existing Mahakal asset — no new asset required.
          Image.asset(
            'assets/images/mahakal_welcome.png',
            fit: BoxFit.cover,
          ),

          // Dark cinematic overlay for readability.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.black.withValues(alpha: 0.20),
                  Colors.black.withValues(alpha: 0.82),
                  Colors.black.withValues(alpha: 0.94),
                ],
                stops: const [0.0, 0.35, 0.68, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 28, 18, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 52,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // The Mahakal background already contains the
                        // app title/Om/tagline, so do not draw them again here.
                        // This spacer keeps the login card in the same position.
                        const SizedBox(height: 184),

                        const SizedBox(height: 34),

                        // Professional glass login card.
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 430),
                          padding: const EdgeInsets.fromLTRB(20, 25, 20, 21),
                          decoration: BoxDecoration(
                            color: const Color(0xFF08111F).withValues(alpha: 0.84),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.20),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.40),
                                blurRadius: 30,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Welcome',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                'Sign in with your Google account\nto continue',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFB9C9E1)
                                      .withValues(alpha: 0.95),
                                  fontSize: 14.5,
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 25),

                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed:
                                      _isLoading ? null : _loginWithGoogle,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.white
                                        .withValues(alpha: 0.86),
                                    foregroundColor: const Color(0xFF202124),
                                    elevation: 5,
                                    shadowColor: const Color(0xFF4EA1FF)
                                        .withValues(alpha: 0.40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 23,
                                          height: 23,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 27,
                                              height: 27,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'G',
                                                style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color(0xFF4285F4),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Text(
                                              'Continue with Google',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 22,
                                            ),
                                          ],
                                        ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    size: 17,
                                    color: const Color(0xFF9FB7D7)
                                        .withValues(alpha: 0.95),
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    'Secure & Safe Login',
                                    style: TextStyle(
                                      color: const Color(0xFF9FB7D7)
                                          .withValues(alpha: 0.95),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          'जय महाकाल',
                          style: TextStyle(
                            color: const Color(0xFFFFD36A)
                                .withValues(alpha: 0.92),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
