import 'package:flutter/material.dart';

import '../utils/totoStorage.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.storage}) : super(key: key);
  final ToDoStorage storage;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List todoList = [];
  String _titleAppBar = 'Планировщик';

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

  String _userTodo = '';
  String _emptyInfo = 'Тут пока ничего нет';

  //считать данные с файла при загрузке
  @override
  void initState() {
    super.initState();

    //считать кол-во задач
    widget.storage.readCountTodo().then((int index) {
      setState(() {
        _titleAppBar = index.toString();
      });
    });

    //считать задачи
    widget.storage.readTodo(1).then((String val) {
      setState(() {
        if (val=='ADM:file_not_exist#35698751-12_88') {
          //нихуя не делать
        } else {
          todoList.add(val);
        }
      });
      checkEmptyTodoList();
    });
  }

  //запись задания в файл и кол-во заданий
  void _saveTodoInFile(String userTodo) {
    widget.storage.writeTodo(userTodo);
    widget.storage.writeCountTodo(1);
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
                widget.storage.deleteFile();
              },
              icon: const Icon(Icons.delete_outline)
          ),
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.adb),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: Text(_emptyInfo,style: const TextStyle(
                color: Colors.white12,
                //fontWeight: FontWeight.bold,
                fontSize: 24
              ),)
          ),
          ListView.builder(
            itemCount: todoList.length,
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
                  setState(() {
                    deleteTodo(index);
                  });
                },
              );
            },
        ),]
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
                          if(_userTodo=='') {
                            //нихуя не делать
                          } else {
                            setState(() {
                              todoList.add(_userTodo);
                            });
                            _saveTodoInFile(_userTodo);
                            _userTodo = '';
                            Navigator.pop(context);
                          }
                          checkEmptyTodoList();
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
