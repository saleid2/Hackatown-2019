import "./DescriptionFilter.dart";

class ParkingDateManager{

  List testInput =[
    "\A 06h30-09h30  16h-18h LUNDI AU VENDREDI",
    "\P 07h30-08h30 LUN. AU VEN. 1 AVRIL AU 1 DEC.",
    "\A 06h-09h LUN. AU VEN.",
    "\A 07h-09h30  16h-18h30 LUN. AU VEN.",
    "\A 15h30-18h LUN. AU VEN.",
    "\P 07h-09h MAR. ET VEN. 1er MARS AU 1er DEC."
  ];

  List dayArray = ["LUN", "MAR", "MER", "JEU", "VEN", "SAM", "DIM"];
  List monthArray = ["JAN", "FEB", "MARS", "AVRIL", "MAI", "JUIN", "JUIL", "AOUT", "SEPT", "OCT" ,"NOV", "DEC"];

  Map listOfDays = new Map();
  Map listOfMonths = new Map();

  DescriptionFilter descriptionFilter = new DescriptionFilter();

  ParkingDateManager(){}

  void verifyDate(){
    findDate(DateTime.now());
  }

  void findDate(DateTime time){

    var month = time.month;
    var day = time.day;
    var hour = time.hour;
    var minute = time.minute;
    var dayOfWeek = time.weekday;

    List recoveredDateFiltered = descriptionFilter.filterInput("\A 06h30-09h30  16h-18h LUNDI AU VENDREDI");

    String hourNow = hour.toString() + minute.toString();
    String dayNow = day.toString();
    String monthNow = month.toString();
    String dayOfWeekNow = dayOfWeek.toString();


  }

  void init(){
    listOfDays = new Map<String, int>();
    for(int i = 0; i < dayArray.length; i++){
      listOfDays[dayArray[i]] = i + 1;
    }

    listOfMonths = new Map<String, int>();
    for(int i = 0; i < monthArray.length; i++){
      listOfMonths[monthArray[i]] = i + 1;
    }
    print(listOfDays);
  }

}