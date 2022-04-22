import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>() ;
  var formKey = GlobalKey<FormState>() ;

  var titleController = TextEditingController() ;
  var timeController = TextEditingController() ;
  var dateController = TextEditingController() ;

  HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context ,AppStates state)
        {
          if (state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context ,AppStates state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]
              ),
              actions:
              [
                IconButton(
                    onPressed: ()
                    {
                      cubit.changeAppMode();
                    },
                    icon: const Icon(Icons.brightness_4_outlined)
                )
              ],
            ),
            body: ConditionalBuilderRec(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context)=> cubit.screens[cubit.currentIndex],
              fallback:(context)=> const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: ()
                {
                  if(cubit.isBottomSheetShown)
                  {
                    if (formKey.currentState!.validate())
                    {
                      cubit.insertToDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text
                      );
                    }
                  }
                  else
                  {
                    scaffoldKey.currentState!.showBottomSheet((context) =>
                        Container
                          (
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child : Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                [
                                  defaultFormField
                                    (
                                      label: "Task",
                                      controller: titleController,
                                      type: TextInputType.text,
                                      prefix: Icons.title,
                                      validate: (value)
                                      {
                                        if ( value == null || value.isEmpty )
                                        {
                                          return'you must enter a name';
                                        }
                                        return null ;
                                      }
                                  ),
                                  const SizedBox(height: 15
                                  ),
                                  defaultFormField
                                    (

                                      label: "Time",
                                      controller: timeController,
                                      type: TextInputType.datetime,
                                      prefix: Icons.watch_later_outlined,
                                      onTap: ()
                                      {
                                        showTimePicker(
                                            context: context,
                                            initialTime:TimeOfDay.now()).then((value)
                                        {
                                          print(value!.format(context));
                                          timeController.text = value.format(context);
                                        }
                                        );
                                      },
                                      validate: (value)
                                      {
                                        if ( value == null || value.isEmpty )
                                        {
                                          return'you must enter a time ';
                                        }
                                        return null ;
                                      }
                                  ),
                                  const SizedBox(height: 15
                                  ),
                                  defaultFormField
                                    (

                                      label: "Date",
                                      controller: dateController,
                                      type: TextInputType.datetime,
                                      prefix: Icons.calendar_today_outlined,
                                      onTap: ()
                                      {
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.parse('2022-02-26')
                                        ).then((value)
                                        {
                                          dateController.text = DateFormat.yMMMd().format(value!);
                                        }
                                        );
                                      },
                                      validate: (value)
                                      {
                                        if ( value == null || value.isEmpty )
                                        {
                                          return 'you must enter a date ';
                                        }
                                        return null ;
                                      }
                                  )
                                ],
                              ),
                            )
                        ),
                      elevation: 20,
                    ).closed.then((value)
                    {
                      cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                    });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon,
                )
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index)
              {
                cubit.changeIndex(index);
              },
              items:
              const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived'
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}

