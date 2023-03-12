//
//  ReviewDiaryViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/12.
//

import UIKit

class ReviewDiaryViewController: UIViewController {

    @IBOutlet weak var diaryCollectionView: UICollectionView!
    
    
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    
    @IBOutlet weak var pageLabel: UILabel!
    
    var list = ["0","1","2","3","4","5","6","7","8","9"]
    
    
    @IBAction func didTapLeftBtn(_ sender: Any) {
        guard let currentIndexPath = diaryCollectionView.indexPathsForVisibleItems.first else { return }
            
        let previousIndexPath = IndexPath(item: currentIndexPath.item - 1, section: currentIndexPath.section)
        diaryCollectionView.scrollToItem(at: previousIndexPath, at: .centeredHorizontally, animated: true)
        
        pageLabel.text = "\(previousIndexPath.row + 1)/10"
    }
    
    
    @IBAction func didTapRightBtn(_ sender: Any) {
        guard let currentIndexPath = diaryCollectionView.indexPathsForVisibleItems.first else { return }
            
        let nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
        diaryCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        
        pageLabel.text = "\(nextIndexPath.row + 1)/10"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        diaryCollectionView.delegate = self
        diaryCollectionView.dataSource = self
        diaryCollectionView.decelerationRate = .fast
        diaryCollectionView.isPagingEnabled = false
        
        // Create a UICollectionViewFlowLayout object
        let flowLayoutFordiaryCollectionViewCell = UICollectionViewFlowLayout()
        
        
        flowLayoutFordiaryCollectionViewCell.scrollDirection = .horizontal
        flowLayoutFordiaryCollectionViewCell.minimumInteritemSpacing = 8 // Set the minimum spacing between cells to 0
        flowLayoutFordiaryCollectionViewCell.itemSize = CGSize(width: 393, height: 644)
        flowLayoutFordiaryCollectionViewCell.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        diaryCollectionView.collectionViewLayout = flowLayoutFordiaryCollectionViewCell
        
        leftBtn.addTarget(self, action: #selector(didTapLeftBtn(_:)), for: .touchUpInside)
        
        rightBtn.addTarget(self, action: #selector(didTapRightBtn(_:)), for: .touchUpInside)
    }
}

extension ReviewDiaryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: diaryCollectionView.contentOffset, size: diaryCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = diaryCollectionView.indexPathForItem(at: visiblePoint) else {
            return
        }
        
        let currentIndex = indexPath.row + 1
        let totalItems = diaryCollectionView.numberOfItems(inSection: 0)
        pageLabel.text = "\(currentIndex)/\(totalItems)"
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let layout = self.diaryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // CollectionView Item Size
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // 이동한 x좌표 값과 item의 크기를 비교 후 페이징 값 설정
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        
        
        // 스크롤 방향 체크
        // item 절반 사이즈 만큼 스크롤로 판단하여 올림, 내림 처리
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        // 위 코드를 통해 페이징 될 좌표 값을 targetContentOffset에 대입
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let collectionViewHeight = collectionView.frame.height
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCollectionViewCell", for: indexPath) as? DiaryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        print(indexPath.row)
        
        cell.dateLabel.text = list[indexPath.row]
        
        cell.dateView.layer.borderColor = UIColor(hex: 0xC1C1C1).cgColor
        
        cell.dateView.layer.borderWidth = 1
        
        cell.dateView.layer.cornerRadius = 8
        
        cell.diaryContentLabel.text = """
                                        오늘은 3월의 첫 시작이다.
                                        그래서 기분 좋게 아침을 맞이했다.
                                        그래서인지 너와의 데이트도
                                        아주 성공적이었다.

                                        맛있는 것도 먹고,
                                        재미있는 영화도 봤다.
                                        즐거웠다.
                                        
                                        오늘은 3월의 첫 시작이다.
                                        그래서 기분 좋게 아침을 맞이했다.
                                        그래서인지 너와의 데이트도
                                        아주 성공적이었다.

                                        맛있는 것도 먹고,
                                        재미있는 영화도 봤다.
                                        즐거웠다.
                                        
                                        """
        
        // Create a mutable attributed string from the label text
        let attributedString = NSMutableAttributedString(string: cell.diaryContentLabel.text!)

        // Set the line spacing to 10 points
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        // Set the attributed text of the label
        cell.diaryContentLabel.attributedText = attributedString
        
        return cell
    }
    
    
}

