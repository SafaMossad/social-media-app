import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/layout/shop_app/cubit/cubit.dart';
import 'package:socialmediaapp/layout/shop_app/cubit/states.dart';
import 'package:socialmediaapp/models/models_shop_app/categories_model.dart';
import 'package:socialmediaapp/shared/components/components.dart';


class CategoriesScreen extends StatelessWidget {
  Widget buildCatItem(DataModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image),
              height: 80.0,
              width: 80.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              model.name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) => ListView.separated(
            itemBuilder: (context, index) => buildCatItem(
                ShopCubit.get(context).categoriesModel.data.data[index]),
            separatorBuilder: (context, index) => myDivider(),
            itemCount:
                ShopCubit.get(context).categoriesModel.data.data.length));
  }
}
