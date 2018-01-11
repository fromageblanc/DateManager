//
//  DateManager
//  CalendarWrapper
//
//  Created by fromage.blanc.recette on 2017/12/25.
//  Copyright © 2017年 fromage.blanc.recette. All rights reserved.
//

import UIKit

protocol PopupCalendarDelegate {
    func calendarSelected(_ data:PopupCalendarCell,calendar:UICollectionView)
}

fileprivate var isPopupCalendarPresent = false // ポップアップカレンダーは表示中か？

//// カレンダー・タップセル情報構造体
struct PopupCalendarCell {
    var date:String!
    var week:String!
    var month:String!
    var previousMonth:String!
    var nextMonth:String!
}

class DateManager: NSObject {
    
    var baseDate:Date!
    var baseDateString:String!
    var formatter:DateFormatter!
    var formatterJ:DateFormatter!
    var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    var components:DateComponents!
    let defaultDateStyle = DateFormatter.Style.medium
    let defaultTimeStyle = DateFormatter.Style.none
    let defaultDateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ" // RFC3339
    let defaultDateFormatJ = "Gy年M月d日"
    
    var calendarComponent:CalendarComponents!
    var calendarView:UICollectionView?
    
    var popupCalendarDelegate:PopupCalendarDelegate?
    
    var wkPointer:DateManager!
    
    // ポップアップカレンダー部品
    var ymLabel:UILabel!
    var prevMonthButton:UIButton!
    var nextMonthButton:UIButton!
    var cancelButton:UIButton!
    
    /// カレンダーコンポーネント構造体
    struct CalendarComponents {
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
        
        init() {
            date = []
            day = []
            week = []
            month = []
            full = []
            weekJ = []
            monthJ = []
            fullJ = []
            numberOfWeek = []
            year = []
            targetMonth = ""
            targetYear = 1900
            gengou = ""
            numberOfWeeks = 0
            numberOfCells = 0
            previousMonth = ""
            nextMonth = ""
        }
    }
    
    
    /// イニシャライザ
    ///
    /// - Parameters:
    ///   - base: 基準日
    ///   - timeZone: タイムゾーン
    init(base:Date,timeZone:TimeZone) {
        
        baseDate = base
        
        calendar.firstWeekday = 2 // Monday
        
        formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = defaultDateFormat
        formatter.timeZone = timeZone
        formatter.calendar = calendar
        formatter.dateStyle = defaultDateStyle
        formatter.timeStyle = defaultTimeStyle
        
        formatterJ = DateFormatter()
        formatterJ.calendar = Calendar(identifier: Calendar.Identifier.japanese)
        formatterJ.dateFormat = defaultDateFormatJ
        formatterJ.locale = Locale(identifier: "ja_JP")
        formatterJ.timeZone = timeZone
        formatterJ.dateStyle = defaultDateStyle
        formatterJ.timeStyle = defaultTimeStyle
        
        components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: baseDate)
    }
    
    /// 簡易イニシャライザ
    ///
    /// - Parameter base: 基準日
    convenience init(base:Date) {
        self.init(base:base,timeZone:TimeZone.current)
    }
    
    /// イニシャライザ
    ///
    /// - Parameters:
    ///   - base: 基準日
    ///   - timeZone: タイムゾーン
    init(base:String,timeZone:TimeZone) {
        
        calendar.firstWeekday = 2 // Monday
        
        formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = defaultDateFormat
        baseDate = formatter.date(from: base)
        formatter.timeZone = timeZone
        formatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        formatter.dateStyle = defaultDateStyle
        formatter.timeStyle = defaultTimeStyle
        
        formatterJ = DateFormatter()
        formatterJ.calendar = Calendar(identifier: Calendar.Identifier.japanese)
        formatterJ.dateFormat = defaultDateFormatJ
        formatterJ.locale = Locale(identifier: "ja_JP")
        formatterJ.timeZone = timeZone
        formatterJ.dateStyle = defaultDateStyle
        formatterJ.timeStyle = defaultTimeStyle
        
        components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: baseDate)
    }
    
    /// 簡易イニシャライザ
    ///
    /// - Parameter base: 基準日
    convenience init(base:String) {
        self.init(base:base,timeZone:TimeZone.current)
    }
    
    /// 年を返却
    ///
    /// - Returns: 年
    func getYear() -> Int? {
        guard let val = components.year else {
            return nil
        }
        return val
    }
    
    /// 月を返却
    ///
    /// - Returns: 月
    func getMonth() -> Int? {
        guard let val = components.month else {
            return nil
        }
        return val
    }
    
    /// 日を返却
    ///
    /// - Returns: 日
    func getDay() -> Int? {
        guard let val = components.day else {
            return nil
        }
        return val
    }
    
    /// 時間を返却
    ///
    /// - Returns: 時間
    func getHour() -> Int? {
        guard let val = components.hour else {
            return nil
        }
        return val
    }
    
    /// 分を返却
    ///
    /// - Returns: 分
    func getMinute() -> Int? {
        guard let val = components.minute else {
            return nil
        }
        return val
    }
    
    /// 秒を返却
    ///
    /// - Returns: 秒
    func getSecond() -> Int? {
        guard let val = components.second else {
            return nil
        }
        return val
    }
    
    /// 曜日(英字)を返却
    ///
    /// - Returns: 週
    func getWeek() -> String? {
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE",
                                                        options: 0,
                                                        locale: Locale.current)
        let week = formatter.string(from: baseDate)
        formatter.dateFormat = defaultDateFormat
        formatter.dateStyle = defaultDateStyle
        formatter.timeStyle = defaultTimeStyle
        
        return week
    }
    
    /// 曜日(日本語)を返却
    ///
    /// - Returns: 週
    func getWeekJ() -> String? {
        formatterJ.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE",
                                                         options: 0,
                                                         locale: Locale.current)
        let week = formatterJ.string(from: baseDate)
        formatterJ.dateFormat = defaultDateFormatJ
        formatterJ.dateStyle = defaultDateStyle
        formatterJ.timeStyle = defaultTimeStyle
        
        return week
    }
    
    /// 曜日のインデックスを返却
    ///
    /// - Returns: 曜日のインデックス
    func weekSymbolIndex() -> Int? {
        
        // weekdaySymbols => ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE",
                                                        options: 0,
                                                        locale: Locale.current)
        let week = formatter.string(from: baseDate)
        
        for i in 0..<formatter.weekdaySymbols.count {
            if week == formatter.weekdaySymbols[i] {
                
                formatter.dateFormat = defaultDateFormat
                formatter.dateStyle = defaultDateStyle
                formatter.timeStyle = defaultTimeStyle
                
                return i
            }
        }
        
        return nil
    }
    
    /// 元号を返却
    ///
    /// - Returns: 元号
    func getGengou() -> String? {
        formatterJ.dateFormat = DateFormatter.dateFormat(fromTemplate: "G",
                                                         options: 0,
                                                         locale: Locale.current)
        let gengou = formatterJ.string(from: baseDate)
        formatterJ.dateFormat = defaultDateFormatJ
        formatterJ.dateStyle = defaultDateStyle
        formatterJ.timeStyle = defaultTimeStyle
        
        return gengou
    }
    
    /// 基準日文字列を返却
    ///
    /// - Parameters:
    ///   - style: スタイル指定（オプション）
    ///   - :ex. ["dateStyle":.full,"","timeStyle":.none]
    /// - Returns: 日付文字列
    func toString(style:Dictionary<String,DateFormatter.Style> = [:]) -> String? {
        formatter.timeStyle = style["timeStyle"] ?? .none
        formatter.dateStyle = style["dateStyle"] ?? .medium
        
        let baseDateStr = formatter.string(from: (baseDate!))
        formatter.dateFormat = defaultDateFormat
        formatter.dateStyle = defaultDateStyle
        formatter.timeStyle = defaultTimeStyle
        
        return baseDateStr
    }
    
    /// 基準日文字列を返却
    ///
    /// - Parameter format: フォーマット指定文字列 ex. yyyy-MM-dd
    /// - Returns: 日付文字列
    func toString(format:String) -> String? {
        
        guard format.count != 0 else {
            return nil
        }
        formatter.dateFormat = format
        
        let baseDateStr = formatter.string(from: (baseDate!))
        formatter.dateFormat = defaultDateFormat
        formatter.dateStyle = defaultDateStyle
        formatter.timeStyle = defaultTimeStyle
        
        return baseDateStr
    }
    /// 基準日文字列(ja_JP)を返却
    ///
    /// - Parameters:
    ///   - style: スタイル指定（オプション）
    ///   - :ex. ["dateStyle":.full,"","timeStyle":.none]
    /// - Returns: 日付文字列
    func toStringJ(style:Dictionary<String,DateFormatter.Style> = [:]) -> String? {
        formatterJ.timeStyle = style["timeStyle"] ?? .none
        formatterJ.dateStyle = style["dateStyle"] ?? .medium
        
        let baseDateStr = formatterJ.string(from: (baseDate!))
        formatterJ.dateFormat = defaultDateFormatJ
        formatterJ.dateStyle = defaultDateStyle
        formatterJ.timeStyle = defaultTimeStyle
        
        return baseDateStr
    }
    
    /// 基準日文字列を返却(RFC3339)を返却
    ///
    /// - Returns: 日付文字列
    func toRFC3339String() -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss ZZZZZ"
        let baseDateStr = formatter.string(from: baseDate)
        formatter.dateFormat = defaultDateFormat
        formatter.dateStyle = defaultDateStyle
        formatter.timeStyle = defaultTimeStyle
        
        return baseDateStr
    }
    
    /// 指定された日付との日数差を返却
    ///
    /// - Parameter date: 日付
    /// - Returns: 日数
    func intervalDays(_ date:Date) -> Double {
        return abs(floor((baseDate.timeIntervalSince(date))/86400))
    }
    
    /// 基準日が属す月に含まれる週の数を返却
    ///
    /// - Returns: 週の数
    func howManyWeeksInMonth() -> Int? {
        
        let range = calendar.range(of: .weekOfMonth, in: .month, for: baseDate)
        return range?.count
    }
    /// 基準日を含む月の月初と月末の日付を返却
    ///
    /// - Parameters:
    ///   - style: スタイル指定（オプション）
    ///   - :ex. ["dateStyle":.full,"","timeStyle":.none]
    /// - Returns: 文字列のタプル(月初文字列,月末文字列)
    func monthFirstAndLast(style:Dictionary<String,DateFormatter.Style> = [:]) -> (String,String) {
        
        let tmpDay = self.getDay()
        let tmpHour = self.getHour()
        
        components.day = 1
        components.hour = 9
        
        let monthBeginningDate = calendar.date(from: components)
        let range = calendar.range(of: .day, in: .month, for: baseDate)
        let lastDay = (range?.count)!
        components.day = lastDay
        let monthEndDate = calendar.date(from: components)
        
        formatter.timeStyle = style["timeStyle"] ?? .none
        formatter.dateStyle = style["dateStyle"] ?? .medium
        
        let dateSet = (formatter.string(from: monthBeginningDate!),formatter.string(from: monthEndDate!))
        formatter.dateFormat = defaultDateFormat
        formatter.dateStyle = defaultDateStyle
        formatter.timeStyle = defaultTimeStyle
        components.day = tmpDay
        components.hour = tmpHour
        
        return dateSet
        
    }
    
    /// カレンダーコンポーネント作成
    ///
    /// - Returns: カレンダーコンポーネント
    func createCalendarComponents() -> DateManager.CalendarComponents {
        
        // カレンダーコンポーネント
        var calendarComponents = DateManager.CalendarComponents()
        
        calendarComponents.targetYear = self.getYear()!
        calendarComponents.gengou = self.getGengou()!
        calendarComponents.targetMonth = self.addMonth(0).toString(format:"yyyy.MM")!
        calendarComponents.previousMonth = self.addMonth(-1).toString(format:"yyyy.MM")!
        calendarComponents.nextMonth = self.addMonth(1).toString(format:"yyyy.MM")!
        
        // 基準日の属す月の週数を取得
        let numberOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count
        // 週数情報をカレンダーコンポーネントにセット
        calendarComponents.numberOfWeeks = numberOfWeeks!
        
        // マス数をカレンダーコンポーネントにセット
        calendarComponents.numberOfCells = (calendarComponents.numberOfWeeks * 7)
        
        // 第1週の調整　ー　前月末週と当月１週の調整
        
        // componetns変更前のバックアップ
        let tmpDay = self.getDay()      // 日
        let tmpHour = self.getHour()    // 時間
        
        components.day = 1
        components.hour = 9
        
        // 基準日の属す月の１日を取得
        let firstDate = calendar.date(from: components)
        
        //  基準日の属す月の１日の曜日(Sunday,Monday...)を取得
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE",
                                                        options: 0,
                                                        locale: Locale.current)
        let weekStr = formatter.string(from: firstDate!)
        
        var weekIndex = 0
        // firstDateの曜日の週番号を取得
        for i in 0..<formatter.weekdaySymbols.count {
            if formatter.weekdaySymbols[i] == weekStr { // weekdaySymbols(週番号) : 日曜:0 ,月曜:1 ...
                weekIndex = i
                break
            }
        }
        
        // firstDateの曜日から、月曜始まりにするために遡る日数を算出
        // weekIndex=0(Sunday) -> -6 ,weekIndex=1(Monday) -> -0 ,weekIndex=2(Tuesday) -> -1 ...
        var paddingPreMonthDays = -6
        if weekIndex != 0 {
            paddingPreMonthDays = (1 - weekIndex)
        }
        
        var comps = DateComponents()
        comps.setValue(0, for: .year)
        comps.setValue(0, for: .month)
        comps.setValue(paddingPreMonthDays, for: .day)
        comps.setValue(0, for: .hour)
        comps.setValue(0, for: .minute)
        comps.setValue(0, for: .second)
        
        // カレンダーの１マス目になる日付を取得
        let calendarFirstDate = calendar.date(byAdding: comps, to: firstDate!)!
        
        var tmpDate:Date!
        var cell = 0  // カレンダーマスのインデックス
        
        // カレンダーコンポーネント作成
        
        // 週数分
        for w in 0..<numberOfWeeks! {
            
            // １週分
            for _ in 0..<7 {
                
                comps.setValue(0, for: .year)
                comps.setValue(0, for: .month)
                comps.setValue(cell, for: .day)
                comps.setValue(0, for: .hour)
                comps.setValue(0, for: .minute)
                comps.setValue(0, for: .second)
                
                // 第N週情報をカレンダーコンポーネントにセット
                calendarComponents.numberOfWeek.append(w+1)
                
                // 翌日を取得
                tmpDate = calendar.date(byAdding: comps, to: calendarFirstDate)!
                
                // 日付
                formatter.dateFormat = "yyyy-MM-dd"
                let dateStr = formatter.string(from: tmpDate)
                
                // 曜日のみを表示するようにフォーマットを設定
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE",
                                                                options: 0,
                                                                locale: Locale.current)
                
                formatterJ.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE",
                                                                 options: 0,
                                                                 locale: Locale.current)
                
                // 曜日文字列を取得
                let weekStr = formatter.string(from: tmpDate)
                let weekStrJ = formatterJ.string(from: tmpDate)
                
                // 日付情報をフル表示、時間情報を非表示にするようにフォーマットを設定
                formatter.dateStyle = .full
                formatterJ.dateStyle = .full
                formatter.timeStyle = .none
                formatterJ.timeStyle = .none
                
                // 日付情報文字列を取得
                let fullStr = formatter.string(from: tmpDate)
                let fullStrJ = formatterJ.string(from: tmpDate)
                
                // 日情報のみを表示するようにフォーマットを設定
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d",
                                                                options: 0,
                                                                locale: Locale(identifier: "en_US_POSIX"))
                // 日情報文字列を取得
                let dayStr = formatter.string(from: tmpDate)
                
                // 年情報のみを表示にするようにフォーマットを設定
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy",
                                                                options: 0,
                                                                locale: Locale.current)
                // 年情報文字列を取得
                let yearStr = formatter.string(from: tmpDate)
                
                // 月情報のみを表示にするようにフォーマットを設定
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM",
                                                                options: 0,
                                                                locale: Locale.current)
                
                formatterJ.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM",
                                                                 options: 0,
                                                                 locale: Locale.current)
                
                // 月情報文字列を取得
                let monthStr = formatter.string(from: tmpDate)
                let monthStrJ = formatterJ.string(from: tmpDate)
                
                // カレンダーコンポーネントにセット
                calendarComponents.date.append(dateStr)
                calendarComponents.day.append(dayStr)
                calendarComponents.week.append(weekStr)
                calendarComponents.month.append(monthStr)
                calendarComponents.monthJ.append(monthStrJ)
                calendarComponents.year.append(yearStr)
                calendarComponents.full.append(fullStr)
                calendarComponents.weekJ.append(weekStrJ)
                calendarComponents.fullJ.append(fullStrJ)
                
                cell += 1  // カレンダーのマスをプッシュ
            }
        }
        
        // 操作前の設定に戻す
        formatter.dateFormat = defaultDateFormat
        formatter.dateStyle = defaultDateStyle
        formatter.timeStyle = defaultTimeStyle
        formatterJ.dateFormat = defaultDateFormatJ
        formatterJ.dateStyle = defaultDateStyle
        formatterJ.timeStyle = defaultTimeStyle
        components.day = tmpDay
        components.hour = tmpHour
        
        return calendarComponents
    }
    /// 日付の増減処理
    ///
    /// - Parameters:
    ///   - year: 増減値.年
    ///   - month: 増減値.月
    ///   - day: 増減値.日
    ///   - hour: 増減値.時間
    ///   - minute: 増減値.分
    ///   - second: 増減値.秒
    /// - Returns: 処理後日時
    func add(year:Int ,month:Int ,day:Int ,hour:Int ,minute:Int ,second:Int) -> Date {
        
        var comps = DateComponents()
        
        comps.setValue(year, for: .year)
        comps.setValue(month, for: .month)
        comps.setValue(day, for: .day)
        comps.setValue(hour, for: .hour)
        comps.setValue(minute, for: .minute)
        comps.setValue(second, for: .second)
        
        return calendar.date(byAdding: comps, to: baseDate!)!
    }
    
    /// 週の増減処理
    ///
    /// - Parameter week: 増減値.週
    /// - Returns: DateManagerインスタンス
    func addWeek(_ week:Double) -> DateManager {
        
        if week > 0 {
            return DateManager(base:Date(timeInterval: 604800*week, since: baseDate!))
        } else {
            return DateManager(base:Date(timeInterval: -604800*fabs(week), since: baseDate!))
        }
    }
    
    /// 年の増減処理
    ///
    /// - Parameter week: 増減値.年
    /// - Returns: DateManagerインスタンス
    func addYear(_ year:Int) -> DateManager {
        return DateManager(base:add(year:year,month:0,day:0,hour:0,minute:0,second:0))
    }
    
    /// 月の増減処理
    ///
    /// - Parameter week: 増減値.月
    /// - Returns: DateManagerインスタンス
    func addMonth(_ month:Int) -> DateManager {
        return DateManager(base:add(year:0,month:month,day:0,hour:0,minute:0,second:0))
    }
    
    /// 日の増減処理
    ///
    /// - Parameter week: 増減値.日
    /// - Returns: DateManagerインスタンス
    func addDay(_ day:Int) -> DateManager {
        return DateManager(base:add(year:0,month:0,day:day,hour:0,minute:0,second:0))
    }
    
    // yyyy-MM-dd'T'HH:mm:ssZZZZZ
    func isBiggerThan(date:String) -> Bool? {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        guard let param = formatter.date(from: date) else {
            return nil
        }
        
        if baseDate > param {
            return true
        } else {
            return false
        }
    }
    
    func isBiggerThan(date:Date) -> Bool {
        if baseDate > date {
            return true
        } else {
            return false
        }
    }
    
    class func strToDate(dateString:String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone.current
        formatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        return formatter.date(from: dateString)!
    }
    
    /// カレンダーポップアップ
    ///
    /// - Parameter view: 貼り付け先のView
    func popupCalendar(completion:()->Void) {
        
        wkPointer = self
        
        if isPopupCalendarPresent {
            return
        }
        
        let screenSize: CGSize = CGSize(width: (UIScreen.main.bounds.size.height/2), height: (UIScreen.main.bounds.size.height/2) )
        let app = UIApplication.shared.delegate as! AppDelegate
        let destView = app.window!.rootViewController!.view!
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        // 各々の設計に合わせて調整
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 1.0
        
        calendarView = UICollectionView( frame: CGRect(x: 0, y: 0,
                                                       width: screenSize.width,
                                                       height: screenSize.height ),
                                         collectionViewLayout: layout)
        
        calendarView?.center = destView.center
        calendarView?.backgroundColor = UIColor.white
        calendarView?.layer.cornerRadius = 6.0
        // セルの登録
        calendarView?.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        
        ////  calendarComponent
        calendarComponent = self.createCalendarComponents()
        
        // 2. デリゲートを設定
        calendarView?.delegate = self
        calendarView?.dataSource = self
        
        //// 部品配置
        
        // 年月ラベル ++++
        ymLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:20))
        ymLabel.text = calendarComponent.targetMonth
        ymLabel.adjustsFontSizeToFitWidth = true
        
        let calendarCenterX = (calendarView?.frame.width)!/2
        let ymLabelCenterY = (calendarView?.frame.height)!-36
        // 位置
        ymLabel.center = CGPoint(x:calendarCenterX , y:ymLabelCenterY)
        
        // 前月ボタン ++++
        prevMonthButton = UIButton(frame:CGRect(x:(calendarView?.bounds.origin.x)!,y:ymLabelCenterY,width:70,height:20))
        prevMonthButton.setTitle("<< " + calendarComponent.previousMonth, for: .normal)
        prevMonthButton.setTitleColor(UIColor.blue, for: .normal)
        prevMonthButton.setTitleColor(UIColor.red, for: .highlighted)
        prevMonthButton.titleLabel?.adjustsFontSizeToFitWidth = true
        prevMonthButton.addTarget(self, action: #selector(DateManager.prevMonth), for: .touchUpInside)
        
        // 翌月ボタン ++++
        nextMonthButton = UIButton(frame:CGRect(x:(calendarView?.bounds.width)! - 70,y:ymLabelCenterY,width:70,height:20))
        nextMonthButton.setTitle(calendarComponent.nextMonth + " >>", for: .normal)
        nextMonthButton.setTitleColor(UIColor.blue, for: .normal)
        nextMonthButton.setTitleColor(UIColor.red, for: .highlighted)
        nextMonthButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextMonthButton.addTarget(self, action: #selector(DateManager.nextMonth), for: .touchUpInside)
        
        
        // キャンセルボタン ++++
        cancelButton = UIButton(frame: CGRect(x:0,y:0,width:50,height:20))
        cancelButton.setTitle("CLOSE", for: .normal)
        cancelButton.setTitleColor(UIColor.blue, for: .normal)
        cancelButton.setTitleColor(UIColor.red, for: .highlighted)
        // 位置
        cancelButton.center = CGPoint(x:calendarCenterX,
                                      y:((calendarView?.frame.height)!-15))
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.addTarget(self, action: #selector(DateManager.cancel), for: .touchUpInside)
        
        // カレンダービューに部品を貼り付け
        calendarView?.addSubview(cancelButton)
        calendarView?.addSubview(ymLabel)
        calendarView?.addSubview(prevMonthButton)
        calendarView?.addSubview(nextMonthButton)
        
        // 表示
        destView.addSubview(calendarView!)
        
        
        calendarOpen()
        
        completion()
    }
    
    
    /// ポップアップカレンダーを閉じる
    @objc private func cancel() {
        calendarClose()
    }
    
    /// ポップアップカレンダーを閉じる
    private func calendarClose() {
        calendarView?.removeFromSuperview()
        isPopupCalendarPresent = false
    }
    
    private func calendarOpen() {
        isPopupCalendarPresent = true
    }
    
    @objc private func prevMonth() {
        
        wkPointer = wkPointer.addMonth(-1)
        calendarComponent = wkPointer.createCalendarComponents()
        
        // コンポーネントデータ作成後は不要なのでwkPointerの参照先は極力削除
        wkPointer.calendarView = nil
        wkPointer.formatter = nil
        wkPointer.formatterJ = nil
        wkPointer.calendarComponent = nil
        wkPointer.components = nil
        wkPointer.ymLabel = nil
        wkPointer.prevMonthButton = nil
        wkPointer.nextMonthButton = nil
        wkPointer.cancelButton = nil
        
        DispatchQueue.main.async {
            // 年月ラベル ++++
            self.ymLabel.text = self.calendarComponent.targetMonth
            // 前月ボタン ++++
            self.prevMonthButton.setTitle("<< " + self.calendarComponent.previousMonth, for: .normal)
            // 翌月ボタン ++++
            self.nextMonthButton.setTitle(self.calendarComponent.nextMonth + " >>", for: .normal)
            
            self.calendarView?.reloadData()
        }
    }
    
    @objc private func nextMonth() {
        
        wkPointer = wkPointer.addMonth(1)
        calendarComponent = wkPointer.createCalendarComponents()
        
        DispatchQueue.main.async {
            // 年月ラベル ++++
            self.ymLabel.text = self.calendarComponent.targetMonth
            // 前月ボタン ++++
            self.prevMonthButton.setTitle("<< " + self.calendarComponent.previousMonth, for: .normal)
            // 翌月ボタン ++++
            self.nextMonthButton.setTitle(self.calendarComponent.nextMonth + " >>", for: .normal)
            
            self.calendarView?.reloadData()
        }
        
    }
    
}

//// UICollectionViewDelegate
extension DateManager: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        
        cell.backgroundColor = UIColor.yellow
        
        var data = PopupCalendarCell()
        data.date = calendarComponent.date[indexPath.row]
        data.week = calendarComponent.week[indexPath.row]
        data.month = calendarComponent.targetMonth
        data.previousMonth = calendarComponent.previousMonth
        data.nextMonth = calendarComponent.nextMonth
        
        popupCalendarDelegate?.calendarSelected(data,calendar: calendarView!)
        
        return false //true
    }
    
}

//// UICollectionViewDataSource
extension DateManager: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        
        let calendarCell = calendarView?.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        calendarCell.label.textColor = UIColor.black
        calendarCell.backgroundColor = UIColor.white
        calendarCell.isUserInteractionEnabled = true
        
        if indexPath.section == 0 {
            calendarCell.setupWeekHeader(indexPath.row)
            calendarCell.backgroundColor = UIColor.lightGray
            calendarCell.isUserInteractionEnabled = false
        } else {
            
            let cellText = calendarComponent.day[indexPath.item]
            calendarCell.setupContents(textName: cellText)
            let cellHiddenWeek = calendarComponent.week[indexPath.item]
            calendarCell.setupWeek(textName: cellHiddenWeek)
            
            if cellHiddenWeek == "Saturday" {
                calendarCell.label.textColor = UIColor.blue
            } else if cellHiddenWeek == "Sunday" {
                calendarCell.label.textColor = UIColor.red
                
            }
            
        }
        
        return calendarCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        if section == 0 {
            return 7
        } else {
            return calendarComponent.numberOfCells
        }
    }
    
}
// cellのサイズの設定
extension DateManager: UICollectionViewDelegateFlowLayout {
    // Screenサイズに応じたセルサイズを返す
    // UICollectionViewDelegateFlowLayoutの設定が必要
    func collectionView(_ collectionView: UICollectionView,
                        layout calendarViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // カレンダーの１マスのサイズを算出
        let app = UIApplication.shared.delegate as! AppDelegate
        
        let cellWidth = floor(((app.window?.frame.height)!/2) / 7)
        let cellHeight = cellWidth - 8
        
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension UICollectionView {
    func close() {
        self.removeFromSuperview()
        isPopupCalendarPresent = false
    }
}
extension Calendar {
    func isJapaneseCalendar() -> Bool {
        return self.identifier == Calendar.Identifier.japanese
    }
}

extension Date {
    
    func toStringWithCurrentLocale() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: self)
    }
    
}


/// カレンダーセル
class CalendarCell: UICollectionViewCell {
    
    let weekArray = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    let label: UILabel = {
        let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: screenSize.width / 7.0, height: screenSize.width / 7.0)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    private let week: UILabel = {
        let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: screenSize.width / 7.0, height: screenSize.width / 7.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.5
        
        contentView.addSubview(label)
    }
    
    func setupContents(textName: String) {
        label.text = textName
    }
    
    func setupWeek(textName: String) {
        week.text = textName
    }
    
    func setupWeekHeader(_ index:Int) {
        label.text = weekArray[index]
    }
    
}

