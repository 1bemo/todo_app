import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List todoList = [];
  String _userTodo = '';
  String _emptyInfo = 'Тут пока ничего нет';
  final String _titleAppBar = 'Планировщик';

  //ф-я асинхр. для подключения Файрбейс (ее помещаем в ИнитСтейт)
  void initFirebase() async {
    //инициалиация и подключение файрбейс
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  //проверка на отсутствие задач
  void checkEmptyTodoList() {
    if(todoList.isNotEmpty) {
      _emptyInfo = '';
    } else {
      _emptyInfo = 'Тут пока ничего нет';
    }
  }

  //удаление задачи
  void deleteTodo(int index) {
    setState(() {
      todoList.removeAt(index);
      checkEmptyTodoList();
    });
  }

  final String _debugVar = '';

  @override
  void initState() {
    super.initState();

    //ф-я для подключния файрбейс при старте приложения
    initFirebase();
    checkEmptyTodoList();
  }

  void _menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(
            title: const Text('Menu'),
          ),
          body: Row(
            children: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  child: const Text('На главную')
              ),
              const Padding(padding: EdgeInsets.only(right: 15)),
              const Text('Наше простое меню'),
            ],
          ),
        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(_titleAppBar),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              onPressed: (){
                //по задумке полностью очистить список
              },
              icon: const Icon(Icons.delete_outline)
          ),
          IconButton(
              onPressed: _menuOpen,
              icon: const  Icon(Icons.menu_outlined)
          )
        ],
      ),
      body:
          Stack(
            children: <Widget>[
              Center(
                  child: Text(_emptyInfo,style: const TextStyle(
                    color: Colors.white12,
                    //fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),)
              ),
              //стримбилдер для работы с асинхр данными
              StreamBuilder(
                //сам поток - это наша коллекция Айтемс иее снапшот(все содержимое)
                stream: FirebaseFirestore.instance.collection('items').snapshots(),
                //билдер - что возвращать
                //в параметрах передаем много всего. ПРОСТО ЗАПОМНИТЬ !!!!!!!!!!
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //если наш снепшот не имеет записей
                  if(!snapshot.hasData) {
                    //вернуть текст - нет записей
                    return const Text('No strokes');
                  } else {
                    //иначе вернуть ЛистВью.билдер со списком
                    return ListView.builder(

                      ////////////////////
                      // остановился тут//
                      ////////////////////

                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible( //свайповый блок
                          key: Key(todoList[index]),  //что передаем
                          child: Card(  //что внутри блока
                            child: ListTile(
                                title: Text(todoList[index]),
                                trailing: IconButton(
                                  onPressed: (){
                                    deleteTodo(index);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Theme.of(context).colorScheme.primary,
                                  tooltip: 'Удалить',
                                )
                            ),
                          ),
                          onDismissed: (direction) {
                            //if(direction==DismissDirection.startToEnd)
                            deleteTodo(index);
                          },
                        );
                      },
                    );
                  }
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 50,
                        color: Colors.red,
                        child: Text(_debugVar)
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 2),
                    child: IconButton(
                      color: Colors.red,
                      onPressed: (){},
                      icon: const Icon(Icons.android_outlined)
                    )
                  )
                ],
              ),
            ],
          ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Добавить задачу',
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: const Text('Добавить задачу'),
                  content: TextField(
                    onChanged: (String value) {
                      _userTodo = value;
                    },
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: (){

                          //---------------------старый вариант
                         /* if(_userTodo=='') {
                            //нихуя не делать
                          } else {
                            setState(() {
                              todoList.add(_userTodo);
                            });
                            _userTodo = '';
                            Navigator.pop(context);
                          }
                          checkEmptyTodoList();*/

                          //-----------------------новый вариант
                          //Класс ФайрейсФайрстор(подключаемый выше) - инстанс(использовать текущее подключение к базе) -
                          //коллекшен(коллекция с именем айтемс(если такой не будет, она автоматом создастся)) -
                          //метод адд(добавить)
                          //обавляем объект(ключ-значение). В значение записываем строку от пользователя
                          FirebaseFirestore.instance
                              .collection('items').add({'item': _userTodo});

                          Navigator.pop(context);
                        },
                        child: const Text('Добавить')
                    )
                  ],
                );
              }
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
