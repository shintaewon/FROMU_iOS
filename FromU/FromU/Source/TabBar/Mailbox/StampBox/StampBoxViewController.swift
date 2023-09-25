//
//  StampBoxViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/30.
//

import UIKit

class StampBoxViewController: UIViewController {

    // MARK: - Properties
    let numberOfItemsPerRow: CGFloat = 2
    let interitemSpacing: CGFloat = 40
    var selectedCellIndexPath: IndexPath?
    
    let fromCountLabel = UILabel()
    
    var imageNames : [String] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 62, bottom: 0, right: 62) // 수정한 부분
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private var buyStampButton: UIButton = {
        
        let button = UIButton()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.BalsamTint(.size18),
            .foregroundColor: UIColor.primary01,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let highlightedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.BalsamTint(.size18),
            .foregroundColor: UIColor.highlight,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        button.setAttributedTitle(NSAttributedString(string: "구매하기", attributes: attributes), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "구매하기", attributes: highlightedAttributes), for: .highlighted)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buyStampButtonTapped), for: .touchUpInside)
        
        return button
    }()

    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "stamp_empty") // 여기에 디폴트 이미지 이름을 입력
        imageView.contentMode = .scaleToFill
        imageView.isHidden = true
        return imageView
    }()

    let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "텅! 비었어!" // 라벨에 보여줄 텍스트
        label.font = UIFont.BalsamTint(.size22)
        label.textColor = .disabledText
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
        setupConstraints()
        setupActions()
        setupNavigation()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBars()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showBars()
    }
    
    // MARK: - UI Setup
    func setupUIComponents() {
        // 기본적인 view 설정
        // 예) backgroundColor, addSubView 등
        view.backgroundColor = .white
    }
    
    func setupConstraints() {
        // AutoLayout 또는 다른 방식의 레이아웃 설정
        setupBuyStampButton()
        setupCollectionView()
        setupEmptyComponents()
        
    }
    
    func setupActions() {
        // UI 컴포넌트에 대한 액션 설정
        // 예) button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setupNavigation() {
        // Navigation 관련 설정
        // 예) navigationItem.title, barButtonItems 등
        navigationController?.navigationBar.tintColor = .icon
        title = "우표함"
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.BalsamTint( .size18),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    
    // MARK: - Data Handling
    func fetchData() {
        // 네트워크 요청 또는 초기 데이터 로딩
        configureNavigationItems()
        getFromCount()
        getStampList()
    }
    
    // MARK: - Actions
    @objc private func buyStampButtonTapped() {
        
        let vc = BuyStampViewController()
        navigationController?.pushViewController(vc, animated: true)

    }
    
    // MARK: - Functions
    private func setupEmptyComponents() {
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50), // ImageView를 중앙에서 약간 위로 이동
            emptyImageView.widthAnchor.constraint(equalToConstant: 106),
            emptyImageView.heightAnchor.constraint(equalToConstant: 106),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 24),
            emptyLabel.centerXAnchor.constraint(equalTo: emptyImageView.centerXAnchor)
        ])
    }
    
    private func setupBuyStampButton(){
        view.addSubview(buyStampButton)
        
        NSLayoutConstraint.activate([
            
            buyStampButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            buyStampButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buyStampButton.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    private func setupCollectionView(){
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: buyStampButton.bottomAnchor, constant: 6),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    
    private func hideBars() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func showBars() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureNavigationItems() {
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
        
        let rightBarItem2 = UIBarButtonItem()
        rightBarItem2.customView = fromCountLabel
        rightBarItem2.width = size.width + 20 - 10

        let heartImage = UIImageView(image: UIImage(named: "Property 28"))
        heartImage.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let rightBarItem3 = UIBarButtonItem()
        rightBarItem3.customView = heartImage
        rightBarItem3.width = 32 + 10

        let space = UIImageView(image: UIImage())
        space.frame = CGRect(x: 0, y: 0, width: 2, height: 0)
        let spacer = UIBarButtonItem()
        spacer.customView = space

        self.navigationItem.rightBarButtonItems = [spacer, rightBarItem2, rightBarItem3]
    }

    func getStampListForArr(stampList: [Int]) -> [String] {
        return stampList.map { "stamp\($0)" }
    }

}


extension StampBoxViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: imageNames[indexPath.row])
        cell.contentView.addSubview(imageView)
        cell.contentView.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: 105, height: 145)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
    
}

extension StampBoxViewController{
    
    func getStampList(){
        ViewAPI.providerView.request( .getStampList){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(StampListResponse.self)
                                        
                    print(response)
                    
                    if response.isSuccess == true && response.code == 1000 && !response.result.isEmpty {
                            self.imageNames = self.getStampListForArr(stampList: response.result)
                            self.collectionView.reloadData()
                            self.emptyImageView.isHidden = true
                            self.emptyLabel.isHidden = true
                        } else {
                            self.emptyImageView.isHidden = false
                            self.emptyLabel.isHidden = false
                        }
                    
                    
                } catch {
                    print(error)
                    self.emptyImageView.isHidden = false
                    self.emptyLabel.isHidden = false
                }
                
            case .failure(let error):
                print("DEBUG>> setMailBoxName Error : \(error.localizedDescription)")
                self.emptyImageView.isHidden = false
                self.emptyLabel.isHidden = false
            }
        }
    }
    
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
