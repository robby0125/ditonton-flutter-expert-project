import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';

part 'zoom_drawer_event.dart';

part 'zoom_drawer_state.dart';

class ZoomDrawerBloc extends Bloc<ZoomDrawerEvent, ZoomDrawerState> {
  final ZoomDrawerController controller;
  final Widget homeMoviePage;
  final Widget homeTvPage;

  ZoomDrawerBloc({
    required this.controller,
    required this.homeMoviePage,
    required this.homeTvPage,
  }) : super(ZoomDrawerState(homeMoviePage)) {
    on<ToHomeMoviePage>((event, emit) {
      controller.toggle?.call();
      emit(ZoomDrawerState(homeMoviePage));
    });
    on<ToHomeTvPage>((event, emit) {
      controller.toggle?.call();
      emit(ZoomDrawerState(homeTvPage));
    });
  }
}
