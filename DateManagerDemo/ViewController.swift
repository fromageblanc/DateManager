//
//  ViewController.swift
//  DateManagerDemo
//
//  Created by 吉田誠志 on 2018/01/09.
//  Copyright © 2018年 吉田誠志. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let dm = DateManager(base:Date()) // instance from Date Type
    //let dm = DateManager(base:"2018-04-10T01:00:00Z") // instance from String(RFC3339)

    @IBOutlet weak var textField:UILabel!
    @IBAction func showCalendar(_ sender:UIButton) {
        dm.popupCalendar(completion: { () in
            print("completion : calendar show")
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dm.popupCalendarDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//// ポップアップカレンダーの日付を選択した時の処理
extension ViewController:PopupCalendarDelegate {
    func calendarSelected(_ data: PopupCalendarCell,calendar:UICollectionView) {
        self.textField.text = data.date + " " + data.week
        
        // カレンダーを閉じる calender.removeFromSuperviewはしないでください
        //calendar.close()
    }
}
