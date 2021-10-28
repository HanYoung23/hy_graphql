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

  //////////////////////////////////////////

  var category = 0.obs;
  var dateStart = "2021.01.01".obs;
  var dateEnd = "3021.09.23".obs;

  categoryUpdate(int categoryId) {
    category.value = categoryId;
  }

  dateUpdate(String startDate, String endDate) {
    dateStart.value = startDate;
    dateEnd.value = endDate;
  }
}
