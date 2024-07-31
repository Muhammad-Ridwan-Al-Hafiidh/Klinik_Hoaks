import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailArtikel extends StatefulWidget {
  const DetailArtikel({super.key});

  @override
  State<DetailArtikel> createState() => _DetailArtikelState();
}

class _DetailArtikelState extends State<DetailArtikel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Color.fromRGBO(0, 131, 116, 1.000),
              expandedHeight: 300,
              stretch: true,
              onStretchTrigger: () {
                print('trigger');
                return Future.value(); // Return a completed Future
              },
              stretchTriggerOffset: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Judul Artikel',
                  style: GoogleFonts.inconsolata(fontWeight: FontWeight.w600),
                ),
                centerTitle: true,
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                  StretchMode.blurBackground,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/hero1.png',
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.5),
                          end: Alignment(0.0, 0.0),
                          colors: <Color>[
                            Color(0x60000000),
                            Color(0x00000000),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                 Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 5,
              colors: [Color.fromRGBO(0, 131, 116, 1.000), Color.fromRGBO(0, 131, 116, 1.000), Colors.grey],
              stops: const [0, 0.4, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Fakta atau Hoaks',
                style: GoogleFonts.inconsolata(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Link Rujukan',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),    
              ),
              Text(
                'https://www.bca.co.id/id/informasi/awas-modus/2023/08/21/07/22/modus-penipuan-baru-menggunakan-action-button-view-atau-button-lainnya-di-whatsapp',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                
              ),
            ],
          ),
        )
              ]),
            )
          ],
        ),
      );
  }
}