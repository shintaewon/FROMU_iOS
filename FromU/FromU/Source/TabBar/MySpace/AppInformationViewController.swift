//
//  AppInformationTableViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/17.
//

import UIKit

struct Section {
    let title: String?
    let rows: [Row]
}

struct Row {
    let title: String
    let action: (() -> Void)?
}

class AppInformationTableViewController: UITableViewController {

    private let sections: [Section] = [
        Section(title: "", rows: [
            Row(title: "이용약관", action: {
                
                let appURL = URL(string: "www.notion.so/760bcb4d71c9423d9b751a49882984a4?pvs=4")!
                let webURL = URL(string: "https://www.notion.so/760bcb4d71c9423d9b751a49882984a4?pvs=4")!

                if UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                }
                
            }),
            Row(title: "개인정보처리방침", action: {
                
                let appURL = URL(string: "www.notion.so/bbcd9f741538474893adba60c3c8ee75?pvs=4")!
                let webURL = URL(string: "https://www.notion.so/bbcd9f741538474893adba60c3c8ee75?pvs=4")!

                if UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                }
                
            }),
        ]),
    
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .icon
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AppInformationCell")
        tableView.rowHeight = 56 // Set the row height
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
 
        title = "앱 정보"
        
        // Customize the navigation bar title font
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir , size: 14),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppInformationCell", for: indexPath)
        let row = sections[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = row.title
        cell.textLabel?.font = UIFont.Pretendard(.regular, size: 16)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = sections[indexPath.section].rows[indexPath.row]
        row.action?()
    }
    
}

