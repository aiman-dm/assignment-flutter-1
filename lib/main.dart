import 'package:flutter/material.dart';

//_________________
// Entry point
//_________________

void main() {
  runApp(const DreamCarApp());
}

//_________________
// Data model - one class to hold all car info
//_________________

class CarModel{
  final String name;
  final String brand;
  final String imagePath;
  final int topSpeed; //km/h
  final int horsepower; //hp
  final String description;
  final Color accentColor;

  const CarModel({
    required this.name,
    required this.brand,
    required this.imagePath,
    required this.topSpeed,
    required this.horsepower,
    required this.description,
    required this.accentColor,
  });
}

//_________________
// Car data list - add / edit cars here easily
//_________________

final List<CarModel> dreamCars = [
  CarModel(
    name: 'Supra MK5',
    brand: 'Toyota',
    imagePath: 'assets/supra.png',
    topSpeed: 250,
    horsepower: 387,
    description: 'The legendary GR Supra returns with a turbocharged inline-six, delivering'
                 ' razor-sharp handeling and an iconic silhouette that defines sports car culture.',
    accentColor: const Color(0xFFE53935),
  ),
  CarModel(
    name: 'GT-R R35',
    brand: 'Nissan',
    imagePath: 'assets/gtr.png',
    topSpeed: 315,
    horsepower: 570,
    description: 'Godzilla lives up to its name - AWD, twin-turbo V6, and launch control,'
                 ' that denmolishes the 0-100 sprint in under 3 seconds.',
    accentColor: const Color(0xFF29B6F6),
  ),
  CarModel(
    name: 'Aventador LP 780',
    brand: 'Lamborghini',
    imagePath: 'assets/lamborghini.png',
    topSpeed: 350,
    horsepower: 780,
    description: 'A naturally-aspirated 6.5L V12 screaming to 8,700 RPM,'
                 ' Every drive is a theatrical event - sharp edges, dramatic scissor doors'
                 ' and a soundtrack you will never forget.',
    accentColor: const Color(0xFFFFD600),
  ),
  CarModel(
    name: '911 GT3 RS',
    brand: 'Porsche',
    imagePath: 'assets/porsche.png',
    topSpeed: 296,
    horsepower: 518,
    description: 'Motosport DNA distilled into a road car. The flay-six revs freely'
                 'to 9,000e and active aero keeps you planted on any twisty road.',
    accentColor: const Color(0xFF66BB6A),
  ),
  CarModel(
    name: 'SF90 Stradale',
    brand: 'Ferrari',
    imagePath: 'assets/ferrari.png',
    topSpeed: 340,
    horsepower: 1000,
    description: 'Ferrari\'s first series production PHEV packs a twin-turbo V8 and three'
                 'electric motors for a combined 1,000 hp.- Maranello\'s most powerful road car ever',
    accentColor: const Color(0xFFEF5350),
  ),
];

//_________________
// Root app widget - sets up the dark theme
//_________________
class DreamCarApp extends StatelessWidget{
  const DreamCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Car Showcase',
      debugShowCheckedModeBanner: false,

      // Dark theme configuration
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE8C84B),
          secondary: const Color(0xFF13131A),
          onSurface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),

      //-RootScreen holds the bottom navigation
      home: const RootScreen(),
    );
  }
}

//_________________
//RootScreen - manages bottom nav bar tabs
//Tab 0 -> Showcase (car list)
//Tab 1 -> Profile (your original card)
//_________________

class RootScreen extends StatefulWidget{
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>{
  //Currenly selected tab index
  int _currentIndex = 0;

  //The two pages 
  final List<Widget> _pages = const [
    ShowcaseScreen(), //Tab 0 - car list
    ProfileScreen(), //Tab 1 - profile card (your original code)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // - Display the active page --
      body: _pages[_currentIndex],

      // Bottom navigation bar----
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF222230), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF13131A),
          selectedItemColor: const Color(0xFFE8C84B),
          unselectedItemColor: const Color(0xFF555566),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_rounded),
              label: 'Showcase',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

//_________________
//Tab 0- Dream Car Showcase screen
//_________________
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  // Tracks which cars are favourited (by index)
  final Set<int> _favourites = {};

  void _toggleFavourite(int index) {
    setState(() {
      _favourites.contains(index)
          ? _favourites.remove(index)
          : _favourites.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // app header
            _buildHeader(),

            // car card list
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _CarCard(
                    car: dreamCars[index],
                    isFavourite: _favourites.contains(index),
                    onFavouriteToggle: () => _toggleFavourite(index),
                  ),
                  childCount: dreamCars.length,
                ),
              ),
            ),
            //- Bottom padding so last card clear the nav bar-
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  //-Gradient header at the top of the list
  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF13131A), Color(0xFF0A0A0F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const[
                Icon(Icons.speed_rounded, color: Color(0xFFE8C84B), size: 16),
                SizedBox(width: 6),
                Text(
                  'CURATED COLLECTION',
                  style: TextStyle(
                    color: Color(0xFFE8c84B),
                    fontSize: 11,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Dream Car\nShowcase',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${dreamCars.length} legendary machines',
              style: const TextStyle(color: Color(0xFF888899), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

//_________________
// Individual Car Card Widget
//_________________
class _CarCard extends StatelessWidget {
  final CarModel car;
  final bool isFavourite;
  final VoidCallback onFavouriteToggle;

  _CarCard ({
    required this.car,
    required this.isFavourite,
    required this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF13131A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: car.accentColor.withOpacity(0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: car.accentColor.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopRow(),
                  const SizedBox(height: 4),
                  Text(
                    car.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStatsChips(),
                  const SizedBox(height: 12),
                  Text(
                    car.description,
                    style: const TextStyle(
                      color: Color(0XFF888899),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //car image with gradient overlay
  Widget _buildImageSection() {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.asset(
            car.imagePath,
            fit: BoxFit.cover,
            // Placeholder show if image file is missing during development
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF1C1C26),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car_rounded,
                        size:60, color: car.accentColor.withOpacity(0.4)),
                    const SizedBox(height: 8),
                    Text(
                      car.name,
                      style: TextStyle(
                        color: car.accentColor.withOpacity(0.6),
                        fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Fade-to-card gradient at the bottom of the image
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xFF13131A).withOpacity(0.85),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ),
        // speed badge pinned to top-right corner
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.65),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: car.accentColor.withOpacity(0.5), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.speed_rounded, color: car.accentColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  '${car.topSpeed} km/h',
                  style: TextStyle(
                    color: car.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //Brand pi;; + favourite button 
  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //brand label pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: car.accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            car.brand,
            style: TextStyle(
              color: car.accentColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        //animated favourite heart button
        GestureDetector(
          onTap: onFavouriteToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isFavourite 
                  ? car.accentColor.withOpacity(0.15)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFavourite
                 ? Icons.favorite_rounded
                 : Icons.favorite_border_rounded,
              color: isFavourite
                 ? const Color(0xFFE8C84B)
                 : const Color(0xFF555566),
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  //-HorseP=power+ top speed stat chips
  Widget _buildStatsChips(){
    return Row(
      children: [
        _StatChip(
          icon: Icons.bolt_rounded,
          label: '${car.horsepower} hp',
          color: car.accentColor),
        const SizedBox(width: 10),
        _StatChip(
          icon: Icons.speed_rounded,
          label: '${car.topSpeed} km/h',
          color: const Color(0xFF888899)),
      ],
    );
  }
}

//_________________
//Reusable stat chip Widget
//_________________
class _StatChip extends StatelessWidget{
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip(
    {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(label,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

//_________
//Tab 1 - profile screen
// your original profile card code, resryled
// to match the app's dark theme,
//_________
class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // section heading (mirrors Showcase style)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:[
                        Icon(Icons.person_rounded,
                          color: Color(0xFFE8C84B), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'ABOUT ME',
                          style: TextStyle(
                           color: Color(0xFFE8C84B),
                           fontSize: 11,
                           letterSpacing: 2.5,
                           fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF13131A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFFE8C84B).withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE8C84B).withOpacity(0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 28),


                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE8C84B), width: 2.5),
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/profile.png')
                        ),
                      ),
                      const SizedBox(height: 14),

                      // name
                      const Text(
                        'Aiman bin Mohd Hisham',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      //Dob & locatuon
                      const Text(
                        '15/03/2004  .  Malaysia',
                        style: TextStyle(color: Color(0xFF888899)),
                      ),

                      //divider
                      const Divider(
                        height: 30,
                        thickness: 1,
                        indent: 50,
                        endIndent: 50,
                        color: Color(0xFF2A2A38),
                      ),

                      // phone
                      ListTile(
                        leading: const Icon(Icons.phone_rounded,
                          color: Color(0xFFE8C84B)),
                        title: const Text(
                          '+60 17590 6800',
                          style: TextStyle(color: Colors.white),
                        ),
                        dense: true,
                      ),

                       // email
                      ListTile(
                        leading: const Icon(Icons.email_rounded,
                          color: Color(0xFFE8C84B)),
                        title: const Text(
                          'aimanmhisham9@gmail.com',
                          style: TextStyle(color: Colors.white),
                        ),
                        dense: true,
                      ),

                      // bio qoute
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 8, 24, 28),
                        child: Text(
                          '"Flutter development in the making. Passionate about'
                          'clean UI and modern best practice."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF888899),
                            fontSize: 13,
                             height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}