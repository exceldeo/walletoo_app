import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/view/screens/home_screen.dart';
import 'package:walletoo_app/view/screens/spending_screen.dart';
import 'package:walletoo_app/view/screens/wallet_screen.dart';

class StartUpScreen extends StatefulWidget {
  static const routeName = "/startUpScreen";
  StartUpScreen({Key? key}) : super(key: key);

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [HomeScreen(), SpendingScreen(), WalletScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home,
          size: 25,
        ),
        activeColorPrimary: ColorResources.COLOR_PRIMARY,
        inactiveColorPrimary: ColorResources.color_secondary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.attach_money,
          size: 25,
        ),
        activeColorPrimary: ColorResources.COLOR_PRIMARY,
        inactiveColorPrimary: ColorResources.color_secondary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.account_balance_wallet,
          size: 25,
        ),
        activeColorPrimary: ColorResources.COLOR_PRIMARY,
        inactiveColorPrimary: ColorResources.color_secondary,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        hideNavigationBar: false,
        popAllScreensOnTapOfSelectedTab: false,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        // This needs to be true if you want to move up the screen when keyboard appears.
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
        // decoration: NavBarDecoration(
        //   borderRadius: BorderRadius.circular(40.0),
        //   colorBehindNavBar: Colors.white,
        // ),
        //popAllScreensOnTapOfSelectedTab: false,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6,
        // Choose the nav bar style with this property.
        onItemSelected: (i) {},
      ),
    );
  }
}
