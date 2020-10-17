
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nomoni_app/pages/edit_expense.dart';
import 'package:nomoni_app/utils/user_prefs.dart';
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nomoni_app/utils/api.dart' as api;
import 'package:nomoni_app/widgets/MyDrawer.dart';

class Expenses extends StatefulWidget {
  final String title;

  Expenses({Key key, this.title}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  List<dynamic> expensesList = [];
  Future expensesFuture;

  @override
  void initState() {
    super.initState();
    expensesFuture = _loadData();
  }

  Future<void> _loadData() async {
		int id = UserPrefs.instance.id;
    return api.get('expenses/by-user/$id').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
				expensesList = data['expenses'];
      }
    });
  }

  Future<void> _deleteSpend(int id) async {
    await api.delete('expenses/$id').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        expensesList = [];
        _loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MyDrawer(),
      body: Container(
				child: Column(
					children: <Widget>[
						Text(
							'Hello, ${expensesList.length} How are you?',
							textAlign: TextAlign.center,
							overflow: TextOverflow.ellipsis
						),
						Expanded(
							child: FutureBuilder (
								future: expensesFuture,
								builder: (context, snapshot) {
									if (snapshot.connectionState == ConnectionState.done) {
										return Container(
											child: ListView.builder(
												itemCount: expensesList.length,
												itemBuilder: (context, index) {
													String concept = expensesList[index]['concept'];
													if (concept.length >= 22) {
														concept = expensesList[index]['concept'].substring(0, 22) + '...';
													}
													String createdAt = expensesList[index]['created_at'].substring(0, 16);
													return Slidable(
														actionPane: SlidableDrawerActionPane(),
														actionExtentRatio: 0.25,
														child: ListTile(
															onTap: () {},
															title: Text(concept),
															subtitle: Text(createdAt),
															// leading: Icon(Icons.add_photo_alternate),
															leading: FlutterLogo(),
															trailing: Container(child: Column(
																children: <Widget>[
																	// FlutterLogo(),
																	Text(
																		r"$ " + expensesList[index]['amount'],
																		textDirection: TextDirection.ltr,
																		style: TextStyle(
																			fontSize: 24,
																			color: Colors.black87,
																		),
																	),
																],
															)),
														),
														actions: <Widget>[
															IconSlideAction(
																caption: 'Archive',
																color: Colors.blue,
																icon: Icons.archive,
																onTap: () { 
																	Scaffold.of(context).showSnackBar(SnackBar(
																		content: Text('Archive'),
																	));
																}
															),
															IconSlideAction(
																caption: 'Edit',
																color: Colors.indigo,
																icon: Icons.update,
																onTap: () {
                                  // ExpensesModel expense = ExpensesModel.fromJson(expensesList[index]);
                                  // ExpensesModel expense = ExpensesModel.fromJson(params);
                                  int id = expensesList[index]['id'];
																	Navigator.push(
																		context,
																		MaterialPageRoute(
																			builder: (context) => EditExpense(id: id),
																		),
																	);
																}
															),
														],
														secondaryActions: <Widget>[
															IconSlideAction(
																caption: 'More',
																color: Colors.black45,
																icon: Icons.more_horiz,
																onTap: () { 
																	Scaffold.of(context).showSnackBar(SnackBar(
																		content: Text('More'),
																	));
																}
															),
															IconSlideAction(
																caption: 'Delete',
																color: Colors.red,
																icon: Icons.delete,
																onTap: () {
																	_deleteSpend(expensesList[index]['id']);
																}
															),
														],
													);
												}
											)
										);
									} else {
										return CircularProgressIndicator();
									}
								}
							),
						),
					]
				)
			),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_expense');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
