import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget{
  const NewExpense({super.key});

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
  
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                        ),
                        ),
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
                                _selectedCategory = value!;
                              });
                            }),
                            Spacer(),
                            ElevatedButton(onPressed: (){
                              // ignore: avoid_print
                              print(" Title: ${_titleController.text}, Amount: ${_amountController.text} ");
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
                    ));
  }
}