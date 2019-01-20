
class DescriptionFilter{

  DescriptionFilter(){}

  List filterInput(String input){
    List splittedInput = input.split(" ");
    print(splittedInput);
    splittedInput.removeAt(0);

    removeWithRegex(splittedInput);

    print(splittedInput);
    return splittedInput;
  }

  void removeWithRegex(List<String> splittedInput){
    for(int i = 0; i < splittedInput.length; i++){
      String valueFiltered = splittedInput[i];
      valueFiltered = valueFiltered.replaceAll(new RegExp(r'[^\w\s]+'),'');
      valueFiltered = valueFiltered.replaceAll(new RegExp(r'h'),'');
      valueFiltered = valueFiltered.replaceAll(new RegExp(r' '), '');

      if((new RegExp(r'[a-zA-Z]+')).hasMatch(valueFiltered)){
        if(valueFiltered.length > 3) {
          String newValue = "";
          int valueToSubstract = valueFiltered.length - 3;
          for(int j = 0; j < valueFiltered.length - valueToSubstract; j++){
            newValue += valueFiltered[j];
          }
          valueFiltered = newValue;
        }
      }

      if((new RegExp(r'[0-9]+')).hasMatch(valueFiltered)){
        if(valueFiltered.length == 4) {
          String firstHalf = valueFiltered[0] + valueFiltered[1] + "00";
          String secondHalf = valueFiltered[2] + valueFiltered[3] + "00";
          valueFiltered = firstHalf + secondHalf;
        }
        if(valueFiltered.length == 6){
          String firstHalf = "";
          String secondHalf = "";

          if(valueFiltered.endsWith("00") || valueFiltered.endsWith("30")){
            firstHalf = valueFiltered[0] + valueFiltered[1] + "00";
            secondHalf = valueFiltered.substring(2,6);
            valueFiltered = firstHalf + secondHalf;
          }
          else{
            firstHalf = valueFiltered.substring(0,4);
            secondHalf = valueFiltered[4] + valueFiltered[5] + "00";
            valueFiltered = firstHalf + secondHalf;
          }
        }
      }

      if(valueFiltered == "1er"){
        valueFiltered = "1";
      }

      splittedInput[i] = valueFiltered;
    }
    splittedInput.removeWhere((item) => item.length == 0);
  }

}