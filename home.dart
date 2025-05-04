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
  final List<String> cities = ['Astana', 'Almaty', 'Shymkent'];
  final TextEditingController _searchController = TextEditingController();
  String selectedCity = 'Astana';
  String searchQuery = '';
  String sortOption = 'A-Z';

  @override
  Widget build(BuildContext context) {
    List<Hotel> filteredHotels = allHotels.where((hotel) {
      return hotel.city == selectedCity &&
          hotel.name.toLowerCase().contains(searchQuery);
    }).toList();

    // Сортировка по алфавиту
    filteredHotels.sort((a, b) {
      return sortOption == 'A-Z'
          ? a.name.compareTo(b.name)
          : b.name.compareTo(a.name);
    });

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 🔽 Выбор города
        DropdownButtonFormField<String>(
          value: selectedCity,
          decoration: const InputDecoration(
            labelText: 'Выберите город',
            border: OutlineInputBorder(),
          ),
          items: cities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedCity = value;
              });
            }
          },
        ),
        const SizedBox(height: 16),

        // 🔍 Поиск
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
        const SizedBox(height: 16),

        // ↕️ Сортировка
        DropdownButtonFormField<String>(
          value: sortOption,
          decoration: const InputDecoration(
            labelText: 'Сортировка',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'A-Z', child: Text('A → Z')),
            DropdownMenuItem(value: 'Z-A', child: Text('Z → A')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                sortOption = value;
              });
            }
          },
        ),
        const SizedBox(height: 16),

        // 🏨 Отели
        Text(
          'Отели в $selectedCity',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 9),

        if (filteredHotels.isEmpty)
          const Text('Нет отелей по вашему запросу.'),
        if (filteredHotels.isNotEmpty)
          SizedBox(
            height: 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredHotels.length,
              itemBuilder: (context, index) {
                final hotel = filteredHotels[index];
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
      ],
    );
  }
}
