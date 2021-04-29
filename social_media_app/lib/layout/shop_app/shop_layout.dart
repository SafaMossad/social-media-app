import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/shop_app/cubit/cubit.dart';
import '../../layout/shop_app/cubit/states.dart';
import '../../modules/shop_app/on_boarding/search/search_screen.dart';
import '../../shared/components/components.dart';

class ShopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) => {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Shop"),
              actions: [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      navigateTo(context, SearchScreen( ));
                    })
              ],
            ),
            body: cubit.bottomScreens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubit.changeBottom(index);
              },
              currentIndex: cubit.currentIndex,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.apps), label: "Categories"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: "favorite"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "settings"),
              ],
            ),
          );
        });
  }
}
