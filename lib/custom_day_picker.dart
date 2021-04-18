import 'package:flutter/material.dart';
import 'file:///C:/Users/nhatvm/Desktop/flutter_ui/lib/day_picker_ui/dayPickerHelper.dart';

class CustomDayPicker extends StatefulWidget {
  @override
  _CustomDayPickerState createState() => _CustomDayPickerState();
}

class _CustomDayPickerState extends State<CustomDayPicker> {
  var currentDay;
  var currentMonth;
  var currentYear;
  var calendar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var currentTime = DateTime.now();
    currentDay = currentTime.day;
    currentMonth = currentTime.month;
    currentYear = currentTime.year;
    calendar = dayToWeekday(month: currentMonth, year: currentYear);
    print(calendar);
  }

  onBackPressed() {
    var newCalendar;
    if (currentMonth == 1) {
      newCalendar = dayToWeekday(month: 12, year: currentYear - 1);
      setState(() {
        currentMonth = 12;
        currentYear = currentYear - 1;
        calendar = newCalendar;
      });
    } else {
      newCalendar = dayToWeekday(month: currentMonth - 1, year: currentYear);
      setState(() {
        currentMonth = currentMonth - 1;
        calendar = newCalendar;
      });
    }
  }

  onForwardPressed() {
    var newCalendar;
    if (currentMonth == 12) {
      newCalendar = dayToWeekday(month: 1, year: currentYear + 1);
      setState(() {
        currentMonth = 1;
        currentYear = currentYear + 1;
        calendar = newCalendar;
      });
    } else {
      newCalendar = dayToWeekday(month: currentMonth + 1, year: currentYear);
      setState(() {
        currentMonth = currentMonth + 1;
        calendar = newCalendar;
      });
    }
  }

  onDaySelected(day) {
    setState(() {
      currentDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: 20.0,
                  ),
                  onPressed: onBackPressed,
                ),
                Container(

                  child: Text(
                    'Tháng $currentMonth năm $currentYear',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 20.0,
                  ),
                  onPressed: onForwardPressed,
                ),
              ],
            ),
          ),
          Container(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: dayNames
                  .map((e) => Flexible(
                        child: Container(
                          child: Center(
                            child: Text(e),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Container(

            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              shrinkWrap: true,
              itemCount: calendar.length,
              itemBuilder: (context, index) {
                if (calendar[index] == 0) {
                  return Container();
                }
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: calendar[index] == currentDay
                          ? Colors.greenAccent
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        calendar[index].toString(),
                        style: TextStyle(
                            color: calendar[index] == currentDay
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                  onTap: (){
                    onDaySelected(calendar[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
