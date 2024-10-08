import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/models/ayat.dart';
import 'package:flutter_alquran/models/surah.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.noSurah});

  final int noSurah;
  Future<Surah> _getDetailSurah() async {
    var data = await Dio().get('https://equran.id/api/surat/$noSurah');
    // print(data);
    return Surah.fromJson(jsonDecode(data.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Surah>(
      initialData: null,
      future: _getDetailSurah(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: background,
          );
        }
        Surah surah = snapshot.data!;
        return Scaffold(
          appBar: _appbar(context: context, surah: surah),
          backgroundColor: background,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: _details(surah: surah),
              )
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: ListView.separated(
                 itemBuilder: (context, index) => _ayatItem(
                      ayat: surah.ayat!
                          .elementAt(index + (noSurah == 1 ? 1 : 0))),
                  itemCount: surah.jumlahAyat + (noSurah == 1 ? -1 : 0),
                  separatorBuilder: (context, index) => Container(),)
            ),
          ),
        );
      }),
    );
  }

  Widget _ayatItem({required Ayat ayat}) => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10
              ),
              decoration: BoxDecoration(
                  color: grey, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(27 / 2)),
                    child: Center(
                        child: Text(
                      '${ayat.nomor}',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    )),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  const Icon(
                    Icons.play_arrow_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  const Icon(
                    Icons.bookmark_outline,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            Text(
              ayat.ar,
              textAlign: TextAlign.end,
              style: GoogleFonts.amiri(
                color: white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Text(
              ayat.idn,
              style: GoogleFonts.amiri(
                color: white,
                fontSize: 16.0,
              ),
            )
          ],
        ),
      );

  Widget _details({required Surah surah}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          children: [
            Container(
              height: 257,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                    colors: [
                      Color(0xFFDF98FA),
                      Color(0xFFB070FD),
                      Color(0xFF9055FF)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0,
                      0.6,
                      1,
                    ]),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.2,
                child: SvgPicture.asset(
                  'assets/svgs/quran.svg',
                  width: 324 - 55,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    Text(
                      surah.namaLatin,
                      style: GoogleFonts.poppins(
                        fontSize: 26.0,
                        fontWeight: FontWeight.w500,
                        color: white,
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      surah.arti,
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: white,
                      ),
                    ),
                    Divider(
                      color: white.withOpacity(0.35),
                      height: 32,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          surah.tempatTurun.name,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${surah.jumlahAyat} Ayat",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SvgPicture.asset('assets/svgs/bismillah.svg')
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  AppBar _appbar({required BuildContext context, required Surah surah}) {
    return AppBar(
      backgroundColor: background,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset('assets/svgs/back-icon.svg'),
      ),
      title: Text(
        surah.namaLatin,
        style: GoogleFonts.poppins(color: white, fontWeight: FontWeight.w500),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/svgs/search-icon.svg'),
          ),
        )
      ],
    );
  }
}
