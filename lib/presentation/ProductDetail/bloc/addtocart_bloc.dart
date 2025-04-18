import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'addtocart_event.dart';
part 'addtocart_state.dart';

class AddtocartBloc extends Bloc<AddtocartEvent, AddtocartState> {
  AddtocartBloc() : super(AddtocartInitial()) {
    on<AddTocartButtonClick>(addTocartButtonClick);
  }

  FutureOr<void> addTocartButtonClick(
      AddTocartButtonClick event, Emitter<AddtocartState> emit) async {
    try {
      CollectionReference collref =
          FirebaseFirestore.instance.collection('AddToCart');

      // Check if email already exists
      QuerySnapshot querySnapshotid =
          await collref.where('id', isEqualTo: event.id).get();
      QuerySnapshot querySnapshotname =
          await collref.where('name', isEqualTo: event.name).get();
      if (querySnapshotid.docs.isNotEmpty &&
          querySnapshotname.docs.isNotEmpty) {
        emit(AlreadyProductExistTocartState());
      } else {
        await collref.add({
          'id': event.id,
          'img': event.img,
          'name': event.name,
          'price': event.price,
          'size': event.size,
          'color': event.color,
          'quantity': event.quantity,
        });
        emit(AddToCartSucessState());
      }
    } catch (e) {
      emit(CatchErrorAddToCartState());
    }
  }
}
