import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/layout/todo.dart';
import 'package:to_do_app/shared/bloc_observer.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';
import 'package:to_do_app/shared/network/local/cashe_helper.dart';
import 'package:to_do_app/shared/styles/themes.dart';


void main() async
{
  BlocOverrides.runZoned( () async
  {
    WidgetsFlutterBinding.ensureInitialized();
    await CasheHelper.init();
    bool isDark = await CasheHelper.getData(key:'isDark');
    runApp( MyApp(
      isDark : isDark,
    ));

    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool? isDark;
     MyApp({
    this.isDark
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:
      [
        BlocProvider(create: (BuildContext context)=> AppCubit()..changeAppMode(fromShared: isDark)),
      ],
      child: BlocConsumer< AppCubit, AppStates>(
        listener: (context,state)
        {},
        builder: (context,state)
        {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark? ThemeMode.dark : ThemeMode.light,
            home: HomeLayout(),
          );
        },
      ),

    );
  }
}
