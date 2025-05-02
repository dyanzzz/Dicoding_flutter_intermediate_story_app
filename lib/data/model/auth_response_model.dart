import 'package:freezed_annotation/freezed_annotation.dart';

import 'login_result.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required bool error,
    required String message,
    @JsonKey(name: "loginResult") LoginResult? loginResult,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}
