class BasicUser {
  BasicUser(this._displayName, this._email, this._nickname, this._uid);

  String _displayName;
  String _email;
  String _nickname;
  String _uid;

  String displayName() => _displayName;
  String email() => _email;
  String nickname() => _nickname;
  String uid() => _uid;
}
