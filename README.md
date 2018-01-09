# DateManager

DateManager makes processing easier on dates.

## Installation
Installation is easy. Just add DateManager.swift to your project.

## Usage
To instantiate a DateManager, a date is required as a parameter.
You can specify "Date" or "String" (RFC 3339) for the data type.
```swift
let dm = DateManager(base:Date())
let dm2 = DateManager(base:"2018-04-10T01:00:00Z")
```

Methods whose name begins with "add" will return an instance of DateManager. So you can use the method chain style.
```swift
let dm = DateManager(base:Date())

let date1 = dm.addMonth(1).toString()
let date2 = dm.addYear(-2).addMonth(3).toString()
let date3 = dm.addDay(2).addYear(10).addWeek(3).toString(style:["dateStyle":.full])
```

DateManager makes it easy to create a calendar component for the month that baseDate belongs to.
```swift
let calendarComponents = dm.createcalendarComponents()
```

DateManager makes it easy to incorporate pop-up calendar into your project.

![DateManagerDemo](https://user-images.githubusercontent.com/13625204/34709402-72ad1064-f55a-11e7-8d6b-57341d5f49ab.png "sample")


The process when a calendar cell is selected defines the delegate method.

```swift
protocol PopupCalendarDelegate {
    func calendarSelected(_ data:PopupCalendarCell,calendar:UICollectionView)
}
```

add to your ViewController code
```swift
extension ViewController:PopupCalendarDelegate {
    func calendarSelected(_ data: PopupCalendarCell,calendar:UICollectionView) {
        
        // your operation
        
        // calendar close. ** don't call removeFromSuperview! **
        //calendar.close()
    }
}
```



