
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_snap/pages/Notification/notificationScreen.dart';
import 'package:photo_snap/pages/chat/chat_screen.dart';
import 'package:photo_snap/pages/settings/settings.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../add_photo/widgets/add_photo.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_states.dart';
import 'homeappbar.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  int notificationCount = 3;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<HomeBloc>().add(const FetchDataEvent(query: ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHight =MediaQuery.of(context).size.height;
    return  Scaffold(
      appBar:   PreferredSize(
        preferredSize: Size.fromHeight(screenHight*0.1),
        child: const HomeAppBar() ,

      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child:Center(child:Text('Welcome!!',style: TextStyle(color: Colors.black54,fontSize:36 ),
              ),)
            ),
            ListTile(
              title: const Text('Home',style: TextStyle(color: Colors.black54,fontSize:25 ),),
              leading:const Icon(Icons.home),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
            ),

            ListTile(
              title: const Text(' Upload Image',style: TextStyle(color: Colors.black54,fontSize:25 ),),
                leading:const Icon(Icons.cloud_upload),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPhoto()),
                );
              },
            ),
            _buildNotificationListTile(),
            ListTile(
              title: const Text('Settings',style: TextStyle(color: Colors.black54,fontSize:25 ),),
              leading:const Icon(Icons.settings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
            ListTile(
              title: const Text('About',style: TextStyle(color: Colors.black54,fontSize:25 ),),
              leading:const Icon(Icons.contact_support),
              onTap: () {
              },
            ),
            ListTile(
              title: const Text('Contact',style: TextStyle(color: Colors.black54,fontSize:25 ),),
              leading:const Icon(Icons.contact_mail),
              onTap: () {
              },
            ),
      ListTile(
        title: const Text('Chat',style: TextStyle(color: Colors.black54,fontSize:25 ),),
        leading:const Icon(Icons.chat_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
      ),
        ListTile(
              title: const Text('Close',style: TextStyle(color: Colors.black54,fontSize:25),),
              leading:const Icon(Icons.close),
              onTap: () {
                exit(0);
              },
            ),
          ],
        ),
      ),
      body:BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is LoadingState) {
              context.read<HomeBloc>().add(const FetchDataEvent(query: ''));
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ErrorState) {
              return Center(child: Text("Error: ${state.errorMessage}"));
            }
            if (state is DataLoadedState) {
              final currentPhotos = state.photos;

              if (currentPhotos.isEmpty) {
                return const Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('Add Image !!!', style: TextStyle(fontSize: 50)),
                    ),
                  ],
                );
              }
              return GridView.builder(
                itemCount: currentPhotos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  final photo =currentPhotos[index];
                  return InkWell(
                    onTap: () {
                      if (photo.location != null) {
                        _launchMaps(photo.location!);
                      }
                    },
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Scaffold(
                                        appBar: AppBar(
                                          backgroundColor:Colors.black,
                                          title: Text(photo.location ?? ''),
                                        ),
                                        body: Center(
                                          child: PhotoView(
                                            imageProvider: MemoryImage(
                                                base64Decode(
                                                    photo.photo_code!)),
                                            minScale: PhotoViewComputedScale
                                                .contained,
                                            maxScale: PhotoViewComputedScale
                                                .covered * 2,
                                          ),
                                        ),
                                      ),
                                ));
                              },
                              child: SizedBox(
                                width: 200, // Adjust width as needed
                                height: 200, // Adjust height as needed
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.memory(
                                      base64Decode(photo.photo_code!),
                                      fit: BoxFit.cover,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        color: Colors.black.withOpacity(0.5),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (photo.location != null) {
                                              _launchMaps(photo.location!);
                                            }
                                          },
                                          child: Text(
                                            photo.location ?? '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPhoto()),
          );
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),

    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _launchMaps(String location) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Widget _buildNotificationListTile() {
    return ListTile(
      title: const Text(
        'Notifications',
        style: TextStyle(color: Colors.black54, fontSize: 25),
      ),
      leading: Stack(
        children: [
          const Icon(Icons.notifications),
          if (notificationCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$notificationCount',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );
      },
    );
  }
}

