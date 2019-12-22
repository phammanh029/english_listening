import 'package:english_listening/app.dart';
import 'package:english_listening/model/Lession.model.dart';
import 'package:english_listening/ui/lessionGalary.bloc.dart';
import 'package:english_listening/ui/player.widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
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
    _bloc.add(LessionGalaryEventInit());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Widget _buildLessionItem(BuildContext context, Lession item) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LessionPlayer(
                      lessionPath: item.path,
                      parent: _bloc,
                    )));
      },
      child: Text(item.path),
    );
  }

  Future _addMedia(BuildContext context) async {
    final result = await showModalBottomSheet<AddMediaAction>(
        context: context,
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                title: Text('Add video'),
                onTap: () {
                  Navigator.pop(context, AddMediaAction.Local);
                },
              ),
              ListTile(
                title: Text('Add url'),
                onTap: () {
                  Navigator.pop(context, AddMediaAction.Network);
                },
              )
            ],
          );
        });

    if (result != null) {
      switch (result) {
        case AddMediaAction.Local:
          // final file = await ImagePicker.pickVideo(source: ImageSource.gallery);
          final files = await FilePicker.getMultiFile(type: FileType.ANY);

          if (files != null && files.length > 0) {
            // only get mp3 or mo4 files
            const supportFormats = ['mp3', 'mp4'];
            _bloc.add(LessionGalaryEventAddMediaQueues(
                items: files
                    .where((file) => supportFormats.contains(file.path
                        .toLowerCase()
                        .substring(file.path.lastIndexOf('.') + 1)))
                    .map((file) => file.path)
                    .toList()));
          }
          break;
        case AddMediaAction.Network:
          // do download file
          break;
        default:
          break;
      }
    }
  }

  Future _addNetworkMedia(String url) async {
    try {} catch (error) {
      print(error);
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
            return Center(child: CircularProgressIndicator());
          }
          if (state is LessionGalaryStateInitial) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is LessionGalaryStateError) {
            return Center(
              child: Text(state.error),
            );
          }

          if (state is LessionGalaryStateMediasSet) {
            if (state.lessions.isEmpty) {
              return Center(
                child: Text('No media'),
              );
            }
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
