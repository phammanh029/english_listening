import 'package:english_listening/app.dart';
import 'package:english_listening/model/Lession.model.dart';
import 'package:english_listening/ui/lessionGalary.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

enum AddMediaAction { Local, Network }

class LessionGalaryWidget extends StatefulWidget {
  @override
  _LessionGalaryWidgetState createState() => _LessionGalaryWidgetState();
}

class _LessionGalaryWidgetState extends State<LessionGalaryWidget> {
  LessionGalaryBloc _bloc;

  @override
  void initState() {
    _bloc = LessionGalaryBloc();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Widget _buildLessionItem(BuildContext context, Lession item) {
    return Container(
      child: Text(item.path),
    );
  }

  Future _addMedia(BuildContext context) async {
    final result = await showModalBottomSheet<AddMediaAction>(
        context: context,
        builder: (context) {
          return ListView(
            children: <Widget>[
              ListTile(
                title: Text('Add viedeo'),
                onTap: () {
                  Navigator.pop(context, AddMediaAction.Local);
                },
              )
            ],
          );
        });

    if (result != null) {
      switch (result) {
        case AddMediaAction.Local:
          final file = await ImagePicker.pickVideo(source: ImageSource.gallery);
          _bloc.add(LessionGalaryEventAddMediaQueues(items: [file.path]));
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('English listening'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () async {
              // show add file
              await _addMedia(context);
            },
          )
        ],
      ),
      body: BlocBuilder<LessionGalaryBloc, LessionGalaryState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is LessionGalaryStateLoading) {
            return CircularProgressIndicator();
          }
          if (state is LessionGalaryStateInitial) {
            return CircularProgressIndicator();
          }

          if (state is LessionGalaryStateError) {
            return Center(
              child: Text(state.error),
            );
          }

          if (state is LessionGalaryStateMediasSet) {
            // display list of media
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: state.lessions.length,
                itemBuilder: (context, index) {
                  return _buildLessionItem(context, state.lessions[index]);
                });
          }

          return Text('Not Implemented');
        },
      ),
    );
  }
}
