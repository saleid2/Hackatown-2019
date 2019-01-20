import "./DescriptionFilter.dart";

class ParkingDateManager{

  List _testInput =[
    "\A 06h30-09h30  16h-18h LUNDI AU VENDREDI",
    "\P 07h30-08h30 LUN. AU VEN. 1 AVRIL AU 1 DEC.",
    "\A 06h-09h LUN. AU VEN.",
    "\A 07h-09h30  16h-18h30 LUN. AU VEN.",
    "\A 15h30-18h LUN. AU VEN.",
    "\P 07h-09h MAR. ET VEN. 1er MARS AU 1er DEC."
  ];

  List _dayArray = ["LUN", "MAR", "MER", "JEU", "VEN", "SAM", "DIM"];

  Map _listOfDays = new Map();
  DescriptionFilter _descriptionFilter = new DescriptionFilter();

  bool _isParkingAvailable = true;

  ParkingDateManager(){}

  bool verifyDate(String description){
    init();
    findDate(DateTime.now(), description);

    return _isParkingAvailable;
  }

  void findDate(DateTime time, String description){

    String hourNow = time.hour.toString() + time.minute.toString();
    String dayOfWeekNow = time.weekday.toString();

    bool isParkingHourAvailable = true;
    bool isParkingSameDay = true;

    List listHours = new List();
    List recoveredDateFiltered = _descriptionFilter.filterInput(description);

    try {
      for (String item in recoveredDateFiltered) {
        if ((new RegExp(r'[0-9]+')).hasMatch(item)) {
          listHours.add(item);
        }
      }

      int indexOfFirstDay;
      for (int i = 0; i < recoveredDateFiltered.length; i++) {
        if (_dayArray.contains(recoveredDateFiltered[i])) {
          indexOfFirstDay = i;
          break;
        }
      }

      print(recoveredDateFiltered);
      isParkingHourAvailable = isBetweenHours(hourNow, listHours);
      if (recoveredDateFiltered.length > 1) {
        isParkingSameDay =
            isSameDate(dayOfWeekNow, indexOfFirstDay, recoveredDateFiltered);
      }
      print("the hour parking is available? " +
          isParkingHourAvailable.toString());
      print("the day same ? " + isParkingSameDay.toString());

      if (isParkingHourAvailable && !isParkingSameDay) {
        _isParkingAvailable = false;
      }
      print("illegal parking: " + _isParkingAvailable.toString());
    } on Exception catch(e){
      print("Do nothing when catch exception");
    }
  }

  bool isSameDate(String dayOfWeekNow, int index, List recoveredList){
    String firstDay = recoveredList[index++];
    String difference = "";
    if(recoveredList[index] == "AU" || recoveredList[index] == "ET" || recoveredList[index] == "A"){
      difference = recoveredList[index++];
    }
    String secondDay = recoveredList[index];

    int firstDayValue = _listOfDays[firstDay];
    int secondDayValue = _listOfDays[secondDay];

    if(difference == "ET" || difference == ""){
      return firstDayValue == int.parse(dayOfWeekNow) || secondDayValue == int.parse(dayOfWeekNow);
    }
    if(difference == "AU" || difference == "A"){
      return firstDayValue <= int.parse(dayOfWeekNow) && secondDayValue >= int.parse(dayOfWeekNow);
    }

    return false;
  }

  bool isBetweenHours(String hourNow, List hoursUnavailable){

    int convertedHourNow = int.parse(hourNow);

    List beginHours = new List();
    List endHours = new List();
    for(String hour in hoursUnavailable){
      if(hour.length == 8) {
        String startHour = hour.substring(0,4);
        String endHour = hour.substring(4,8);
        beginHours.add(int.parse(startHour));
        endHours.add(int.parse(endHour));
      }
    }
    for(int i = 0; i < beginHours.length; i++){
      if(beginHours[i] < endHours[i]) {
        if (beginHours[i] <= convertedHourNow && endHours[i] > convertedHourNow) {
          return false;
        }
      }else {
        if (beginHours[i] > convertedHourNow && endHours[i] >= convertedHourNow) {
          return false;
        }
      }
    }
    return true;
  }

  void init(){
    _listOfDays = new Map<String, int>();
    for(int i = 0; i < _dayArray.length; i++){
      _listOfDays[_dayArray[i]] = i + 1;
    }

    _isParkingAvailable = true;
  }

}