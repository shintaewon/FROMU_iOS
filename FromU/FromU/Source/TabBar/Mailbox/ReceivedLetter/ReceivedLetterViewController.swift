//
//  ReceivedLetterViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/05/09.
//

import UIKit
import Moya

class ReceivedLetterViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private var letters: [GetLetterListResult] = [] // 편지 목록 저장
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "letter.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true // Initially hidden
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 받은 편지가 없어!"
        label.font = UIFont.BalsamTint(.size20)
        label.textColor = .gray
        label.textAlignment = .center
        label.isHidden = true // Initially hidden
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLetterList()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AppInformationCell")
        tableView.rowHeight = 64 // Set the row height
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine // 구분선 스타일 변경
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // Add empty view components
        tableView.addSubview(emptyImageView)
        tableView.addSubview(emptyLabel)
        
        // Setup constraints or frames
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 185), // Adjust as needed
            emptyImageView.widthAnchor.constraint(equalToConstant: 72), // Adjust as needed
            emptyImageView.heightAnchor.constraint(equalToConstant: 60), // Adjust as needed
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 24), // Adjust as needed
        ])
    }
}

extension ReceivedLetterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return letters.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택한 셀의 편지 정보 가져오기
        let selectedLetter = letters[indexPath.row]
        
        //답장편지일때 ==> 내가 이전에 보냈던 편지에 답장을 한 편지일 경우 -> 기본 편지지쪽으로 이동
        //원래이거 2 인데 잠깐 테스트때문에 1로 해놓은거, 테스끝나고 == 2 로 다시 바꿀것
        if letters[indexPath.row].status == 2 {
            
            //답장편지이고, 아직 안읽은 편지일 경우 -> 로티 보여줘야됨 -> ReadLetterLottieViewController로 이동
            if letters[indexPath.row].readFlag == false {
                
                print("답장, 안읽음")
                
                // ReadLetterViewController 인스턴스 생성
                let vc = ReadLetterLottieViewController()
                vc.selectedLetter = selectedLetter // 선택한 편지 정보 전달

                // ReadLetterViewController로 전환 (푸시 또는 모달)
                navigationController?.pushViewController(vc, animated: true)
                
            } else{ //답장편지이고, 이미 읽은 편지일 경우 -> 로티 안보여주고 바로
                print("답장, 읽음")
                
                // ReadLetterViewController 인스턴스 생성
                let vc = ReadReplyLetterViewController()
                vc.selectedLetter = selectedLetter // 선택한 편지 정보 전달

                // ReadLetterViewController로 전환 (푸시 또는 모달)
                navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        //그냥 랜덤으로 발송한 편지일 경우 -> 스탬프 번호에 맞게 편지지 열어주는곳으로 이동
        else if letters[indexPath.row].status == 0 {
            
            //랜덤편지이고, 아직 안읽은 편지일 경우 -> 로티 보여줘야됨 -> ReadLetterLottieViewController로 이동
            if letters[indexPath.row].readFlag == false {
                print("랜덤, 안읽음")
                // ReadLetterViewController 인스턴스 생성
                let vc = ReadLetterLottieViewController()
                vc.selectedLetter = selectedLetter // 선택한 편지 정보 전달

                // ReadLetterViewController로 전환 (푸시 또는 모달)
                navigationController?.pushViewController(vc, animated: true)
                
            } else{ //랜덤편지이고, 이미 읽은 편지일 경우 -> 로티 안보여주고 바로
                print("랜덤, 읽음")
                
                // ReadRandomLetterViewController 인스턴스 생성
                let vc = ReadRandomLetterViewController()
                vc.selectedLetter = selectedLetter // 선택한 편지 정보 전달

                // ReadRandomLetterViewController로 전환 (푸시 또는 모달)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        // 선택 상태 제거
        tableView.deselectRow(at: indexPath, animated: true)
    
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppInformationCell", for: indexPath)
        
        let letter = letters[indexPath.row]
        
        // 편지의 읽음 여뷰에 따라서 회색/검은색으로 색상 설정
        let textColor: UIColor = letter.readFlag ? .gray : .black
        
        cell.textLabel?.text = letter.mailboxName + "에서 보낸 편지가 도착했어."
        cell.textLabel?.font = UIFont.BalsamTint(.size18)
        cell.textLabel?.textColor = textColor // 색상 설정
        
        // 날짜 문자열을 MM.dd 형식으로 변환
        if let date = DateFormatter.date(from: letter.time, format: "yyyy-MM-dd HH:mm:ss") {
            let dateString = DateFormatter.string(from: date, format: "MM.dd")
            
            // 날짜 레이블 생성 및 설정
            let dateLabel = UILabel()
            dateLabel.text = dateString
            dateLabel.font = UIFont.BalsamTint(.size18)
            dateLabel.textColor = textColor
            dateLabel.sizeToFit() // 레이블의 크기를 텍스트 크기에 맞게 조정
            
            // 날짜 레이블을 accessory view로 설정
            cell.accessoryView = dateLabel
            
            print("accessoryView: ", dateString)
        }
        
        return cell
    }
    
}

extension ReceivedLetterViewController{
    
    func getLetterList() {
        LetterAPI.providerLetter.request(.getLetterList(type: "0")) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try data.map(GetLetterListResponse.self)
                    self.letters = response.result // 편지 목록 저장
                    
                    print(response)
                    
                    // Show or hide empty view based on letters count
                    self.emptyImageView.isHidden = !self.letters.isEmpty
                    self.emptyLabel.isHidden = !self.letters.isEmpty
                    
                    self.tableView.reloadData() // 테이블 뷰 업데이트
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> getFromCount Error : \(error.localizedDescription)")
            }
        }
    }
    
}

