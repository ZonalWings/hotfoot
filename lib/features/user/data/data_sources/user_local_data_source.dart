import 'dart:io';

import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_photo_dao.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_dao.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';

abstract class IUserLocalDataSource {
  Future<UserModel> insertOrUpdateUser({@required UserModel userModel});

  Future<UserModel> getUserInfo();

  Future<void> insertOrUpdateUserPhoto({@required File userPhotoFile});

  Future<File> getUserPhoto();
}

class UserLocalDataSource implements IUserLocalDataSource {
  final IUserDao userDao;
  final IUserPhotoDao userPhotoDao;

  const UserLocalDataSource({
    @required this.userDao,
    @required this.userPhotoDao,
  })  : assert(userDao != null),
        assert(userPhotoDao != null);

  @override
  Future<UserModel> insertOrUpdateUser({UserModel userModel}) async {
    return await userDao.insertOrUpdate(userModel: userModel);
  }

  @override
  Future<UserModel> getUserInfo() async {
    return await userDao.get();
  }

  @override
  Future<File> getUserPhoto() async {
    final String userId = (await userDao.get()).id;
    return await userPhotoDao.get(id: userId);
  }

  @override
  Future<void> insertOrUpdateUserPhoto({File userPhotoFile}) async {
    final String userId = (await userDao.get()).id;
    return await userPhotoDao.insertOrUpdate(
      id: userId,
      photoFile: userPhotoFile,
    );
  }
}
