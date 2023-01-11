import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_states.dart';

class SettingsController extends Cubit<SettingsState> {
  final select = ValueNotifier(false);

  SettingsController() : super(LoadingSettingsState()) {
    init();
  }

  Future<void> init() async {
    emit(LoadingSettingsState());
    try {
      SharedPreferences spref = await SharedPreferences.getInstance();
      select.value = spref.getBool('biometria') ?? false;
      final bioAvailable = await isBiometricAvailable();
      emit(SuccessSettingsState(bioAvailable));
    } catch (e) {
      emit(ErrorSettingsState('Erro ao acessar as configurações'));
    }
  }

  void setConfBiometria(bool statusBio) async {
    final SharedPreferences spref = await SharedPreferences.getInstance();
    spref.setBool('biometria', statusBio);
  }

  //Verificar se tem biometria cadastrada e se o dispositivo suporta biometria
//Se for verdadeiro retorna true, se não retorna false
  Future<bool> isBiometricAvailable() async {
    final LocalAuthentication authBio = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await authBio.canCheckBiometrics;
    return canAuthenticateWithBiometrics && await authBio.isDeviceSupported();
  }

  /* bool getConfBiometria() {
    bool select = false;
    try {
      Future<SharedPreferences> spref = SharedPreferences.getInstance();
      select = spref.getBool('biometria') ?? false;
    } catch (e) {}

    return select;
  } */
}
