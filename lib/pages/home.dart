import 'package:butterfly/models/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mdi/mdi.dart';

class HomePage extends StatelessWidget {
  final List<AppDocument> _documents = [
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 1", description: "abc..."),
    AppDocument(name: "Document 2", description: "def...")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Butterfly")),
        body: SizedBox.expand(
            child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 100, maxWidth: 1000),
                    child: Container(
                        child: Wrap(
                            alignment: WrapAlignment.center,
                            children: List.generate(_documents.length, (index) {
                              var document = _documents[index];
                              return Card(
                                  margin: EdgeInsets.all(5),
                                  child: InkWell(
                                      onTap: () => Modular.to.pushNamed('/pad'),
                                      child: Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: Column(children: [
                                            Text(document.name,
                                                style: Theme.of(context).textTheme.headline6),
                                            Text(document.description,
                                                style: Theme.of(context).textTheme.overline)
                                          ]))));
                            })))))),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Mdi.plus),
          label: Text("New"),
          onPressed: () {},
        ));
  }
}
