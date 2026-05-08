import 'package:hive/hive.dart';

class UserAccount {
  final String username;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;

  UserAccount({
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
}

class UserAccountAdapter extends TypeAdapter<UserAccount> {
  @override
  final int typeId = 0;

  @override
  UserAccount read(BinaryReader reader) {
    final username = reader.readString();
    final fullName = reader.readString();
    final email = reader.readString();
    final phoneNumber = reader.readString();
    final password = reader.readString();
    return UserAccount(
      username: username,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  @override
  void write(BinaryWriter writer, UserAccount obj) {
    writer.writeString(obj.username);
    writer.writeString(obj.fullName);
    writer.writeString(obj.email);
    writer.writeString(obj.phoneNumber);
    writer.writeString(obj.password);
  }
}
