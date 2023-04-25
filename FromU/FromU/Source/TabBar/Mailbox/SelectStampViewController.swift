//
//  SelectStampViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/04/19.
//

import UIKit

class SelectStampViewController: UIViewController {

    let numberOfItemsPerRow: CGFloat = 2
    let interitemSpacing: CGFloat = 40
    var selectedCellIndexPath: IndexPath?
    
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
    
    private var explainLabel: UILabel = {
        
        let label = UILabel()
        label.text = "편지에 사용할 우표를 골라줘!"
        label.font = UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var nextBtn: UIButton = {
        
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .disabled
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard(.regular, size: 16)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func nextBtnTapped() {
        
        let vc = WrittingLetterViewController()
        navigationController?.pushViewController(vc, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .icon
        
        // 컬렉션 뷰 추가
        view.addSubview(explainLabel)
        view.addSubview(collectionView)
        view.addSubview(nextBtn)
        
        NSLayoutConstraint.activate([
            
            explainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            explainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            explainLabel.heightAnchor.constraint(equalToConstant: 25),
            
            collectionView.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: 36),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nextBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -58),
            nextBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextBtn.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}


extension SelectStampViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        if let selectedCellIndexPath = selectedCellIndexPath {
            // 이전에 선택한 셀이 있다면 테두리 제거
            let previousSelectedCell = collectionView.cellForItem(at: selectedCellIndexPath)
            previousSelectedCell?.contentView.layer.borderWidth = 0
        }
        
        // 새로 선택한 셀의 테두리 추가
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.contentView.layer.borderColor = UIColor.primary02.cgColor
        selectedCell?.contentView.layer.borderWidth = 2
        
        // 선택한 셀의 인덱스를 저장
        selectedCellIndexPath = indexPath
        
        // nextBtn의 배경색 변경
        nextBtn.backgroundColor = .primary01
        nextBtn.setTitleColor(.gray, for: .highlighted)
        nextBtn.isEnabled = true
    }
}
