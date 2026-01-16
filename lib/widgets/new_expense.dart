import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'dart:io';

class NewExpense extends StatefulWidget{
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense>{

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  final _dateFormatter = DateFormat.yMd();
  Category _selectedCategory = Category.food;

  @override
  void dispose(){
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  
  void _presentDatePicker() async{
    final pickedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(DateTime.now().year - 1), 
      lastDate: DateTime.now(),
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog(){
    if (Platform.isIOS){
      showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Invalid input'),
        content: const Text('Please make sure a valid title, amount, date and category was entered.'),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(ctx);
          }, child: const Text('Okay'))
        ],
      ),
      );
    }
  else{
    showDialog(context: context, builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(ctx);
            }, child: const Text('Okay'))
          ],
        )
      );
  }
  }
  
  void _submitExpenseData(){
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);
    final selectedDate = _selectedDate;

    if (enteredTitle.isEmpty || enteredAmount == null || enteredAmount <= 0 || selectedDate == null){
      _showDialog();
      return;
    }
    widget.onAddExpense(Expense(
      title: enteredTitle,
      amount: enteredAmount,
      date: selectedDate,
      category: _selectedCategory,
    ));
    
    Navigator.pop(context);
  }
  


  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;


    return LayoutBuilder(builder: (ctx, constraints){
      final width = constraints.maxWidth;

      return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.fromLTRB(16,16,16,keyboardSpace + 16),
                        child: Column(
                          children: [
                            if (width > 600)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _titleController,
                                    maxLength: 50,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      labelText: 'Title',
                                  ),
                                  ),
                                ),
                                const SizedBox(width: 16,),
                                Expanded(
                                  child:   TextField(
                                    controller: _amountController,
                                    decoration: const InputDecoration(
                                      prefixText: '\$ ',
                                      labelText: 'Amount',
                                  ),
                                  )),
                              ],
                            )
                            else
                              TextField(
                                controller: _titleController,
                                maxLength: 50,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                              ),
                              ),
                            if (width > 600)
                              Row(
                                children: [
                                  const SizedBox(width: 16,),
                                  DropdownButton(
                                  value: _selectedCategory,
                                  items: Category.values.map(
                                  (category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(
                                        category.name.toUpperCase(),
                                      ),
                                    );
                                  },
                                ).toList(
                                ), onChanged: (value){
                                  if (value == null){
                                    return;
                                  }
        
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                }),
                                  const Spacer(),
                                  Expanded(child:   Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(_selectedDate == null ? 'No date chosen' : _dateFormatter.format(_selectedDate!)),
                                      IconButton(onPressed: (){
                                        _presentDatePicker();
                                      }, icon: const Icon(Icons.calendar_month)),
                                    ],
                                  )
                                  ),
                                ],
                              )
                              
                              else
                                  Row(
                                    children: [
                                      Expanded(child:   TextField(
                                        controller: _amountController,
                                        decoration: const InputDecoration(
                                          prefixText: '\$ ',
                                          labelText: 'Amount',
                                      ),
                                      )),
                                      const SizedBox(width: 16,),
                                      Expanded(child:   Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(_selectedDate == null ? 'No date chosen' : _dateFormatter.format(_selectedDate!)),
                                          IconButton(onPressed: (){
                                            _presentDatePicker();
                                          }, icon: const Icon(Icons.calendar_month)),
                                        ],
                                      )
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16,),
                                  if (width > 600)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(onPressed: (){
                                          _submitExpenseData();
                                        },
                                        child: Text('Submit expense')),
                                        const SizedBox(width: 16,),
                                        ElevatedButton.icon(onPressed: (){
                                          Navigator.pop(context);
                                        }, 
                                        icon: Icon(Icons.close_outlined), 
                                        label: Text('Cancel'))
                                      ],
                                    )
                                  else
                                  Row(
                                    children: [
                                      DropdownButton(
                                        value: _selectedCategory,
                                        items: Category.values.map(
                                        (category) {
                                          return DropdownMenuItem(
                                            value: category,
                                            child: Text(
                                              category.name.toUpperCase(),
                                            ),
                                          );
                                        },
                                      ).toList(
                                      ), onChanged: (value){
                                        if (value == null){
                                          return;
                                        }
              
                                        setState(() {
                                          _selectedCategory = value;
                                        });
                                      }),
                                      Spacer(),
                                      ElevatedButton(onPressed: (){
                                        _submitExpenseData();
                                      },
                                      child: Text('Submit expense')),
                                      ElevatedButton.icon(onPressed: (){
                                        Navigator.pop(context);
                                      }, 
                                      icon: Icon(Icons.close_outlined), 
                                      label: Text('Cancel'))
                                    ],
                                  )
                          ],
                        )),
      ),
    );
    } );
  }
}