
import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
    UserInfo({
        this.status,
        this.userInfo,
    });

    String? status;
    UserInfoClass? userInfo;

    factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        status: json["status"],
        userInfo: UserInfoClass.fromJson(json["userInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "userInfo": userInfo!.toJson(),
    };
}

class UserInfoClass {
    UserInfoClass({
        this.token,
        this.profileImage,
        this.name,
        this.email,
        this.welcomeMessage,
    });

    String? token;
    String? profileImage;
    String? name;
    String? email;
    String? welcomeMessage;

    factory UserInfoClass.fromJson(Map<String, dynamic> json) => UserInfoClass(
        token: json["token"],
        profileImage: json["profileImage"],
        name: json["name"],
        email: json["email"],
        welcomeMessage: json["welcomeMessage"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "profileImage": profileImage,
        "name": name,
        "email": email,
        "welcomeMessage": welcomeMessage,
    };
}
