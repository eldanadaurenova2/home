import 'package:flutter/material.dart';
import '../data/hotels.dart';
import '../models/hotel.dart';
import 'hotel_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> defaultCities = ['Astana', 'Almaty', 'Shymkent'];
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  String sortOption = 'По умолчанию';

  final List<String> sortOptions = [
    'По умолчанию',
    'По алфавиту (A–Z)',
    'По городу (Almaty → Shymkent → Astana)',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Поиск отеля',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        ),
        const SizedBox(height: 12),

       
        DropdownButton<String>(
          value: sortOption,
          isExpanded: true,
          items: sortOptions.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              sortOption = newValue!;
            });
          },
        ),
        const SizedBox(height: 16),

       
        ..._getSortedCities().map((city) {
          final List<Hotel> cityHotels = allHotels
              .where((hotel) =>
                  hotel.city.toLowerCase() == city.toLowerCase() &&
                  hotel.name.toLowerCase().contains(searchQuery))
              .toList();

          if (sortOption == 'По алфавиту (A–Z)') {
            cityHotels.sort((a, b) => a.name.compareTo(b.name));
          }

          if (cityHotels.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(city, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 9),
              SizedBox(
                height: 350,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cityHotels.length,
                  itemBuilder: (context, index) {
                    final hotel = cityHotels[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HotelDetailPage(hotel: hotel),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                hotel.imagePath,
                                height: 270,
                                width: 250,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(hotel.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ],
    );
  }


  List<String> _getSortedCities() {
    if (sortOption == 'По городу (Almaty → Shymkent → Astana)') {
      return ['Almaty', 'Shymkent', 'Astana'];
    }
    return defaultCities;
  }
}
