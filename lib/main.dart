import 'package:flutter/material.dart';
void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kart Eşleştirme',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const OyunEkrani(),
    );
  }
}
class OyunEkrani extends StatefulWidget{
  const OyunEkrani({super.key});
  @override
  State<OyunEkrani>createState() => OyunEkraniState();
  }

class OyunEkraniState extends State<OyunEkrani>{
  int skor = 0;
  int hamle = 0;
  int kartsayisi = 12;
  List<int> acilankartlar = []; // açılan iki kartın indexi
  bool kontrolediliyor = false;
  List<String> emojiler = [
    '🐶', '🐱', '🦊', '🐼', '🐸',
    '🦁', '🐵', '🐰', '🐯', '🐨'
  ];
  List<String> kartlar = [];
  List<bool> acikkartlar=[]; //hangi kartların açık olduğu
  List<bool>eslesenkartlar=[];
  void kartolustur(){
    kartlar=[];
    for(int i=0;i<kartsayisi~/2;i++){
      kartlar.add(emojiler[i]);
      kartlar.add(emojiler[i]);
    }
    kartlar.shuffle();
    acikkartlar = List.filled(kartsayisi, false);
    eslesenkartlar = List.filled(kartsayisi, false);
  }
  void kontrolet() async{
    kontrolediliyor = true;
    int birinci = acilankartlar[0];
    int ikinci = acilankartlar[1];
    if(kartlar[birinci]==kartlar[ikinci]){
      setState(() {
        eslesenkartlar[birinci]=true;
        eslesenkartlar[ikinci]=true;
        skor++;
      });
    }else{
      await Future.delayed(const Duration(seconds: 1));
      if(!mounted) return; //oyun ekranının açık olup olmadığını kontrol etti
      setState(() {
        acikkartlar[birinci]=false;
        acikkartlar[ikinci]=false;
      });
    }
    if(eslesenkartlar.every((kart)=>kart == true)){
  ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Tebrikler! Bütün kartlar eşlesti.'),
    ),
  );
    }
    setState(() {
      acilankartlar.clear();
      kontrolediliyor = false;
    });
  }
  @override
  void initState(){
    super.initState();
    kartolustur();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kart Eşleştirme Oyunu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Card(
                  child: Padding(padding:
                  const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Text('Skor'),
                        Text(
                          '$skor',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
                Expanded(child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Text('Hamle'),
                        Text('$hamle', style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Zorluk Seçimi',
                style: TextStyle(fontSize: 16),
              ),
            ),
            DropdownButton<int>(
              value: kartsayisi,
              isExpanded: true,
              items: const[
                DropdownMenuItem(
                  value: 12,
                  child: Text('Kolay - 12 Kart'),
                ),
                DropdownMenuItem(
                  value: 16,
                  child: Text('Orta - 16 Kart'),
                ),
                DropdownMenuItem(
                  value: 20,
                  child: Text('Zor - 20 Kart'),
                ),
              ],
              onChanged: (yenideger) {
                setState(() {
                  kartsayisi = yenideger!;
                  skor =0;
                  hamle =0;
                  kartolustur();
                });
              },
            ),
           Expanded(
             child: GridView.builder(
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 4,
                     crossAxisSpacing: 8,
                     mainAxisSpacing: 8,
                     childAspectRatio: 1.1,
                 ),
                 itemCount: kartsayisi,
                 itemBuilder: (context, index){
                   return GestureDetector(
                     onTap: (){
                       if(kontrolediliyor ||
                       acikkartlar[index] ||
                       eslesenkartlar[index]){
                         return;
                       }
                       setState(() {
                         acikkartlar[index] = true;
                         acilankartlar.add(index);
                       });
                       if(acilankartlar.length == 2){
                         setState(() {
                           hamle++;
                         });
                         kontrolet();
                       }
                     },
                     child: Card(
                       color: eslesenkartlar[index]
                           ? Colors.grey.shade800
                           : Colors.deepPurple,
                       child: Center(
                         child: Text(
                           acikkartlar[index] || eslesenkartlar[index]
                               ?kartlar[index]
                               : '?',
                           style: const TextStyle(fontSize: 32),
                         ),
                       ),
                     ),
                   );
                 },
             ),
           ),
          ],
        ),
      ),
    );
  }
}