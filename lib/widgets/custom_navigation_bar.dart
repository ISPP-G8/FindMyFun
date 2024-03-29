import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: BottomNavigationBar(
          onTap: (i) {
            final pageController =
                Provider.of<PageViewService>(context, listen: false);
            pageController.mainPageController.jumpToPage(i);

            _selectedPage = i;

            setState(() {});
          },
          currentIndex: _selectedPage,
          backgroundColor: ProjectColors.tertiary,
          items: const [
            BottomNavigationBarItem(
                backgroundColor: ProjectColors.tertiary,
                icon: Icon(
                  Icons.home_outlined,
                  size: 50,
                  color: Colors.white,
                ),
                label: 'Inicio'),
            BottomNavigationBarItem(
                backgroundColor: ProjectColors.tertiary,
                icon: Icon(
                  Icons.recommend,
                  size: 50,
                  color: Colors.white,
                ),
                label: 'Recomendados'),
            BottomNavigationBarItem(
                backgroundColor: ProjectColors.tertiary,
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 50,
                  color: Colors.white,
                ),
                label: 'Crear'),
            BottomNavigationBarItem(
                backgroundColor: ProjectColors.tertiary,
                icon: Icon(
                  Icons.search_outlined,
                  size: 50,
                  color: Colors.white,
                ),
                label: 'Buscar'),
            // BottomNavigationBarItem(
            //     backgroundColor: ProjectColors.tertiary,
            //     icon: Icon(
            //       Icons.notifications,
            //       size: 50,
            //       color: Colors.white,
            //     ),
            //     label: 'Notificaciones'),
            BottomNavigationBarItem(
                backgroundColor: ProjectColors.tertiary,
                icon: Icon(
                  Icons.account_circle,

                  size: 50,
                  color: Colors.white,
                ),
                label: 'Perfil'
            ),
        //     Visibility(
        //       visible: (user.isAdmin || user.isCompany) ?? false,
        //       child: BottomNavigationBarItem(
        //           backgroundColor: ProjectColors.tertiary,
        //           icon: Icon(
        //             Icons.settings,
        //             size: 50,
        //             color: Colors.white,
        //           ),
        //           label: 'Ajustes'),
        // ),
          ]),
    );
  }

  // Widget footerItem({required IconData icon, required String name}) {
  //   return GestureDetector(
  //     onTap: () {
  //       selectedItem = 1;
  //       setState(() {});
  //     },
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(
  //           icon,
  //           size: selectedItem == 1 ? 60 : 50,
  //           color: Colors.white,
  //         ),
  //         if (name.isNotEmpty)
  //           Text(
  //             name,
  //             style: TextStyle(color: Colors.white),
  //           )
  //       ],
  //     ),
  //   );
  // }
}
