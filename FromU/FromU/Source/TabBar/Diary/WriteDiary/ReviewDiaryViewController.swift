//
//  ReviewDiaryViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/12.
//

import UIKit

import Moya
import Alamofire
import SwiftKeychainWrapper

class ReviewDiaryViewController: UIViewController {

    @IBOutlet weak var diaryCollectionView: UICollectionView!
    
    
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBOutlet weak var pageLabel: UILabel!
    
    var DiaryIdList = GetDiaryListResponse(isSuccess: true, code: 0, message: "", result: [])
    
    var diaryBookID = 0
    
    var wholePage = 0
    
    var isFromLastBtn = false
    
    let header : HTTPHeaders = [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
    
    @IBAction func didTapLeftBtn(_ sender: Any) {
        guard let currentIndexPath = diaryCollectionView.indexPathsForVisibleItems.first else { return }
            
        let previousIndexPath = IndexPath(item: currentIndexPath.item - 1, section: currentIndexPath.section)
        
        if (previousIndexPath.row + 1) > 0{
            diaryCollectionView.scrollToItem(at: previousIndexPath, at: .centeredHorizontally, animated: true)
            
            pageLabel.text = "\(previousIndexPath.row + 1)/\(wholePage)"
        }
        
    }
    
    
    @IBAction func didTapRightBtn(_ sender: Any) {
        guard let currentIndexPath = diaryCollectionView.indexPathsForVisibleItems.first else { return }
            
        let nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
        
        if (nextIndexPath.row + 1) <= wholePage{
            diaryCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            
            pageLabel.text = "\(nextIndexPath.row + 1)/\(wholePage)"
        }
        
    }
    
    func scrollToLastItem() {
        let lastSection = diaryCollectionView.numberOfSections - 1
        
        // Check if the last section contains any items
        if lastSection >= 0 {
            let lastItemIndex = diaryCollectionView.numberOfItems(inSection: lastSection) - 1
            
            // Check if the last item index is valid
            if lastItemIndex >= 0 {
                let indexPath = IndexPath(item: lastItemIndex, section: lastSection)
                diaryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                pageLabel.text = "\(indexPath.row + 1)/\(indexPath.row + 1)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDiaryList()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFromLastBtn == true{
            isFromLastBtn = false
            scrollToLastItem()
        }
    }
}

extension ReviewDiaryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCollectionViewCell", for: indexPath) as? DiaryCollectionViewCell else { return UICollectionViewCell()}
            
        let url = "\(Constant.BASE_URL)/diaries/\(DiaryIdList.result?[indexPath.row] ?? 0)"

        print("url:", url)
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: GetDiaryResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("SUCCESS>> getDiaryInfo Response \(response) ")
                    
                    cell.update(with: response)
                    print(response)
                case .failure(let error):
                    print("DEBUG>> getDiaryInfo Error : \(error.localizedDescription)")
                                    
                }
            }
        
        return cell
    }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
        guard let layout = self.diaryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            
        // CollectionView Item Size
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            
        // Set the paging value after comparing the moved x-coordinate value with the item's size
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
            
        // Check scroll direction
        // Determine if the item is scrolling by half its size and process it up or down
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
            
        // Assign the coordinate value to be paged via the above code to targetContentOffset
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
        
        // Update pageLabel
        let currentIndex = index + 1
        let totalItems = diaryCollectionView.numberOfItems(inSection: 0)
        
        if currentIndex <= totalItems && currentIndex > 0 {
            pageLabel.text = "\(currentIndex)/\(totalItems)"
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let collectionViewHeight = collectionView.frame.height
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return DiaryIdList.result?.count ?? 1
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCollectionViewCell", for: indexPath) as? DiaryCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//
//        print(indexPath.row)
//
//        cell.dateLabel.text = list[indexPath.row]
//
//        cell.dateView.layer.borderColor = UIColor(hex: 0xC1C1C1).cgColor
//
//        cell.dateView.layer.borderWidth = 1
//
//        cell.dateView.layer.cornerRadius = 8
//
//        cell.diaryContentLabel.text = """
//                                        오늘은 3월의 첫 시작이다.
//                                        그래서 기분 좋게 아침을 맞이했다.
//                                        그래서인지 너와의 데이트도
//                                        아주 성공적이었다.
//
//                                        맛있는 것도 먹고,
//                                        재미있는 영화도 봤다.
//                                        즐거웠다.
//
//                                        오늘은 3월의 첫 시작이다.
//                                        그래서 기분 좋게 아침을 맞이했다.
//                                        그래서인지 너와의 데이트도
//                                        아주 성공적이었다.
//
//                                        맛있는 것도 먹고,
//                                        재미있는 영화도 봤다.
//                                        즐거웠다.
//
//                                        """
//
//        // Create a mutable attributed string from the label text
//        let attributedString = NSMutableAttributedString(string: cell.diaryContentLabel.text!)
//
//        // Set the line spacing to 10 points
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 8
//        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
//
//        // Set the attributed text of the label
//        cell.diaryContentLabel.attributedText = attributedString
//
//        return cell
//    }
}

extension ReviewDiaryViewController{
    
    func getDiaryList(){
        print("diaryBookID:", diaryBookID)
        DiaryAPI.providerDiary.request( .getDiaryList){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(GetDiaryListResponse.self)
                    
                    print(response)
                    
                    if response.isSuccess == true {
                        if response.code == 1000 {
                            self.DiaryIdList = response
                            
                            self.pageLabel.text = "1/\(response.result?.count ?? 0)"
                            self.wholePage = response.result?.count ?? 0
                            self.diaryCollectionView.reloadData()
                        }
                    }

                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> setMailBoxName Error : \(error.localizedDescription)")
            }
        }
    }
    
    func getDiaryInfo(diaryNum: Int){
        let url = "\(Constant.BASE_URL)/diaries/\(diaryNum)"

        let header : HTTPHeaders = [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: header).responseDecodable(of: GetDiaryResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("SUCCESS>> getDiaryInfo Response \(response) ")
                    

                case .failure(let error):
                    print("DEBUG>> getDiaryInfo Error : \(error.localizedDescription)")
                                    
                }
            }
        }
}

