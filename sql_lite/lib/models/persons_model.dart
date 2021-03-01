class Person{
  static const tblPerson = 'persons';
  static const perId = 'id';
  static const perIdenty = 'identy';
  static const perName = 'name';
  static const perLastname = 'lastname';
  static const perDatebirth = 'datebirth';
  static const perDisability = 'disability';

  Person({this.id,this.identy,this.name,this.lastname,this.datebirth,this.disability});
  Person.fromMap(Map<String, dynamic> map){
    id = map[perId];
    identy =map[perIdenty];
    name = map[perName];
    lastname = map[perLastname];
    datebirth = map[perDatebirth];
    disability = map[perDisability];
  }
  int id;
  String identy;
  String name;
  String lastname;
  String datebirth;
  String disability;

  Map<String,dynamic>  toMap(){
  var map = <String,dynamic>{perIdenty:identy,perName:name,perLastname:lastname,perDatebirth:datebirth,perDisability:disability};
  if(id != null) map[perId]=id;
    return map;
}

}

