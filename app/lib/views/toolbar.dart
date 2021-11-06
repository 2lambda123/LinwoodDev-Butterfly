import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/tool/edit.dart';
import 'package:butterfly/tool/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SelectMode { add, replace, remove }

class MainViewToolbar extends StatefulWidget {
  final DocumentBloc bloc;
  const MainViewToolbar({Key? key, required this.bloc}) : super(key: key);

  @override
  _MainViewToolbarState createState() => _MainViewToolbarState();
}

class _MainViewToolbarState extends State<MainViewToolbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
      var current = state as DocumentLoadSuccess;

      Widget toolbar = current.editMode
          ? EditToolbar(bloc: widget.bloc)
          : ViewToolbar(bloc: widget.bloc);
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(height: 50, child: toolbar)),
          ),
        ],
      );
    });
  }
}
