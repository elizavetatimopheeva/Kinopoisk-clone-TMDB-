import 'package:flutter/material.dart';
import 'package:kino/Theme/app_button_style.dart';
import 'package:kino/widgets/auth/auth_model.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вход', style: TextStyle(fontWeight: FontWeight.w500)),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(children: [_HeaderWidget()]),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16, color: Colors.black);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          const Text(
            'Войти в свою учетную запись',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 25),
          const _FormWidget(),
          const SizedBox(height: 25),
          const Text(
            'Чтобы пользоваться правкой и возможностями рейтинга TMDB, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой. Нажмите здесь, чтобы начать',
            style: textStyle,
          ),
          const SizedBox(height: 5),

          TextButton(
            style: AppButtonStyle.linkButton,
            onPressed: () {},
            child: Text('Зарегистрироваться'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Если Вы зарегистрировались, но не получили письмо для подтверждения, нажмите здесь, чтобы отправить письмо повторно.',
            style: textStyle,
          ),
          TextButton(
            style: AppButtonStyle.linkButton,
            onPressed: () {},
            child: Text('Письмо для подтверждения'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthViewModel>();
    final textStyle = const TextStyle(fontSize: 16, color: Color(0xFF212529));

    final textFieldDecorator = const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsetsGeometry.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      isCollapsed: true,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),

        Text('Имя пользователя', style: textStyle),
        SizedBox(height: 5),
        TextField(
          controller: model.loginTextController,
          decoration: textFieldDecorator,
        ),
        SizedBox(height: 16),
        Text('Пароль', style: textStyle),
        SizedBox(height: 5),
        TextField(
          controller: model?.passwordTextController,
          obscureText: true,
          decoration: textFieldDecorator,
        ),
        SizedBox(height: 30),
        Row(
          children: [
            const _AuthButtonWidget(),

            SizedBox(width: 10),

            TextButton(
              style: AppButtonStyle.linkButton,
              onPressed: () {},
              child: Text('Сбросить пароль'),
            ),
          ],
        ),
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthViewModel>();
    final color = const Color(0xFF01B4E4);
    final onPressed = model.canStartAuth ? () => model.auth(context) : null;
    final child = model.isAuthProgress
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text('Войти');
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((AuthViewModel m) => m.errorMessage);

    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: const TextStyle(fontSize: 17, color: Colors.red),
      ),
    );
  }
}
