import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../page_view/shared/repositories/category_repository.dart';
import 'register_states.dart';

class RegisterController extends Cubit<RegisterState> {
  RegisterController(this.categoryRepo) : super(LoadingRegisterState());

  final CategoryRepository categoryRepo;

  // final _users = <User>[];
  // List<User> get users => _users;

  Future<void> registerUser(
      {required String name,
      required String email,
      required String password}) async {
    emit(LoadingRegisterState());

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await auth.signInWithEmailAndPassword(email: email, password: password);
      await auth.currentUser!.updateDisplayName(name);
      await categoryRepo.setInitialCategories(auth.currentUser!.uid);

      emit(SuccessRegisterState());
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == "email-already-in-use") {
          emit(ErrorRegisterState(
              'Email já cadastrado, se esqueceu a senha, recupera sua senha'));
        }
        if (e.code == "invalid-email") {
          emit(ErrorRegisterState('Esse email não é válido'));
        }
        log(e.message ?? 'FirebaseAuthException');
        //emit(ErrorRegisterState(e.message ?? 'Error on registerController'));
      } else {
        emit(ErrorRegisterState('Erro de conexão, tente novamente!'));
      }
    }
  }
}
