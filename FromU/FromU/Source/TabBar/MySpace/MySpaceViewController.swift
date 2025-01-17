//
//  MySpaceViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/01.
//

import UIKit

class MySpaceViewController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var coupleNameStackView: UIStackView!
    
    @IBOutlet weak var myNameLabel: UILabel!
    
    @IBOutlet weak var partnerNameLabel: UILabel!
    
    @IBOutlet weak var ddayLabel: UILabel!
    

    @IBOutlet weak var tableView: UITableView!
    
    var sections: [Section] = []
    
    let fromCountLabel = UILabel()
    
    func configureNavigationItems(){
        
        fromCountLabel.backgroundColor = .primaryLight
        fromCountLabel.layer.cornerRadius = 10
        fromCountLabel.clipsToBounds = true
        fromCountLabel.font = UIFont.BalsamTint(.size16)
        fromCountLabel.text = "    "
        fromCountLabel.textColor = .primary02
        fromCountLabel.textAlignment = .center
        
        // NSAttributedString 적용 부분
        if let currentText = fromCountLabel.text {
            let attributedString = NSMutableAttributedString(string: currentText)
            attributedString.addAttribute(.baselineOffset, value: 2, range: NSRange(location: 0, length: attributedString.length))
            fromCountLabel.attributedText = attributedString
        }

        let size = fromCountLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        fromCountLabel.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: 20)
        
        let fromCountItem = UIBarButtonItem()
        fromCountItem.customView = fromCountLabel
        fromCountItem.width = size.width + 20 - 10

        let heartImage = UIImageView(image: UIImage(named: "Property 28"))
        heartImage.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let heartImageItem = UIBarButtonItem()
        heartImageItem.customView = heartImage
        heartImageItem.width = 32 + 10

        let space = UIImageView(image: UIImage())
        space.frame = CGRect(x: 0, y: 0, width: 2, height: 0)
        let spacer = UIBarButtonItem()
        spacer.customView = space

        let bellButton = UIButton()
        bellButton.setImage(UIImage(named: "icn_bell"), for: .normal)
        bellButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let bellItem = UIBarButtonItem()
        bellItem.customView = bellButton
        bellItem.width = 32 + 10
        
        self.navigationItem.rightBarButtonItems = [bellItem, spacer, fromCountItem, heartImageItem]
        
        let leftItem = UIImageView(image: UIImage(named: "logotypo"))
        leftItem.frame = CGRect(x: 0, y: 0, width: 65, height: 18)
        
        let imageButtonItem = UIBarButtonItem(customView: leftItem)
                
        // Set the UIBarButtonItem as the left navigation item of your view controller
        navigationItem.leftBarButtonItem = imageButtonItem
        
    }
    
    func configuration(){
        
        navigationController?.navigationBar.tintColor = .icon
        myNameLabel.text = UserDefaults.standard.string(forKey: "myNickName")
        
        partnerNameLabel.text = UserDefaults.standard.string(forKey: "partnerNickName")
        let tempLabel = UILabel()
        
        if let string1 = myNameLabel.text, let string2 = partnerNameLabel.text {
            let tempString3 = string1 + string2
            tempLabel.text = tempString3
        }
        
        tempLabel.font = UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir, size: 18)
        tempLabel.sizeToFit()
        let newWidth = tempLabel.frame.width + 32
                
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.primaryLight.cgColor
        bottomBorder.frame = CGRect(x: 0, y: coupleNameStackView.frame.size.height - 1, width: newWidth, height: 1)

        // Add the layer to the stack view's layer
        coupleNameStackView.layer.addSublayer(bottomBorder)
        
        if UserDefaults.standard.integer(forKey: "dDay") != 0 {
            ddayLabel.text = "\(UserDefaults.standard.integer(forKey: "dDay"))"
        }
        else{
            ddayLabel.text = "    "
        }
        
        
        
        ddayLabel.sizeToFit()
        
        let bottomBorder_ = CALayer()
        bottomBorder_.backgroundColor = UIColor.primaryLight.cgColor
        bottomBorder_.frame = CGRect(x: 0, y: ddayLabel.frame.size.height - 1, width: ddayLabel.frame.size.width, height: 1)

        // Add the layer to the stack view's layer
        ddayLabel.layer.addSublayer(bottomBorder_)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        configureNavigationItems()
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius = 12
        shadowView.layer.shadowOpacity = 1
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        self.hidesBottomBarWhenPushed = true
        
        sections = [
            Section(title: "", rows: [
                Row(title: "알림메세지 설정", action: {
                    let vc = SettingPushNotificationViewController()
                    
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }),
                Row(title: "우편함 설정", action: {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingTableViewController") as? SettingTableViewController else { return }
                    
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }),
                
            ]),
        
        ]
        
        // UITapGestureRecognizer를 coupleNameStackView에 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToInformationSetting))
        coupleNameStackView.addGestureRecognizer(tapGesture)
        coupleNameStackView.isUserInteractionEnabled = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.getFromCount()
    }

    @objc func navigateToInformationSetting() {
        let vc = InformationSettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MySpaceViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MySpaceCell", for: indexPath)
        let row = sections[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = row.title
        cell.textLabel?.font = UIFont.Pretendard(.regular, size: 16)
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = sections[indexPath.section].rows[indexPath.row]
        row.action?()
    }
}

extension Notification.Name {
    
    static let popToRootView = Notification.Name("popToRootView")
}

extension MySpaceViewController{
    func getFromCount(){
        
        ViewAPI.providerView.request(.getFromCount){ result in
            switch result{
            case .success(let data):
                do{
                    let response = try data.map(FromCountResponse.self)
                    self.fromCountLabel.text = "\(response.result)"
                    print(response)
                } catch{
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> getFromCount Error : \(error.localizedDescription)")
                
            }
        }
    }
}
