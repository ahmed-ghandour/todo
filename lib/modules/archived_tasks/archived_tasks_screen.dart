import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build (BuildContext context)
  {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit ,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        return ConditionalBuilderRec(
          condition: AppCubit.get(context).archivedTasks.isNotEmpty ,
          builder:(context) => ListView.separated(
              itemBuilder: (context,index)=> buildTaskItem(cubit.archivedTasks[index],context) ,
              separatorBuilder: (context,index)=> Container(
                color: Colors.grey[300],
                height: 1,
                width: double.infinity,
              ),
              itemCount: cubit.archivedTasks.length),
          fallback: (context)=> taskBuilder( tasks : AppCubit.get(context).archivedTasks),
        );
      },

    );
  }
}