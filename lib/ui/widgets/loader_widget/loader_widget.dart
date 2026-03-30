import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kino/resources/app_images.dart';
import 'package:kino/resources/app_vectors.dart';
import 'package:kino/ui/navigation/main_navigation.dart';
import 'package:kino/ui/theme/app_colors.dart';
import 'package:kino/ui/widgets/loader_widget/loader_view_cubit.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderViewCubit, LoaderViewCubitState>(
      listenWhen: (prev, current) => current != LoaderViewCubitState.unknown,
      listener: onLoaderViewCubitStateChange,
      child: Scaffold(
        // backgroundColor: AppColors.mainBackgroundColor,
        body: Center(
          child: Image(image: AssetImage(AppImages.splash)),
        ),
      ),
    );
  }

  void onLoaderViewCubitStateChange(
    BuildContext context,
    LoaderViewCubitState state,
  ) async {
    final nextScreen = state == LoaderViewCubitState.authorized
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}