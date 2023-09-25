//
//  SettingViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/17.
//

import UIKit

class SettingTableViewController: UITableViewController {

   var sections: [Section] = []

    @objc func goToMain(){
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .icon
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.rowHeight = 56 // Set the row height
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        self.hidesBottomBarWhenPushed = true
        
        sections = [
            Section(title: "", rows: [
                Row(title: "공지/문의하기", action: {
                    
                    let appURL = URL(string: "instagram.com/_fromus2?igshid=Mzc1MmZhNjY=")!
                    let webURL = URL(string: "https://instagram.com/_fromus2?igshid=Mzc1MmZhNjY=")!

                    if UIApplication.shared.canOpenURL(appURL) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                    }
                    
                }),
                Row(title: "앱 정보", action: {
                    let storyboard = UIStoryboard(name: "AppInfo", bundle: nil)
                    
                    guard let vc = storyboard.instantiateViewController(withIdentifier: "AppInformationTableViewController") as? AppInformationTableViewController else { return }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }),
                Row(title: "로그아웃", action: {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlertLogoutViewController") as? AlertLogoutViewController else {return}
                    
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: false, completion: nil)
                }),
                Row(title: "커플연결 끊기", action: {
                    let storyboard = UIStoryboard(name: "DisconnectCouple", bundle: nil)
                    
                    guard let vc = storyboard.instantiateViewController(withIdentifier: "DisconnectCoupleViewController") as? DisconnectCoupleViewController else { return }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }),
                Row(title: "탈퇴하기", action: {
                    let storyboard = UIStoryboard(name: "WithdrawlService", bundle: nil)
                    
                    guard let vc = storyboard.instantiateViewController(withIdentifier: "WithdrawlServiceViewController") as? WithdrawlServiceViewController else { return }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }),
            ]),
        
        ]
        
        title = "설정"
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToMain), name: .popToRootView, object: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let row = sections[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = row.title
        
        if indexPath.row == 0 || indexPath.row == 1{
            cell.accessoryType = .disclosureIndicator
        }
        else{
            cell.accessoryType = .none
        }
        
        if indexPath.row == 4 {
            cell.textLabel?.font = UIFont.Pretendard(.regular, size: 14)
            cell.textLabel?.textColor = UIColor(hex: 0x656565)
        }
        else{
            cell.textLabel?.font = UIFont.Pretendard(.regular, size: 16)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = sections[indexPath.section].rows[indexPath.row]
        row.action?()
    }

}
