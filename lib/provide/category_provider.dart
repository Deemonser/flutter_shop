

import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {

  int tab_index = 0;


  changeTabIndex(index,){
    tab_index = index;
    notifyListeners();
  }

}