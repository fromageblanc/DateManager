# DateManager

DateManager makes processing easier on dates.

## Requirements
- iOS 9 and later 
- Swift 4.0 and later

## Memo
- only support Portrait
- Because it is under development, it includes some force unwrapping.

## Installation
Installation is easy. Just add DateManager.swift to your project.

## Usage
To instantiate a DateManager, a date is required as a parameter.
You can specify "Date" or "String" (RFC 3339) for the data type.
```swift
let dm = DateManager(base:Date())
let dm2 = DateManager(base:"2018-04-10T01:00:00Z")
```
It is possible to extract year, month, day, hours, minutes, and seconds separately
```swift
print(dm.baseDate.toStringWithCurrentLocale())
        
print(dm.getYear()!)
print(dm.getMonth()!)
print(dm.getDay()!)
print(dm.getWeek()!)
print(dm.getWeekJ()!)
print(dm.getHour()!)
print(dm.getMinute()!)
print(dm.getSecond()!)

/* output
2018-01-09 18:23:51
2018
1
9
Tuesday
火曜日
18
23
51
*/
```

"toString()", "toStringJ()" can specify the format

```swift
print(dm.toString()!)
print(dm.toStringJ()!)
print(dm.toString(style:["dateStyle": .short,"timeStyle":.full])!)
print(dm.toString(style:["dateStyle": .medium])!)
print(dm.toString(style:["dateStyle": .long])!)
print(dm.toString(style:["dateStyle": .full,"timeStyle":.full])!)
print(dm.toStringJ(style:["dateStyle": .short])!)
print(dm.toStringJ(style:["dateStyle": .medium,"timeStyle":.medium])!)
print(dm.toStringJ(style:["dateStyle": .long])!)
print(dm.toStringJ(style:["dateStyle": .full,"timeStyle":.short])!)

/* output
Jan 16, 2018
H30/01/16
1/16/18, 1:43:40 PM Japan Standard Time
Jan 16, 2018
January 16, 2018
Tuesday, January 16, 2018 at 1:43:40 PM Japan Standard Time
H30/01/16
H30/01/16 13:43:40
平成30年1月16日
平成30年1月16日 火曜日 13:43
 */
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
let calComps = dm.createCalendarComponents()
print(dm.baseDate)
print(calComps.targetMonth)
print(calComps.date)
print(calComps.weekJ)

/* output
2018-01-09 08:54:26 +0000
2018.01
["2018-01-01", "2018-01-02", "2018-01-03", "2018-01-04", "2018-01-05", "2018-01-06", "2018-01-07", "2018-01-08", "2018-01-09", "2018-01-10", "2018-01-11", "2018-01-12", "2018-01-13", "2018-01-14", "2018-01-15", "2018-01-16", "2018-01-17", "2018-01-18", "2018-01-19", "2018-01-20", "2018-01-21", "2018-01-22", "2018-01-23", "2018-01-24", "2018-01-25", "2018-01-26", "2018-01-27", "2018-01-28", "2018-01-29", "2018-01-30", "2018-01-31", "2018-02-01", "2018-02-02", "2018-02-03", "2018-02-04"]
["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]
*/
```
CalendarComponents member
```swift
var date:[String]           // 日付
var full:[String]           // 日付情報(フルフォーマット)
var fullJ:[String]          // 日付情報(ja/フルフォーマット)
var day:[String]            // 日
var week:[String]           // 曜日(英語)
var weekJ:[String]          // 曜日(日本語)
var month:[String]          // 月(英語)
var monthJ:[String]         // 月(日本語)
var year:[String]           // 年
var numberOfWeek:[Int]      // 第N週
var targetMonth:String      // カレンダー対象月
var targetYear:Int          // カレンダー対象年
var gengou:String           // カレンター対象元号
var numberOfWeeks:Int       // 週数
var numberOfCells:Int       // マス数
var previousMonth:String    // 前月
var nextMonth:String        // 翌月
```


DateManager makes it easy to incorporate pop-up calendar into your project.
#### Sample
<img src="https://user-images.githubusercontent.com/13625204/34709402-72ad1064-f55a-11e7-8d6b-57341d5f49ab.png" width="320px"/>


The process when a calendar cell is selected defines the delegate method.

```swift
protocol PopupCalendarDelegate {
    func calendarSelected(_ data:PopupCalendarCell,calendar:UICollectionView)
}
```

add to your View Controller
```swift
// set delegate
dm.popupCalendarDelegate = self
```
```swift
// calendar show
dm.popupCalendar(completion: { () in
    // your operation
})
```
```swift
extension ViewController:PopupCalendarDelegate {
    func calendarSelected(_ data: PopupCalendarCell,calendar:UICollectionView) {
        
        // your operation
        
        // calendar close. ** don't call removeFromSuperview! **
        //calendar.close()
    }
}
```



