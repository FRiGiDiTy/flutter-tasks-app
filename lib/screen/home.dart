import 'package:flutter/material.dart';
import 'package:tasks_flutter_v2/common/helper.dart';
import 'package:tasks_flutter_v2/model/todo.dart';
import 'package:tasks_flutter_v2/model/todo_list.dart';
import 'package:tasks_flutter_v2/routes.dart';
import 'package:tasks_flutter_v2/widget/todo_bloc_provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  static const String _addList = 'Add list';
  static const String _openSettings = 'Settings';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TodoListProvider.of(context).loginViaGoogle(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? // Logged in
              showApp(context)
/*                  MaterialButton(
                      onPressed: () => TodoListProvider.of(context).logout(),
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text('Signout'),
                    )*/
              // Need to login
              : Scaffold(
                  appBar: AppBar(
                    title: Text('Test'),
                  ),
                  body: Center(
                    child: MaterialButton(
                      onPressed: () => null,
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text('Login with Google'),
                    ),
                  ),
                );
        });
  }

  StreamBuilder showApp(BuildContext context) {
    return StreamBuilder(
        stream: TodoListProvider.of(context).todoLists,
        builder: (context, snapshot) {
          Text title = Text('Tasks');

          if (snapshot.hasData) {
            List<TodoList> todoLists = snapshot.data;

            if (todoLists.isNotEmpty) {
              TabController tabController =
                  TabController(length: todoLists.length, vsync: this);

              FloatingActionButton fab = FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, Routes.addTask,
                    arguments: {'todoList': todoLists[tabController.index]}),
                child: Icon(Icons.add),
              );

              return Scaffold(
                appBar: AppBar(
                    title: title,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.sort),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {},
                      ),
                      PopupMenuButton<String>(
                        onSelected: _onSelectMenuItem,
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              Helper.buildMenuItem(
                                  Icons.playlist_add, _addList),
                              Helper.buildMenuItem(
                                  Icons.settings, _openSettings),
                            ],
                      )
                    ],
                    bottom: TabBar(
                      controller: tabController,
                      tabs: todoLists.map((todoList) {
                        return Tab(
                          text: todoList.title,
                        );
                      }).toList(),
                    )),
                body: TabBarView(
                  controller: tabController,
                  children: todoLists.map((todoList) {
                    return todoList.todos.isNotEmpty
                        ? _buildListView(todoList)
                        : _buildEmptyContainer();
                  }).toList(),
                ),
                floatingActionButton: fab,
              );
            }
          }

          // no todoLists
          return Scaffold(
              appBar: AppBar(
                title: title,
              ),
              body: Center(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Add a list'),
                      onPressed: () => TodoListProvider.of(context).addTodoList(
                              TodoList(title: 'Homework', todos: [
                            Todo(title: 'Titel', note: 'Note', position: 0)
                          ])),
                    ),
                    RaisedButton(
                      child: Text('Firestore'),
                      onPressed: () {
                        Stream<List<TodoList>> stream =
                            TodoListProvider.of(context).todoLists;
                        print(stream.first);
                        stream.first
                            .then((todoList) => print(todoList.toString()));
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Center _buildEmptyContainer() => Center(child: Text('Empty'));

  ListView _buildListView(TodoList todoList) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(todoList.todos[index].title),
            onTap: () => Navigator.pushNamed(context, Routes.editTask,
                    arguments: {
                      'todoList': todoList,
                      'todo': todoList.todos[index]
                    }),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: todoList.todos.length);
  }

  void _onSelectMenuItem(String value) {
    switch (value) {
      case _addList:
        _addTodoList();
        break;
      case _openSettings:
        break;
      default:
    }
  }

  void _addTodoList() {
    Helper.showInputDialog(context, title: 'New list', hint: 'Name')
        .then((input) {
      if (input == null || input.isEmpty) {
      } else {
        final TodoList todoList = TodoList(title: input);
        TodoListProvider.of(context).addTodoList(todoList);
      }
    });
  }
}