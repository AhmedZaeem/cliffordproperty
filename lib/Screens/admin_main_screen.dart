import 'package:cliffordproperty/Helpers/Nav_Helper.dart';
import 'package:cliffordproperty/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen>
    with Nav_Helper {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Control Panel'),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () async => await _logout(auth),
                  icon: const Icon(Icons.logout)),
            ],
          ),
          body: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) => _items[index],
          ),
        );
      },
    );
  }

  List<Widget> get _items => [
        _buildItem(
          title: 'Categories',
          icon: Icons.category,
          //onTap: () => jump(context,  const CategoriesScreen()),
        ),
        _buildItem(
          title: 'Products',
          icon: Icons.production_quantity_limits,
          //onTap: () => jump(context, to: const ProductsScreen()),
        ),
        _buildItem(
          title: 'Orders',
          icon: Icons.monetization_on,
          onTap: () {
            ///
          },
        ),
        _buildItem(
          title: 'Slider',
          icon: Icons.slideshow_rounded,
         // onTap: () => jump(context, to: const SlidersScreen()),
        ),
      ];

  Widget _buildItem({
    required String title,
    required IconData icon,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 70.h,
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(AuthProvider auth) async {
    try {
      auth.logout;
    } catch (e) {
      ///
    }

   // RestartApp.restartApp(context);
  }
}
