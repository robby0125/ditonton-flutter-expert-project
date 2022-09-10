import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/zoom_drawer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'zoom_drawer_bloc_test.mocks.dart';

@GenerateMocks([
  ZoomDrawerController,
  Widget,
])
void main() {
  late MockZoomDrawerController mockZoomDrawerController;
  late MockWidget mockHomeMoviePage;
  late MockWidget mockHomeTvPage;
  late ZoomDrawerBloc zoomDrawerBloc;

  setUp(() {
    mockZoomDrawerController = MockZoomDrawerController();
    mockHomeMoviePage = MockWidget();
    mockHomeTvPage = MockWidget();
    zoomDrawerBloc = ZoomDrawerBloc(
      controller: mockZoomDrawerController,
      homeMoviePage: mockHomeMoviePage,
      homeTvPage: mockHomeTvPage,
    );
  });

  test('initial main screen should be home movie page', () {
    expect(zoomDrawerBloc.state, ZoomDrawerState(mockHomeMoviePage));
  });

  blocTest<ZoomDrawerBloc, ZoomDrawerState>(
    'should emit [ZoomDrawerState] with main screen home movie page when select movie page',
    build: () {
      when(mockZoomDrawerController.toggle?.call()).thenReturn(null);
      return zoomDrawerBloc;
    },
    act: (bloc) => bloc.add(ToHomeMoviePage()),
    expect: () => [
      ZoomDrawerState(mockHomeMoviePage),
    ],
    verify: (bloc) {
      verify(mockZoomDrawerController.toggle?.call());
    },
  );

  blocTest<ZoomDrawerBloc, ZoomDrawerState>(
    'should emit [ZoomDrawerState] with main screen home tv page when select tv page',
    build: () {
      when(mockZoomDrawerController.toggle?.call()).thenReturn(null);
      return zoomDrawerBloc;
    },
    act: (bloc) => bloc.add(ToHomeTvPage()),
    expect: () => [
      ZoomDrawerState(mockHomeTvPage),
    ],
    verify: (bloc) {
      verify(mockZoomDrawerController.toggle?.call());
    },
  );
}
