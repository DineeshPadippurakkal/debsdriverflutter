class ChangePasswordRequest {
  String? confirmPassword;
  String? currentPassword;
  String? newPassword;

  ChangePasswordRequest(
      {this.confirmPassword, this.currentPassword, this.newPassword});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    confirmPassword = json['confirm_password'];
    currentPassword = json['current_password'];
    newPassword = json['new_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['confirm_password'] = confirmPassword;
    data['current_password'] = currentPassword;
    data['new_password'] = newPassword;
    return data;
  }
}