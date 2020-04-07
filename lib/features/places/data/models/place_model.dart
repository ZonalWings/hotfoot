import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

class PlaceModel extends PlaceEntity {

  const PlaceModel({
    @required String id,
    @required String name,
    @required String address,
    @required LocationEntity locationEntity,
    @required String photoUrl,
    @required int orders,
  }) : super(
          id: id,
          name: name,
          address: address,
          locationEntity: locationEntity,
          photoUrl: photoUrl,
          orders: orders,
        );

  factory PlaceModel.fromJson(Map json) => json != null
      ? PlaceModel(
          id: (json['id'] as String),
          name: (json['name'] as String),
          address: (json['address'] as String),
          locationEntity: LocationModel.fromJson(json['location']),
          photoUrl: (json['photoUrl'] as String),
          orders: (json['orders'] as int),
        )
      : null;

  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['address'] = address;
    map['location'] = (locationEntity as LocationModel).toJson();
    map['photoUrl'] = photoUrl;
    map['orders'] = orders;
    return map;
  }
}
