import 'dart:math';

import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget{
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense>{
  var _enteredTitle = '';

  void _saveTitleInput(String inputValue) {
    _enteredTitle = inputValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: _saveTitleInput,
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                        ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(onPressed: (){
                              print(_enteredTitle);
                            },
                            child: Text('Submit expense'))
                          ],
                        )
                      ],
                    ));
  }
}