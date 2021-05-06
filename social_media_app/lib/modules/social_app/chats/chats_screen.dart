import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/layout/social_app/cubit/cubit.dart';
import 'package:socialmediaapp/layout/social_app/cubit/states.dart';
import 'package:socialmediaapp/models/social_app/social_user_model.dart';
import 'package:socialmediaapp/modules/social_app/chat_details/chat_details_screen.dart';
import 'package:socialmediaapp/shared/components/components.dart';
import 'package:socialmediaapp/shared/styles/colors.dart';

class ChatsScreen extends StatelessWidget {
  Widget buildChatItem(context, SocialUserModel model) {
    return InkWell(
      onTap: () {
        navigateTo(context, ChatDetailsScreen(
          userModel: model,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage('${model.image}'),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${model.name}',
                        style: TextStyle(
                          height: 1.4,
                        ),
                      ),
                      /*   SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.check_circle,
                        color: defaultColor,
                        size: 16.0,
                      ),*/
                    ],
                  ),
                  /*   Text(
                    '20-11-2002',
                    style: Theme.of(context).textTheme.caption.copyWith(
                          height: 1.4,
                        ),
                  ),*/
                ],
              ),
            ),
/*            SizedBox(
              width: 15.0,
            ),
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                size: 16.0,
              ),
              onPressed: () {},
            ),*/
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return buildChatItem(
                  context, SocialCubit.get(context).users[index]);
            },
            separatorBuilder: (context, index) => myDivider(),
            itemCount: SocialCubit.get(context).users.length,
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
