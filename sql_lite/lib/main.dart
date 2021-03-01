import 'package:flutter/material.dart';
import 'package:sql_lite/utils/database_utils.dart';

import 'models/persons_model.dart';
const darkYellowColor = Colors.yellow;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personas vulnerables',
      theme: ThemeData(

        primaryColor: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Personas vulnerables'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 // int _counter = 0;
  Person _person = Person();
  List<Person> _persons =[];
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();

@override
void initState(){
  super.initState();
  setState((){
    _dbHelper = DatabaseHelper.instance;
  });
  _refreshPersonList();
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(widget.title),
          
          ),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _form(),_list()
          ],
        ),
      ),
    );
  }

  _form() => Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical:20,horizontal:30),
    child:Form(
        key: _formKey,
        child: Column(
          children: <Widget> [
            TextFormField(
              decoration:  InputDecoration(labelText: 'Cédula'),
              onSaved: (val) => setState(() => _person.identy = val),
              validator: (val)=>(val.length==0 ? 'El campo es obligatorio':null),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre'),
              onSaved: (val) => setState(() => _person.name = val),
              validator: (val)=>(val.length==0 ? 'El campo es obligatorio':null),
            ),
            TextFormField(
              decoration:  InputDecoration(labelText: 'Apellido'),
              onSaved: (val) => setState(() => _person.lastname = val),
              validator: (val)=>(val.length==0 ? 'El campo es obligatorio':null),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Fecha de nacimiento (dd/mm/aaaa)'),
              onSaved: (val) => setState(() => _person.datebirth = val),
              validator: (val)=>( val.length !=10 ? 'Verifique el formato dd/mm/AAAA':null),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '¿Tiene alguna Discapacidad?'),
              onSaved: (val) => setState(() => _person.disability = val),
              validator: (val)=>(val.length==0 ? 'El campo es obligatorio':null),
            ),


            Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(onPressed: ()=> _onSubmit(),
              child: Text('Enviar'),
              color: darkYellowColor,
              textColor: Colors.white
              ),
            )
          ],
        ),
    )
  );

  _refreshPersonList() async{
    List<Person> x = await _dbHelper.fetchPersons();
    setState(() {
      _persons = x;
    });
  }


  _onSubmit() async{
    var form = _formKey.currentState;
    if(form.validate()){
      form.save();
      await _dbHelper.insertPerson(_person);
      _refreshPersonList();
      form.reset();
    }
    
  }
  _list() =>Expanded(
    child: Card(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: (context,index) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.account_circle,
                size:40
                ),
                title: Text(_persons[index].name.toUpperCase()+" "+_persons[index].lastname.toUpperCase()),
                subtitle: Text("Cédula:"+_persons[index].identy.toUpperCase()+"\n"+"Fecha nacimiento:"+_persons[index].datebirth.toUpperCase()+"\n"+"Discapacidad:"+_persons[index].disability.toUpperCase()),
              ),
              Divider(height: 5.0,)
            ],
          );
        },

        itemCount: _persons.length,
      ),
    
    ),
  );

}
