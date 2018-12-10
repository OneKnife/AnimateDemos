//
//  ViewController.swift
//  AnimateDemos
//
//  Created by 赵一超 on 2018/12/3.
//  Copyright © 2018年 melody. All rights reserved.
//

import UIKit

struct YSSection {
    var title: String
    var rows: [YSRow]
    mutating func addRow(row: YSRow) {
        rows.append(row)
    }
}

struct YSRow {
    var title: String
    var className: String
}

class ViewController: UITableViewController {

    var sections: [YSSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demos"
        
        var section1 = YSSection.init(title: "动画", rows: [])
        section1.addRow(row: YSRow.init(title: "加载动画", className: "YSLoadingAnimation"))
        section1.addRow(row: YSRow.init(title: "水波动画", className: "YSWaveCurveController"))
        section1.addRow(row: YSRow.init(title: "Check按钮动画", className: "YSCheckButtonController"))
        section1.addRow(row: YSRow.init(title: "弹性动画", className: "YSSpringAnimationController"))

        sections.append(section1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionI = sections[section]
        return sectionI.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "YS")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "YS")
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = row.title
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        let cls = NSClassFromString("AnimateDemos." + row.className) as? UIViewController.Type
        if let cls = cls {
            let viewController = cls.init()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

