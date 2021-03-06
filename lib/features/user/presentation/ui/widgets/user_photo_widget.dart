import 'dart:io';
import 'dart:typed_data';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_state.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:image_picker/image_picker.dart';

class UserPhotoWidget extends StatelessWidget {
  final String userId;
  final double radius;
  final double borderWidth;
  final bool editable;

  UserPhotoWidget({
    @required this.userId,
    @required this.radius,
    @required this.borderWidth,
    @required this.editable,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserPhotoBloc>()..add(UserPhotoRequested(userId: userId)),
      child: Container(
        child: BlocBuilder<UserPhotoBloc, UserPhotoState>(
            builder: (BuildContext context, UserPhotoState state) {
          if (state is UserPhotoLoadFailure ||
              state is UserPhotoUpdateFailure ||
              state is UserPhotoUninitialized) {
            BlocProvider.of<UserPhotoBloc>(context)
                .add(UserPhotoRequested(userId: userId));
            return Container(
              height: radius * 2,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      _iconAvatar(),
                      (editable)
                          ? _editWidget(context)
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is UserPhotoLoadSuccess) {
            final Uint8List photoBytes = state.userPhoto.readAsBytesSync();
            return Container(
              height: radius * 2,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      _photoAvatar(photoBytes),
                      (editable)
                          ? _editWidget(context)
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is UserPhotoUpdateSuccess) {
            final Uint8List photoBytes = state.userPhoto.readAsBytesSync();
            return Container(
              height: radius * 2,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      _photoAvatar(photoBytes),
                      (editable)
                          ? _editWidget(context)
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }

  Widget _editWidget(BuildContext context) {
    return Positioned(
      right: 5,
      bottom: 1,
      height: 0.5 * radius,
      child: FloatingActionButton(
        child: FaIcon(FontAwesomeIcons.edit, color: Colors.white),
        onPressed: () => _pickImage(context),
      ),
    );
  }

  void _pickImage(BuildContext context) async {
    File selectedPhoto =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    BlocProvider.of<UserPhotoBloc>(context)
        .add(UserPhotoUpdated(userPhoto: selectedPhoto));
  }

  Widget _photoAvatar(Uint8List photoBytes) {
    return CircularProfileAvatar(
      '',
      child: Image.memory(photoBytes),
      radius: radius,
      borderWidth: borderWidth,
      borderColor: Colors.deepOrange,
      elevation: 5.0,
      onTap: null,
    );
  }

  Widget _iconAvatar() {
    return CircularProfileAvatar(
      '',
      child: FloatingActionButton(
        child: FaIcon(
          FontAwesomeIcons.user,
          color: Colors.white,
          size: (radius - 3 * borderWidth) * 2,
        ),
        onPressed: null,
      ),
      radius: radius,
      borderWidth: borderWidth,
      borderColor: Colors.deepOrange,
      elevation: 5.0,
      onTap: null,
    );
  }
}
