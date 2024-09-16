import 'package:flutter/material.dart';
import 'package:starbucks2/colors.dart';
import 'package:starbucks2/drinksCard.dart';
import 'package:starbucks2/drinks_screen.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa url_launcher

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  PageController? pageController;
  double pageOffset = 0;
  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animation = CurvedAnimation(parent: controller!, curve: Curves.easeOutBack);
    pageController = PageController(viewportFraction: 0.8, initialPage: 0);
    pageController?.addListener(() {
      setState(() {
        pageOffset = pageController?.page ?? 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildToolBar(),
            buildLogo(size),
            buildPager(size),
            buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  // Método para abrir Google Maps
  Future<void> _openMap() async {
    const url = 'https://maps.app.goo.gl/41U1MBfDabmQCzoa7';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  Widget buildToolBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: <Widget>[
          SizedBox(width: 20),
          AnimatedBuilder(
            animation: animation!,
            builder: (context, snapshot) {
              return Transform.translate(
                offset: Offset(-200 * (1 - animation!.value), 0),
                // Envuelve la imagen con InkWell para detectar toques
                child: InkWell(
                  onTap: _openMap, // Llama al método para abrir Google Maps al tocar
                  child: Image.asset(
                    "images/location.png",
                    width: 30,
                    height: 30,
                  ),
                ),
              );
            },
          ),
          Spacer(),
          AnimatedBuilder(
            animation: animation!,
            builder: (context, snapshot) {
              return Transform.translate(
                offset: Offset(200 * (1 - animation!.value), 0),
                child: Image.asset(
                  "images/drawer.png",
                  width: 30,
                  height: 30,
                ),
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget buildLogo(Size size) {
    return Positioned(
      top: 10,
      right: size.width / 2 - 25,
      child: AnimatedBuilder(
        animation: animation!,
        builder: (context, snapshot) {
          return Transform(
            transform: Matrix4.identity()
              ..translate(0.0, size.height / 2 * (1 - animation!.value))
              ..scale(1 + (1 - animation!.value)),
            origin: Offset(25, 25),
            child: InkWell(
              onTap: () => controller!.isCompleted ? controller!.reverse() : controller!.forward(),
              child: Image.asset("images/logo.png", width: 50, height: 50),
            ),
          );
        },
      ),
    );
  }

  Widget buildPager(Size size) {
    return Container(
      margin: EdgeInsets.only(top: 70),
      height: size.height - 50,
      child: AnimatedBuilder(
        animation: animation!,
        builder: (context, snapshot) {
          return Transform.translate(
            offset: Offset(400 * (1 - animation!.value), 0),
            child: PageView.builder(
              controller: pageController,
              itemCount: getDrinks().length,
              itemBuilder: (context, index) => DrinksCard(getDrinks()[index], pageOffset, index),
            ),
          );
        },
      ),
    );
  }

  List<DrinkScreen> getDrinks() {
    return [
      DrinkScreen(
        'iPhone',
        '15',
        'images/blur_image.png',
        'images/bean_top.png',
        'images/bean_small.png',
        'images/bean_blur.png',
        'images/cup.png',
        'Dispone de una pantalla Super Retina XDR de 6,1 pulgadas, el chip A15 Bionic, 5G',
        greenLight,
        greenDark,
      ),
      DrinkScreen(
        'iPhone',
        '14',
        'images/blur_image.png',
        'images/green_top.png',
        'images/green_small.png',
        'images/green_blur.png',
        'images/green_tea_cup.png',
        'Ofrece una pantalla Super Retina XDR de 6,1 pulgadas, el chip A15 Bionic, 5G',
        RedLight,
        Red,
      ),
      DrinkScreen(
        'iPhone',
        '13',
        'images/blur_image.png',
        'images/chocolate_top.png',
        'images/chocolate_small.png',
        'images/chocolate_blur.png',
        'images/mocha_cup.png',
        'Utiliza el chip A15 Bionic, 5G, una pantalla Super Retina XDR de 6,1 pulgadas',
        BlueLight,
        Blue,
      ),
    ];
  }

  Widget buildPageIndicator() {
    return AnimatedBuilder(
      animation: controller!,
      builder: (context, snapshot) {
        return Positioned(
          bottom: 10,
          left: 10,
          child: Opacity(
            opacity: controller!.value,
            child: Row(
              children: List.generate(getDrinks().length, (index) => buildContainer(index)),
            ),
          ),
        );
      },
    );
  }

  Widget buildContainer(int index) {
    double animate = (pageOffset - index).abs();
    double size = 10;
    Color color = Colors.grey;

    if (animate <= 1) {
      size = 10 + 10 * (1 - animate);
      color = ColorTween(begin: Colors.grey, end: mAppGreen).transform(1 - animate)!;
    }

    return Container(
      margin: EdgeInsets.all(4),
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    );
  }
}
