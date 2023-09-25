//
//  BuyStampViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/30.
//

import UIKit

class BuyStampViewController: UIViewController {

    // MARK: - Properties
    let numberOfItemsPerRow: CGFloat = 2
    let interitemSpacing: CGFloat = 40
    var selectedCellIndexPath: IndexPath?
    
    let fromCountLabel = UILabel()
    
    let imageNames = ["stamp1", "stamp2", "stamp3", "stamp4", "stamp5", "stamp6"]
    
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

    private let mainExplainLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 우표를 구매하고 싶어?"
        label.font = UIFont.BalsamTint(.size22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let subExplainLabel: UILabel = {
        let label = UILabel()
        label.text = "우표에 따라 편지지가 달라질 거야."
        label.font = UIFont.BalsamTint(.size22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .icon
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
        setupMainExplainLabel()
        setupSubExplainLabel()
        setupCollectionView()
        
    }
    
    func setupActions() {
        // UI 컴포넌트에 대한 액션 설정
        // 예) button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setupNavigation() {
        // Navigation 관련 설정
        // 예) navigationItem.title, barButtonItems 등
        navigationController?.navigationBar.tintColor = .icon
        title = "우표구매"
        
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
    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Functions
    private func setupMainExplainLabel(){
        view.addSubview(mainExplainLabel)
        
        NSLayoutConstraint.activate([
            mainExplainLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainExplainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainExplainLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func setupSubExplainLabel(){
        view.addSubview(subExplainLabel)
        
        NSLayoutConstraint.activate([
            subExplainLabel.topAnchor.constraint(equalTo: self.mainExplainLabel.bottomAnchor, constant: 8),
            subExplainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subExplainLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func setupCollectionView(){
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: subExplainLabel.bottomAnchor, constant: 34),
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

}


extension BuyStampViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ModalStampExplainViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.stampNum = indexPath.row + 1
        vc.parentVC = self // 참조 설정
        self.present(vc, animated: true, completion: nil)
        
    }
}

extension BuyStampViewController{
 
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
