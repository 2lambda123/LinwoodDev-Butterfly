part of 'handler.dart';

class LayerHandler extends Handler {
  final LayerPainter painter;

  LayerHandler(this.painter, DocumentBloc bloc) : super(bloc);

  @override
  void onTapDown(TapDownDetails details) {}
}
