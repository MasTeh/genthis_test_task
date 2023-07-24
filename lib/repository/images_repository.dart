import 'package:flutter/material.dart';

abstract class ImagesRepository {
  Future<List<ImageProvider>> fetchWomanBad();
  Future<List<ImageProvider>> fetchWomanGood();
  Future<List<ImageProvider>> fetchManBad();
  Future<List<ImageProvider>> fetchManGood();
}

class DummyRepository implements ImagesRepository {
  @override
  Future<List<ImageProvider>> fetchWomanBad() async{
    return const [
      AssetImage("assets/woman-bad/00085-3559810726.png"),
      AssetImage("assets/woman-bad/00086-3559810727.png"),
      AssetImage("assets/woman-bad/00087-3559810728.png"),
      AssetImage("assets/woman-bad/00088-3559810729.png"),
      AssetImage("assets/woman-bad/00089-3559810730.png"),
      AssetImage("assets/woman-bad/00091-3559810732.png"),
      AssetImage("assets/woman-bad/00092-3559810733.png"),
      AssetImage("assets/woman-bad/00096-2430270104.png"),
    ];
  }
    
  @override
  Future<List<ImageProvider<Object>>> fetchManBad() async{
    return const [
      AssetImage("assets/man-bad/00051-4225152271.png"),
      AssetImage("assets/man-bad/00052-4225152272.png"),
      AssetImage("assets/man-bad/00054-4225152274.png"),
      AssetImage("assets/man-bad/00065-1237237229.png"),
      AssetImage("assets/man-bad/00066-1237237230.png"),
      AssetImage("assets/man-bad/00072-1237237236.png"),
      AssetImage("assets/man-bad/00075-3120522223.png"),
      AssetImage("assets/man-bad/00076-3120522224.png"),
      AssetImage("assets/man-bad/00077-3120522225.png"),
      AssetImage("assets/man-bad/00083-3120522231.png"),
    ];
  }

  @override
  Future<List<ImageProvider<Object>>> fetchManGood() async{
    return const [
      AssetImage("assets/man-good/00011-3378978445.png"),
      AssetImage("assets/man-good/00012-3378978446.png"),
      AssetImage("assets/man-good/00013-3378978447.png"),
      AssetImage("assets/man-good/00014-3378978448.png"),
      AssetImage("assets/man-good/00015-3378978449.png"),
      AssetImage("assets/man-good/00016-3378978450.png"),
      AssetImage("assets/man-good/00017-3378978451.png"),
      AssetImage("assets/man-good/00018-3378978452.png"),
      AssetImage("assets/man-good/00019-3378978453.png"),
      AssetImage("assets/man-good/00020-3378978454.png"),
    ];
  }

  @override
  Future<List<ImageProvider<Object>>> fetchWomanGood() async{
    return const [
      AssetImage("assets/woman-good/00107-365445646.png"),
      AssetImage("assets/woman-good/00111-365445650.png"),
      AssetImage("assets/woman-good/00135-1788044796.png"),
      AssetImage("assets/woman-good/00136-1788044797.png"),
      AssetImage("assets/woman-good/00137-1788044798.png"),
      AssetImage("assets/woman-good/00139-1788044800.png"),
      AssetImage("assets/woman-good/00140-1788044801.png"),
      AssetImage("assets/woman-good/00141-1788044802.png"),
      AssetImage("assets/woman-good/00144-1788044805.png"),
    ];
  }
}
