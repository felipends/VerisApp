import 'package:flutter/widgets.dart';

import '../domain/app_language_option.dart';
import '../domain/app_theme_option.dart';

class Mvp3Strings {
  const Mvp3Strings(this.locale);

  factory Mvp3Strings.of(BuildContext context) =>
      Mvp3Strings(Localizations.localeOf(context));

  final Locale locale;

  bool get _en => locale.languageCode == 'en';

  String get onboardingTitle =>
      _en ? 'Personalize Veris' : 'Personalize o Veris';
  String get onboardingBody => _en
      ? 'You can add a few baby details to make the app feel more personal. Everything here is optional and stays only on this device.'
      : 'Você pode informar alguns dados do bebê para deixar o app mais pessoal. Tudo aqui é opcional e fica salvo apenas neste dispositivo.';
  String get start => _en ? 'Start' : 'Começar';
  String get skip => _en ? 'Skip for now' : 'Pular por enquanto';
  String get saveChanges => _en ? 'Save changes' : 'Salvar alterações';
  String get babySection => _en ? 'Baby' : 'Bebê';
  String get appearanceSection => _en ? 'Appearance' : 'Aparência';
  String get languageSection => _en ? 'Language' : 'Idioma';
  String get privacySection => _en ? 'Privacy' : 'Privacidade';
  String get nameLabel => _en ? 'Baby name' : 'Nome do bebê';
  String get nameHint => _en ? 'Optional' : 'Opcional';
  String get sexLabel => _en ? 'Sex' : 'Sexo';
  String get female => _en ? 'Female' : 'Feminino';
  String get male => _en ? 'Male' : 'Masculino';
  String get preferNotToSay =>
      _en ? 'Prefer not to say' : 'Prefiro não informar';
  String get ageLabel => _en ? 'Age' : 'Idade';
  String get birthDateMode => _en ? 'Birth date' : 'Data de nascimento';
  String get ageMonthsMode => _en ? 'Age in months' : 'Idade em meses';
  String get birthDateLabel => _en ? 'Birth date' : 'Data de nascimento';
  String get ageMonthsLabel => _en ? 'Age in months' : 'Idade em meses';
  String get clear => _en ? 'Clear' : 'Limpar';
  String get selectAgeHint => _en
      ? 'Choose birth date or age in months'
      : 'Escolha data de nascimento ou idade em meses';
  String get themeLabel => _en ? 'Theme' : 'Tema';
  String get system => _en ? 'System' : 'Sistema';
  String get portuguese => _en ? 'Portuguese' : 'Português';
  String get english => _en ? 'English' : 'Inglês';
  String get home => _en ? 'Home' : 'Início';
  String get settings => _en ? 'Settings' : 'Configurações';
  String get appSubtitle => _en ? 'Baby tracking' : 'Acompanhamento do bebê';
  String get privacyBody => _en
      ? 'Baby data is optional and stays on this device. You can use Veris without filling in this information.'
      : 'Os dados do bebê são opcionais e ficam salvos neste dispositivo. Você pode usar o Veris sem preencher essas informações.';
  String get babyBlue => _en ? 'Baby blue' : 'Azul bebê claro';
  String get lightYellow => _en ? 'Light yellow' : 'Amarelo claro';
  String get lightGreen => _en ? 'Light green' : 'Verde claro';
  String get lightPink => _en ? 'Light pink' : 'Rosa claro';
  String get defaultTheme => _en ? 'Default' : 'Padrão';

  String appLanguageLabel(AppLanguageOption option) => switch (option) {
    AppLanguageOption.system => system,
    AppLanguageOption.pt => portuguese,
    AppLanguageOption.en => english,
  };

  String themeName(AppThemeOption option) => switch (option) {
    AppThemeOption.defaultTheme => defaultTheme,
    AppThemeOption.babyBlue => babyBlue,
    AppThemeOption.lightYellow => lightYellow,
    AppThemeOption.lightGreen => lightGreen,
    AppThemeOption.lightPink => lightPink,
  };
}
