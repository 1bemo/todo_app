import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  List<TextOverflow> _overTextList = [];
  TextOverflow _overText = TextOverflow.ellipsis;

  //var _debugVar;

  @override
  void initState() {
    super.initState();
    checkEmptyTodo();
  }

  ////////////-------------отдельная менюха---------////////////
  // void _menuOpen() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (BuildContext context){
  //       return Scaffold(
  //         appBar: AppBar(
  //           title: const Text('Menu'),
  //         ),
  //         body: Row(
  //           children: [
  //             ElevatedButton(
  //                 onPressed: (){
  //                   Navigator.pop(context);
  //                   Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  //                 },
  //                 child: const Text('На главную')
  //             ),
  //             const Padding(padding: EdgeInsets.only(right: 15)),
  //             const Text('Наше простое меню'),
  //           ],
  //         ),
  //       );
  //     })
  //   );
  // }

  void checkEmptyTodo() {
    FirebaseFirestore.instance.collection('items').get().then((snap) {
      if (snap.docs.isNotEmpty) {
        setState(() {
          _emptyInfo = '';
        });
      } else {
        setState(() {
          _emptyInfo = 'Тут пока ничего нет';
        });
      }
    });
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
            //кнопка для полного удаления
              onPressed: (){

                FirebaseFirestore.instance.collection('items').get().then((snap) {
                  if (snap.docs.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('Удалить все записи?'),
                          actions: [
                            ElevatedButton(
                                onPressed: (){
                                  //получаем снапшот
                                  FirebaseFirestore.instance.collection('items').get().then((snap) {
                                    //для каждого документа в снапшоте
                                    for(DocumentSnapshot ds in snap.docs) {
                                      //удалить
                                      ds.reference.delete();
                                    }
                                  });
                                  checkEmptyTodo();
                                  Navigator.pop(context);
                                },
                                child: const Text('Да')
                            ),
                            const Padding(padding: EdgeInsets.only(right: 10)),
                            ElevatedButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: const Text('Нет')
                            ),
                          ],
                        );
                      },
                    );
                  }
                });
              },
              icon: const Icon(Icons.delete_forever_sharp)
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                            Text(
                              'Список загружается...',
                              style: TextStyle(
                                color: Colors.white10,
                                fontSize: 16,
                              ),
                            ),
                        ],
                      ),
                    );
                  } else {
                    //иначе вернуть ЛистВью.билдер со списком
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible( //свайповый блок
                            key: Key(snapshot.data!.docs[index].id),  //что передаем
                            child: Container(
                              decoration: const BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 20,
                                  )
                                ]
                              ),
                              child: Card( //что внутри блока
                                child: ListTile(
                                  onTap: (){
                                    setState(() {
                                      if(_overText==TextOverflow.ellipsis) {
                                        _overText = TextOverflow.visible;
                                      } else {
                                        _overText = TextOverflow.ellipsis;
                                      }
                                    });
                                  },
                                  title: Text(
                                    snapshot.data!.docs[index].get('item'),
                                    overflow: _overText,
                                  ),
                                  trailing: IconButton(
                                    onPressed: (){
                                      FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                                      checkEmptyTodo();
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Theme.of(context).colorScheme.primary,
                                    tooltip: 'Удалить',
                                  ),
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                              checkEmptyTodo();
                            },
                          );
                        },
                      ),
                    );
                  }
                }
              ),

              //--------Админ панель--------//
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         Container(
              //           padding: const EdgeInsets.all(5),
              //           alignment: Alignment.center,
              //           width: 200,
              //           height: 200,
              //           color: Colors.red,
              //           child: Text('$_debugVar')
              //         ),
              //       ],
              //     ),
              //     Container(
              //       margin: const EdgeInsets.only(left: 2),
              //       child: IconButton(
              //         color: Colors.red,
              //         onPressed: (){},
              //         icon: const Icon(Icons.android_outlined)
              //       )
              //     )
              //   ],
              // ),
              //--------Админ панель--------/////

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
                    minLines: 1,
                    maxLines: 10,
                    autofocus: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    onChanged: (String value) {
                      _userTodo = value;
                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text('Отмена')
                    ),
                    ElevatedButton(
                        onPressed: (){
                          if(_userTodo.isNotEmpty) {
                            //Класс ФайрейсФайрстор(подключаемый выше) - инстанс(использовать текущее подключение к базе) -
                            //коллекшен(коллекция с именем айтемс(если такой не будет, она автоматом создастся)) -
                            //метод адд(добавить)
                            //обавляем объект(ключ-значение). В значение записываем строку от пользователя
                            FirebaseFirestore.instance
                                .collection('items').add({'item': _userTodo});
                            _userTodo = '';
                            checkEmptyTodo();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Добавить')
                    ),
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
