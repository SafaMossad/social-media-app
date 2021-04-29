import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../layout/shop_app/cubit/cubit.dart';
import '../../../../layout/shop_app/cubit/states.dart';
import '../../../../models/models_shop_app/categories_model.dart';
import '../../../../models/models_shop_app/home_model.dart';
import '../../../../shared/components/components.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status) {
            showToast(
              text: state.model.message,
              state: ToastState.ERROR,
            );
          }
          else{
            showToast(
              text: state.model.message,
              state: ToastState.SUCCESS,
            );
          }
        }
      },
      builder: (context, state) {
        {
          return ConditionalBuilder(
            condition: ShopCubit.get(context).homeModel != null &&
                ShopCubit.get(context).categoriesModel != null,
            builder: (context) => productsBuilder(
                ShopCubit.get(context).homeModel,
                ShopCubit.get(context).categoriesModel,
                context),
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget productsBuilder(
          HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                items: model.data.banners
                    .map((e) => Image(
                          image: NetworkImage(e.image),
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ))
                    .toList(),
                options: CarouselOptions(
                  height: 250,
                  // aspectRatio: 16/9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 6),
                  autoPlayAnimationDuration: Duration(seconds: 3),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  //onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                )),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 100.0,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        //shrinkWrap: true,
                        itemBuilder: (context, index) => buildCategoriesItems(
                            categoriesModel.data.data[index]),
                        separatorBuilder: (context, index) => SizedBox(
                              width: 20.0,
                            ),
                        itemCount: categoriesModel.data.data.length),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "New Products",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey[300],
              padding: EdgeInsets.all(6.0),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1 / 1.72,
                children: List.generate(model.data.products.length, (index) => buildGridProduct(model.data.products[index], context)),
              ),
            ),
          ],
        ),
      );

  Widget buildGridProduct(ProductModel model, context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image),
                  fit: BoxFit.scaleDown,
                  height: 200,
                ),
                if (model.discount != 0)
                  Container(
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "DISCOUNT",
                      style: TextStyle(fontSize: 8.0, color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(17.0),
            child: Column(
              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.0, height: 1.3),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${model.price.round()}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    if (model.discount != 0)
                      Text(
                        "${model.oldPrice.round()}",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: ShopCubit.get(context).favorites[model.id]
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      radius: 15.0,
                      child: IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 14.0,
                          ),
                          onPressed: () {
                            print(model.id);
                            ShopCubit.get(context).changeFavorites(model.id);
                          }),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCategoriesItems(DataModel model) => Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          height: 100.0,
          width: 100.0,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Image(
                image: NetworkImage(
                  model.image,
                ),
                fit: BoxFit.cover,
              ),
              Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.8),
                child: Text(
                  model.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              )
            ],
          ),
        ),
      );
}
