import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

// import 'package:provider/provider.dart';

// import '../../../app/route/routes/route_path.dart';
// import '../../../utils/constants/appreance_definition.dart';
// import '../../../utils/theme/Theme.dart';
import '../bloc/singup_bloc.dart';
import 'signup_options_view.dart';
import 'signup_with_email_view.dart';

// ignore: must_be_immutable
class SignupView extends StatelessWidget {
  SignupView({Key? key}) : super(key: key);
  final Logger logger = Logger();
  bool passToggle = true;

  @override
  Widget build(BuildContext buildContext) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final themeMode = Provider.of<ThemeProviderNotifier>(buildContext).themeMode;
    // final isDarkMode = themeMode == ThemeModeType.dark;

    return BlocConsumer<SignupBloc, SignupState>(
        listener: (content, state) {},
        buildWhen: (previous, current) =>
            previous != current &&
            (current is SignupOptionsState || current is SignupWithEmailState),
        builder: (content, state) {
          if (state is SignupOptionsState) {
            return SignupOptionsView();
          } else if (state is SignupWithEmailState) {
            return SingupWithEmail();
          } else {
            return Scaffold();
          }
        });
  }
}
