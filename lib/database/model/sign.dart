//(id INTEGER PRIMARY KEY, poteau_id INTEGER, x REAL, y REAL, desc TEXT, code TEXT, fleche INTEGER)

class Sign {
  int _id;
  double _x;
  double _y;
  int _poteauId;
  String _desc;
  String _code;
  int _fleche;

  Sign(this._id, this._x, this._y, this._poteauId, this._desc, this._code,
      this._fleche);

  Sign.map(dynamic obj) {
    this._id = obj["id"];
    this._x = obj["x"];
    this._y = obj["y"];
    this._poteauId = obj["poteauId"];
    this._desc = obj["desc"];
    this._code = obj["code"];
    this._fleche = obj["fleche"];
  }

  int get id => _id;

  double get x => _x;

  double get y => _y;

  String get desc => _desc;

  String get code => _code;

  int get poteauId => _poteauId;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();


    map["id"] = _id;
    map["x"] = _x;
    map["y"] = _y;
    map["poteauId"] = _poteauId;
    map["desc"] = _desc;
    map["code"] = _code;
    map["fleche"] = _fleche;

    return map;
  }
}
