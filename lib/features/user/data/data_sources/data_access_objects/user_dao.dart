import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';

abstract class IUserDao {
  Future<void> insert({@required UserModel userModel});
  Future<void> update({@required UserModel userModel});
  Future<void> delete({@required String id});
  Future<List<String>> getPastOrderIds();
  Future<int> deleteAll();
  Future<UserModel> getUserInformation();
  Future<void> insertOrUpdate({UserModel userModel});
}

class UserDao implements IUserDao {
  final Database database;
  static const String _PLACE_ORDER_NAME = 'orders';
  final _orderStore = stringMapStoreFactory.store(_PLACE_ORDER_NAME);

  UserDao({@required this.database});

  @override
  Future<void> insert({@required UserModel userModel}) async {
    return await _orderStore
      .record(userModel.id)
      .put(database, userModel.toJson());
  }

  @override
  Future<void> update({@required UserModel userModel}) async {
    final finder = Finder(filter: Filter.byKey(userModel.id));
    return await _orderStore.update(
      database,
      userModel.toJson(),
      finder: finder,
    );
  }

  @override
  Future<void> delete({@required String id}) async {
    return await _orderStore.record(id).delete(database);
  }

  @override
  Future<List<String>> getPastOrderIds() async {
    final recordSnapshots = await _orderStore.find(database);
    if (recordSnapshots.length == 0) {
      return null;
    }
    final record = recordSnapshots[0];
    return UserModel.fromJson(record.value).pastOrderIds;
  }

  @override
  Future<int> deleteAll() async {
    return await _orderStore.delete(database);
  }

  @override
  Future<UserModel> getUserInformation() async {
    final recordSnapshots = await _orderStore.find(database);
    if (recordSnapshots.length == 0) {
      return null;
    }
    final record = recordSnapshots[0];
    return UserModel.fromJson(record.value);
  }

  @override
  Future<void> insertOrUpdate({UserModel userModel}) async {
    final finder = Finder(filter: Filter.byKey(userModel.id));
    final key = await _orderStore.findKey(
      database,
      finder: finder,
    );
    if (key != null) {
      await update(userModel: userModel);
    } else {
      await insert(userModel: userModel);
    }
  }

}