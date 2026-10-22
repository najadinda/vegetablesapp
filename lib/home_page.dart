import 'package:flutter/material.dart';
import 'package:vegetablesapp/ui/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              elevation: 0,
              backgroundColor: background,
              title: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_o2VNRKgOVuwyDwQ86s17DtLBu-PtmfYPgEfSrD8soA&s=10',
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Naja!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none, color: primary),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: Badge(
                      label: const Text('2'),
                      backgroundColor: Colors.red,
                      child: Icon(Icons.shopping_cart_outlined, color: primary),
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: primary),
                            SizedBox(width: 4),
                            Text(
                              'Dikirim ke: Semarang, Jawa Tengah',
                              style: TextStyle(fontSize: 12, color: primary),
                            ),
                            Icon(Icons.keyboard_arrow_down, size: 16, color: primary),
                          ],
                        ),
                          SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 48,
                            decoration: BoxDecoration(
                              color: backsur,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
