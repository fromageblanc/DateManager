# DateManager

DateManager makes processing easier on dates.

## Installation
Installation is easy. Just add DateManager.swift to your project.

## Usage
To instantiate a DateManager, a date is required as a parameter.
You can specify "Date" or "String" (RFC 3339) for the data type.
```
let dm = DateManager(base:Date())
let dm2 = DateManager(base:"2018-04-10T01:00:00Z")
```


Methods whose name begins with "add" will return an instance of DateManager. So you can use the method chain style.
```
let dm = DateManager(base:Date())

let nextMonth = dm.addMonth(1).toString()
let before2YearAdd3Month = dm.addYear(-2).addMonth(3).toString()
let date = dm.addDay(2).addYear(10).addWeek(3).toString(style:["dateStyle":.full])
```

DateManager makes it easy to create a calendar component for the month that baseDate belongs to.
```
let calendarComponents = dm.createcalendarComponents()
```

DateManager makes it easy to incorporate pop-up calendar into your project.

![DateManagerDemo](https://user-images.githubusercontent.com/13625204/34709402-72ad1064-f55a-11e7-8d6b-57341d5f49ab.png "サンプル")


The process when a calendar cell is selected defines the delegate method.

```
protocol PopupCalendarDelegate {
    func calendarSelected(_ data:PopupCalendarCell,calendar:UICollectionView)
}
```

your ViewController
```
extension ViewController:PopupCalendarDelegate {
    func calendarSelected(_ data: PopupCalendarCell,calendar:UICollectionView) {
        
        // your operation
        
        // calendar close. ** don't call removeFromSuperview! **
        //calendar.close()
    }
}
```



