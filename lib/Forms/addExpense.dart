import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aumae_tracker/models/favorites.dart';
import 'package:aumae_tracker/Database/database.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';
import '../main.dart';

var now = DateTime.now().millisecondsSinceEpoch;
var currentDate = DateTime.now();
DateTime date = DateTime.fromMillisecondsSinceEpoch(now);

final DateFormat formatter = DateFormat('MM-dd-yyyy');
final String formattedDateNow = formatter.format(date);

class addExpensePage extends StatefulWidget {
  const addExpensePage({Key? key, required this.title}) : super(key: key);
  static const routeName = 'addExpensePage';
  static const fullPath = '/$routeName';

  final String title;

  @override
  State<addExpensePage> createState() => addExpensePageState();
}

class addExpensePageState extends State<addExpensePage> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  static const routeName = 'add_expense_page';
  static const fullPath = '/$routeName';
  final _dateController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _dateController.text = formattedDateNow.toString();
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Expense'),
        ),
        body: Center(
            child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Expense Name *',
                        ),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String? value) {
                          return (value != null) ? 'Please enter a name' : null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                        ),
                        const SizedBox(height: 20.0,),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Select date'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              // Add TextFormFields and ElevatedButton here.
            ],
          ),
        )));
  }
}
