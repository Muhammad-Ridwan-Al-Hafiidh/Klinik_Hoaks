import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

class Rekap extends StatefulWidget {
  const Rekap({super.key});

  @override
  State<Rekap> createState() => _RekapState();
}

class _RekapState extends State<Rekap> with TickerProviderStateMixin {
  late AnimationController _controllerHoaks;
  late Animation<int> _animationHoaks;

  late AnimationController _controllerDisinformasi;
  late Animation<int> _animationDisinformasi;

  late AnimationController _controllerFakta;
  late Animation<int> _animationFakta;

  late AnimationController _controllerHateSpeech;
  late Animation<int> _animationHateSpeech;

  String selectedYear = '2024';

  @override
  void initState() {
    super.initState();

    _controllerHoaks = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationHoaks = IntTween(begin: 0, end: 1852).animate(_controllerHoaks);

    _controllerDisinformasi = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationDisinformasi =
        IntTween(begin: 0, end: 1037).animate(_controllerDisinformasi);

    _controllerFakta = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationFakta = IntTween(begin: 0, end: 822).animate(_controllerFakta);

    _controllerHateSpeech = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationHateSpeech =
        IntTween(begin: 0, end: 721).animate(_controllerHateSpeech);

    _controllerHoaks.forward();
    _controllerDisinformasi.forward();
    _controllerFakta.forward();
    _controllerHateSpeech.forward();
  }

  @override
  void dispose() {
    _controllerHoaks.dispose();
    _controllerDisinformasi.dispose();
    _controllerFakta.dispose();
    _controllerHateSpeech.dispose();
    super.dispose();
  }

  final List<String> years = [
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rekap Klarifikasi Informasi',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            children: [
              Card(
                elevation: 15,
                child: Container(
                    decoration: BoxDecoration(shape: BoxShape.rectangle),
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.2,
                    child: Image.asset(
                      'assets/rekap.png',
                      fit: BoxFit.fill,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  child: Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.1,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text('Pilih Tahun:',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: const Row(
                              children: [
                                Icon(
                                  Icons.list,
                                  size: 16,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    'Silahkan memilih tahun',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: years
                            .map((String years) => DropdownMenuItem<String>(
                                      value: years,
                                      child: Text(
                                        years,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                  selectedValue = value;
                                });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 300,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: Color.fromRGBO(0, 131, 116, 1.000),
                              ),
                              elevation: 2,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.yellow,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Color.fromRGBO(0, 131, 116, 1.000),
                              ),
                              offset: const Offset(-20, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all(6),
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 10,
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _animationHoaks,
                                builder: (context, child) {
                                  return Text(
                                    '${_animationHoaks.value}',
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(0, 131, 116, 1.000)),
                                  );
                                },
                              ),
                              Text(
                                'Hoaks',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _animationDisinformasi,
                                builder: (context, child) {
                                  return Text(
                                    '${_animationDisinformasi.value}',
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(0, 131, 116, 1.000)),
                                  );
                                },
                              ),
                              Text(
                                'Disinformasi',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 10,
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _animationFakta,
                                builder: (context, child) {
                                  return Text(
                                    '${_animationFakta.value}',
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(0, 131, 116, 1.000)),
                                  );
                                },
                              ),
                              Text(
                                'Fakta',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _animationHateSpeech,
                                builder: (context, child) {
                                  return Text(
                                    '${_animationHateSpeech.value}',
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(0, 131, 116, 1.000)),
                                  );
                                },
                              ),
                              Text(
                                'Hate Speech',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
