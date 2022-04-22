import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/styles/colors.dart';

Widget defaultButton ({
  double width = double.infinity ,
  Color background = Colors.blue,
  required String text ,
  required VoidCallback function,
  bool isUpperCase = true
    })=> Container(
    width: width ,
    child: MaterialButton(
        onPressed: function,
        child :
              Text(
                isUpperCase ? text.toUpperCase() : text ,
                style: const TextStyle( color: Colors.white),
              ),
        ),
    decoration: BoxDecoration( borderRadius : BorderRadius.circular(10.0),
      color: background,
    )
    );
Widget defaultTextButton({
  required String text,
  required VoidCallback function,
}) =>TextButton(onPressed: function, child: Text(text.toUpperCase()));

Widget defaultFormField (
{
  required String label,
  required TextEditingController controller,
  TextInputType? type,
  required IconData prefix,
  IconData? suffix,
  bool isPasword = false,
  required final String? Function (String? value)? validate,
  final void Function (String? value)? onSubmit,
  final void Function (String? value)? onChange,
  VoidCallback? suffixPressed,
  VoidCallback? onTap,
}
    )=> TextFormField(
  controller: controller ,
  keyboardType: type,
  obscureText: isPasword,
  decoration: InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    prefixIcon: Icon(prefix),
    suffixIcon: suffix != null ? IconButton(
        icon : Icon(suffix),
        onPressed : suffixPressed ): null
  ),
  validator: validate,
  onTap: onTap,
  onFieldSubmitted: onSubmit,
  onChanged: onChange
);
Widget buildTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children:
      [
        CircleAvatar(
            backgroundColor:defaultColor ,
            radius: 40,
            child :Text('${model['date']}',
           style: const TextStyle(fontSize:12,fontWeight: FontWeight.bold,color: Colors.white),)
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
            [
              Text('${model['time']}',
                style: const TextStyle(color:Colors.black45),),
              Text('${model['title']}',style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        const SizedBox(width: 10,),
        IconButton(
          onPressed: ()
          {
            AppCubit.get(context).updateData(status: 'done', id: model['id']);
            },
          icon: const Icon(Icons.check_box), color: defaultColor,
        ),
        IconButton(
          onPressed: ()
          {
            AppCubit.get(context).updateData(status: 'archived', id: model['id']);
            },
          icon: const Icon(Icons.archive),color: Colors.grey,
        )
      ],
    ),
  ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(id: model['id']);
  },
);

Widget taskBuilder({
  required List <Map> tasks
}) => Center(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children:
    const [
            Text('No Tasks, Please Add Some',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
                )
          ],
          ),
);