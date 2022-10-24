// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constants/cache/cache_constants.dart';

part 'app_cache_model.g.dart';

@HiveType(typeId: CacheConstants.appCacheTypeId)
class AppCacheModel extends Equatable {
  @HiveField(0)
  final String? username;
  @HiveField(1)
  final String? password;

  const AppCacheModel(this.username, this.password);

  AppCacheModel copyWith({
    String? username,
    String? password,
  }) {
    return AppCacheModel(
      username ?? this.username,
      password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [username, password];
}
