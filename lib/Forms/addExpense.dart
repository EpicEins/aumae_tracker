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

class addExpensePage extends StatelessWidget {
  static const routeName = 'add_expense_page';
  static const fullPath = '/$routeName';
  final _dateController = TextEditingController();

  addExpensePage({super.key});

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
                        initialValue: "Expense Name",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(

                        enabled: false,
                        controller: _dateController,
                        onTap: () async {
                          var newDate = await showCalendarDatePicker2Dialog(
                            context: context,
                            config:
                                CalendarDatePicker2WithActionButtonsConfig(),

                            dialogSize: const Size(325, 400),
                            initialValue: [],
                            borderRadius: BorderRadius.circular(15),
                          );
                          if (newDate.toString() == null) {
                            _dateController.text = formattedDateNow.toString();
                          } else {
                            DateTime date = DateTime.fromMillisecondsSinceEpoch(now);

                            final DateFormat formatter = DateFormat('MM-dd-yyyy');
                            final String formattedDateNow = formatter.format(date);
                            var formattedNewDate;
                            for (var i in newDate!) {
                              formattedNewDate = formatter.format(i!);
                            }
                            //_dateController.text = newDate.toString();
                            _dateController.text = formattedNewDate.toString();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // Add TextFormFields and ElevatedButton here.
            ],
          ),
        )));
  }
}
