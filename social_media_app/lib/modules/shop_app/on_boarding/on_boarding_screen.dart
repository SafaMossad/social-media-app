import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../modules/shop_app/on_boarding/login/login_screen.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel(
      {@required this.image, @required this.title, @required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var pageController = PageController();
  bool isLast = false;
  List<BoardingModel> boarding = [
    BoardingModel(
        image: "assets/images/Lawyer-amico.png",
        title: "on Board 1 Title",
        body: "on Board 1 Body"),
    BoardingModel(
        image: "assets/images/Lawyer-amico.png",
        title: "on Board 2 Title",
        body: "on Board 2 Body"),
    BoardingModel(
        image: "assets/images/Lawyer-amico.png",
        title: "on Board 3 Title",
        body: "on Board 3 Body"),
  ];

  void submit() {
    CacheHelper.saveData(key: "onBoarding", value: true).then((value) => {
          if (value)
            {
              {
                navigateAndFinish(context, ShopLoginScreen()),
              }
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            defaultTextButton(
              function: submit,
              text: "skip",
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (int index) {
                    if (index == boarding.length - 1) {
                      setState(() {
                        isLast = true;
                        print("last");
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                      print("not last");
                    }
                  },
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildBoardingItem(boarding[index]),
                  itemCount: boarding.length,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: boarding.length,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Theme.of(context).primaryColor,
                      dotHeight: 10.0,
                      //for when swiping moving
                      expansionFactor: 4,
                      dotWidth: 10.0,
                      spacing: 5.0,
                    ),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        submit();
                      } else {
                        pageController.nextPage(
                            duration: Duration(
                              milliseconds: 750,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Image(image: AssetImage("${model.image}"))),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "${model.title}",
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "${model.body}",
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
        ],
      );
}
