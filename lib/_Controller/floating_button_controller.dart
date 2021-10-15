import 'package:get/get.dart';

class FloatingButtonController extends GetxController {
  var isFilterActive = false.obs;
  var isAddActive = false.obs;

  filterBtnOnClick() {
    isFilterActive.value
        ? isFilterActive.value = false
        : isFilterActive.value = true;
    isAddActive.value = false;
  }

  addBtnOnClick() {
    isAddActive.value ? isAddActive.value = false : isAddActive.value = true;
    isFilterActive.value = false;
  }

  allBtnCancel() {
    isFilterActive.value = false;
    isAddActive.value = false;
  }
}
