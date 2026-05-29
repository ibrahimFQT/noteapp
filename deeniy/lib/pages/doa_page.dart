import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() =>
      _DoaPageState();
}

class _DoaPageState
    extends State<DoaPage> {

  late Box box;

  final TextEditingController
      searchController =
          TextEditingController();

  String searchText = '';

  final Map<String,
    List<Map<String, String>>>
    doaCategories = {

  'Makan & Minum': [

    {
      'title':
          'Doa Sebelum Makan',

      'arab':
          'بِسْمِ اللهِ',

      'latin':
          'Bismillah',

      'meaning':
          'Dengan nama Allah.',
    },

    {
      'title':
          'Doa Sesudah Makan',

      'arab':
          'الْحَمْدُ لِلَّهِ',

      'latin':
          'Alhamdulillah',

      'meaning':
          'Segala puji bagi Allah.',
    },
  ],

  'Tidur': [

    {
      'title':
          'Doa Sebelum Tidur',

      'arab':
          'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',

      'latin':
          'Bismika Allahumma ahyaa wa amuut',

      'meaning':
          'Dengan nama-Mu ya Allah aku hidup dan aku mati.',
    },

    {
      'title':
          'Doa Bangun Tidur',

      'arab':
          'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',

      'latin':
          'Alhamdulillahil ladzi ahyana bada ma amatana wa ilaihin nusyur',

      'meaning':
          'Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami dan kepada-Nya kami dibangkitkan.',
    },
  ],

  'Rumah': [

    {
      'title':
          'Doa Keluar Rumah',

      'arab':
          'بِسْمِ اللهِ تَوَكَّلْتُ عَلَى اللهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',

      'latin':
          'Bismillahi tawakkaltu alallah la haula wa la quwwata illa بالله',

      'meaning':
          'Dengan nama Allah, aku bertawakal kepada Allah. Tidak ada daya dan kekuatan kecuali dengan pertolongan Allah.',
    },

    {
      'title':
          'Doa Masuk Rumah',

      'arab':
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلِجِ وَخَيْرَ الْمَخْرَجِ',

      'latin':
          'Allahumma inni as aluka khairal mauliji wa khairal makhroji',

      'meaning':
          'Ya Allah aku memohon kebaikan ketika masuk dan keluar rumah.',
    },
  ],

  'Masjid': [

    {
      'title':
          'Doa Masuk Masjid',

      'arab':
          'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',

      'latin':
          'Allahummaf tahli abwaba rahmatik',

      'meaning':
          'Ya Allah bukakanlah pintu rahmat-Mu untukku.',
    },

    {
      'title':
          'Doa Keluar Masjid',

      'arab':
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',

      'latin':
          'Allahumma inni as aluka min fadhlik',

      'meaning':
          'Ya Allah aku memohon karunia-Mu.',
    },
  ],

  'Perjalanan': [

    {
      'title':
          'Doa Naik Kendaraan',

      'arab':
          'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',

      'latin':
          'Subhanalladzi sakhkhoro lana hadza wa ma kunna lahu muqrinin wa inna ila rabbina lamunqalibun',

      'meaning':
          'Maha suci Allah yang telah menundukkan kendaraan ini untuk kami padahal kami sebelumnya tidak mampu menguasainya.',
    },

    {
      'title':
          'Doa Safar',

      'arab':
          'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى',

      'latin':
          'Allahumma inna nas aluka fii safarina hadzal birra wat taqwa',

      'meaning':
          'Ya Allah kami memohon kebaikan dan ketakwaan dalam perjalanan ini.',
    },
  ],

  'Belajar': [

    {
      'title':
          'Doa Memohon Ilmu',

      'arab':
          'رَبِّ زِدْنِي عِلْمًا',

      'latin':
          'Rabbi zidni ilma',

      'meaning':
          'Ya Rabbku tambahkanlah ilmuku.',
    },

    {
      'title':
          'Doa Sebelum Belajar',

      'arab':
          'اللَّهُمَّ انْفَعْنِي بِمَا عَلَّمْتَنِي',

      'latin':
          'Allahumma anfa’ni bima allamtani',

      'meaning':
          'Ya Allah berikan manfaat atas ilmu yang Engkau ajarkan kepadaku.',
    },

    {
      'title':
          'Doa Sesudah Belajar',

      'arab':
          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',

      'latin':
          'Alhamdulillahi rabbil alamin',

      'meaning':
          'Segala puji bagi Allah Tuhan seluruh alam.',
    },
  ],

  'Kamar Mandi': [

    {
      'title':
          'Doa Masuk Kamar Mandi',

      'arab':
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',

      'latin':
          'Allahumma inni a’udzu bika minal khubutsi wal khabaa its',

      'meaning':
          'Ya Allah aku berlindung kepada-Mu dari setan laki-laki dan perempuan.',
    },

    {
      'title':
          'Doa Keluar Kamar Mandi',

      'arab':
          'غُفْرَانَكَ',

      'latin':
          'Ghufranak',

      'meaning':
          'Aku memohon ampun kepada-Mu.',
    },
  ],

  'Sholat': [

    {
      'title':
          'Doa Iftitah',

      'arab':
          'اللَّهُ أَكْبَرُ كَبِيرًا وَالْحَمْدُ لِلَّهِ كَثِيرًا',

      'latin':
          'Allahu akbaru kabira walhamdulillahi katsira',

      'meaning':
          'Allah Maha Besar sebesar-besarnya dan segala puji bagi Allah sebanyak-banyaknya.',
    },

    {
      'title':
          'Doa Sujud',

      'arab':
          'سُبْحَانَ رَبِّيَ الأَعْلَى',

      'latin':
          'Subhana rabbiyal a’la',

      'meaning':
          'Maha suci Tuhanku Yang Maha Tinggi.',
    },

    {
      'title':
          'Doa Duduk Diantara Dua Sujud',

      'arab':
          'رَبِّ اغْفِرْ لِي وَارْحَمْنِي',

      'latin':
          'Rabbighfirli warhamni',

      'meaning':
          'Ya Rabbku ampunilah aku dan rahmatilah aku.',
    },
  ],

  'Wudhu': [

    {
      'title':
          'Doa Sebelum Wudhu',

      'arab':
          'بِسْمِ اللهِ',

      'latin':
          'Bismillah',

      'meaning':
          'Dengan nama Allah.',
    },

    {
      'title':
          'Doa Sesudah Wudhu',

      'arab':
          'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ',

      'latin':
          'Asyhadu alla ilaha illallah wahdahu la syarikalah',

      'meaning':
          'Aku bersaksi bahwa tidak ada Tuhan selain Allah semata.',
    },
  ],
};

  @override
  void initState() {
    super.initState();

    box = Hive.box(
      'deeniyBox',
    );

    if (box.get('favorites') ==
        null) {

      box.put(
        'favorites',
        [],
      );
    }
  }

  List get favorites {

    return box.get(
      'favorites',
    );
  }

  void toggleFavorite(
    String title,
  ) {

    List favs = favorites;

    if (favs.contains(title)) {

      favs.remove(title);

    } else {

      favs.add(title);
    }

    box.put(
      'favorites',
      favs,
    );

    setState(() {});
  }

  void openFavoritePage() {

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) =>
            FavoritePage(
          favorites:
              favorites,
          doaCategories:
              doaCategories,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(
        child:
            SingleChildScrollView(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              buildHeader(),

              const SizedBox(
                height: 30,
              ),

              buildSearchField(),

              const SizedBox(
                height: 30,
              ),

              buildHeroCard(),

              const SizedBox(
                height: 35,
              ),

              Column(

                children:
                    doaCategories.entries.map(
                  (category) {

                    final filteredDoa =
                        category.value.where(
                      (doa) {

                        return doa['title']!
                            .toLowerCase()
                            .contains(
                              searchText
                                  .toLowerCase(),
                            );
                      },
                    ).toList();

                    if (filteredDoa
                        .isEmpty) {

                      return const SizedBox();
                    }

                    return Container(

                      margin:
                          const EdgeInsets.only(
                        bottom: 20,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          28,
                        ),
                      ),

                      child:
                          ExpansionTile(

                        tilePadding:
                            const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),

                        childrenPadding:
                            const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),

                        title: Text(
                          category.key,

                          style:
                              const TextStyle(
                            fontSize: 21,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          '${filteredDoa.length} doa',
                        ),

                        children:
                            filteredDoa.map(
                          (doa) {

                            return buildDoaCard(
                              doa,
                            );
                          },
                        ).toList(),
                      ),
                    );
                  },
                ).toList(),
              ),

              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              'Doa Harian',

              style: TextStyle(
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,

                color:
                    Color(0xFF1F4E45),
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Daily muslim prayers',

              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        GestureDetector(
          onTap: openFavoritePage,

          child: Container(
            padding:
                const EdgeInsets.all(
              14,
            ),

            decoration:
                BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            child: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSearchField() {

    return TextField(

      controller:
          searchController,

      onChanged: (value) {

        setState(() {

          searchText = value;
        });
      },

      decoration:
          InputDecoration(

        hintText:
            'Cari doa...',

        prefixIcon:
            const Icon(
          Icons.search,
        ),

        filled: true,

        fillColor: Colors.white,

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            22,
          ),

          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  Widget buildHeroCard() {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(
        28,
      ),

      decoration:
          BoxDecoration(

        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF1F4E45),
            Color(0xFF2D6A5D),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          32,
        ),
      ),

      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            'DEENIY',

            style: TextStyle(
              color: Colors.white70,
              letterSpacing: 2,
            ),
          ),

          SizedBox(height: 18),

          Text(
            'Temukan doa berdasarkan aktivitas harianmu.',

            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              height: 1.4,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDoaCard(
    Map<String, String> doa,
  ) {

    final isFavorite =
        favorites.contains(
      doa['title'],
    );

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),

      padding:
          const EdgeInsets.all(
        24,
      ),

      decoration:
          BoxDecoration(

        color:
            const Color(0xFFF8F8F8),

        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Expanded(
                child: Text(
                  doa['title']!,

                  style:
                      const TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {

                  toggleFavorite(
                    doa['title']!,
                  );
                },

                child: Icon(

                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,

                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 24,
          ),

          Align(
            alignment:
                Alignment.centerRight,

            child: Text(
              doa['arab']!,

              textAlign:
                  TextAlign.right,

              style:
                  const TextStyle(
                fontSize: 30,
                height: 2,
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Text(
            doa['latin']!,

            style:
                const TextStyle(
              fontSize: 16,
              fontStyle:
                  FontStyle.italic,

              color: Colors.black54,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            doa['meaning']!,

            style:
                const TextStyle(
              fontSize: 16,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritePage
    extends StatelessWidget {

  final List favorites;

  final Map<String,
      List<Map<String, String>>>
      doaCategories;

  const FavoritePage({
    super.key,
    required this.favorites,
    required this.doaCategories,
  });

  @override
  Widget build(BuildContext context) {

    final allDoa =
        doaCategories.values
            .expand(
              (e) => e,
            )
            .toList();

    final favoriteDoa =
        allDoa.where((doa) {

      return favorites.contains(
        doa['title'],
      );
    }).toList();

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F1E8),

      appBar: AppBar(
        title:
            const Text(
          'Doa Favorit',
        ),
      ),

      body: ListView.builder(

        padding:
            const EdgeInsets.all(
          20,
        ),

        itemCount:
            favoriteDoa.length,

        itemBuilder:
            (context, index) {

          final doa =
              favoriteDoa[index];

          return Container(

            margin:
                const EdgeInsets.only(
              bottom: 18,
            ),

            padding:
                const EdgeInsets.all(
              22,
            ),

            decoration:
                BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                24,
              ),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  doa['title']!,

                  style:
                      const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Align(
                  alignment:
                      Alignment.centerRight,

                  child: Text(
                    doa['arab']!,

                    textAlign:
                        TextAlign.right,

                    style:
                        const TextStyle(
                      fontSize: 28,
                      height: 1.8,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}