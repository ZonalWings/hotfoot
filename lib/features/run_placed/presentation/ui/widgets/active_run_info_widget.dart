import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_update/run_update_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_update/run_update_event.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_update/run_update_state.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/cancel_delivery_button.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/open_close_chat_button.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_run_stream.dart';
import 'package:hotfoot/injection_container.dart';

class ActiveRunInfoWidget extends StatefulWidget {
  final RunModel runModel;

  const ActiveRunInfoWidget({@required this.runModel});

  @override
  _ActiveRunInfoWidgetState createState() => _ActiveRunInfoWidgetState();
}

class _ActiveRunInfoWidgetState extends State<ActiveRunInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunUpdateBloc, RunUpdateState>(
      builder: (BuildContext context, RunUpdateState state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  state is RunUpdateUninitialized
                      ? "${this.widget.runModel.status}"
                      : state.runModel.status,
                  style: TextStyle(fontSize: 24.0)),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CancelDeliveryButton(
                    currRun: state is RunUpdateUninitialized
                        ? this.widget.runModel
                        : state.runModel,
                    updateOrInsertRun: sl()),
                OpenCloseChatButton(
                    runModel: state is RunUpdateUninitialized
                        ? this.widget.runModel
                        : state.runModel,
                    buttonText: 'Contact Runner'),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _listenForRunUpdates();
  }

  void _listenForRunUpdates() async {
    final runId =
        BlocProvider.of<NavigationScreenBloc>(context).state.runModel.id;
    final runStream = await _getRunStream(
      getRunStream: sl<GetRunStream>(),
      runId: runId,
    );
    runStream.listen(_handleRunUpdate);
  }

  Future<Stream<QuerySnapshot>> _getRunStream({
    @required GetRunStream getRunStream,
    @required String runId,
  }) async {
    final runStreamEither = await getRunStream(runId);
    return runStreamEither.fold(
      (_) => null,
      (runStream) => runStream,
    );
  }

  void _handleRunUpdate(QuerySnapshot querySnapshot) {
    print('RUN DOCUMENT CHANGED');
    RunModel runModel;
    querySnapshot.documents.forEach((DocumentSnapshot documentSnapshot) {
      documentSnapshot.data.forEach((k, v) {
        print("$k: $v");
      });
      runModel = RunModel.fromJson(documentSnapshot.data);
    });
    BlocProvider.of<RunUpdateBloc>(context).add(RunUpdated(runModel: runModel));
  }
}