import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Dashboard(),
      initialBinding: InitialBindings(),
    );
  }
}

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}

class DashboardController extends GetxController
    with GetTickerProviderStateMixin {
  static DashboardController get to => Get.find();

  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int val) => _selectedIndex.value = val;

  final views = <Widget>[
    const Center(
      child: Text("Home"),
    ),
    const Center(
      child: Text("Other screen"),
    ),
    const Center(
      child: Text("Some other screen"),
    ),
    const Center(
      child: Text("Totally different screen"),
    ),
  ];

  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(
      length: views.length,
      vsync: this,
    );
    tabController.addListener(() {
      _selectedIndex.value = tabController.index;
    });
    ever(_selectedIndex, handleSelectedIndexChange);
    super.onInit();
  }

  void handleSelectedIndexChange(int index) {
    tabController.animateTo(index);
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => controller.selectedIndex = 2,
            icon: Icon(Icons.access_alarm),
          ),
          IconButton(
            onPressed: () => controller.selectedIndex = 3,
            icon: Icon(Icons.android),
          ),
        ],
      ),
      body: TabBarView(
        children: controller.views,
        controller: controller.tabController,
      ),
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItem(
                  icon: Icons.home,
                  title: "Home",
                  selected: controller.selectedIndex == 0,
                  onTap: () => controller.selectedIndex = 0,
                ),
                NavItem(
                  icon: Icons.account_box,
                  title: "Home",
                  selected: controller.selectedIndex == 1,
                  onTap: () => controller.selectedIndex = 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: selected ? Colors.black : Colors.grey,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
