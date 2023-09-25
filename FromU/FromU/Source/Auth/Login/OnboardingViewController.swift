//
//  OnboardingViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/19.
//

import UIKit

import AdvancedPageControl

class OnboardingViewController: UIViewController,
                                UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var pageControl: AdvancedPageControlView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var onboardingTextList = ["연인과 서로의 일상을 공유하는\n교환일기를 작성해볼까?", "일기가 쌓이면 우리만의 일기장을\n실제로 배송받을 수 있어!", "우리의 이야기를 편지를 통해\n다른 커플과 공유도 해볼 수 있어!"]
    
    
    @IBAction func didTapNextBtn(_ sender: Any) {
    let currentVisibleIndex = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        let nextIndex = currentVisibleIndex + 1

        if nextIndex < onboardingTextList.count {
            let indexPath = IndexPath(item: nextIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            // This is the last page, you can navigate to another view controller or perform any desired action.
        }
    }
    
    @IBAction func didTapStartBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        
        startBtn.layer.cornerRadius = 8
        
        startBtn.isHidden = true
        
        let flowLayoutFordiaryCollectionViewCell = UICollectionViewFlowLayout()
        
        flowLayoutFordiaryCollectionViewCell.scrollDirection = .horizontal
        flowLayoutFordiaryCollectionViewCell.minimumInteritemSpacing = 0 // Set the minimum spacing between cells to 0
        flowLayoutFordiaryCollectionViewCell.itemSize = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        flowLayoutFordiaryCollectionViewCell.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = flowLayoutFordiaryCollectionViewCell
        
        
        pageControl.drawer = ExtendedDotDrawer(numberOfPages: 3,
                                               height: 8,
                                               width: 8,
                                               space: 8,
                                               raduis: 8,
                                               currentItem: 0,
                                               indicatorColor: .primary01,
                                               dotsColor: .primaryLight)
        pageControl.drawer.numberOfPages = 3
        pageControl.drawer.size = 8

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 1
      }
      
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return 3
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell()}
                        
          cell.explainLabel.text = onboardingTextList[indexPath.row]
          cell.explainLabel.font = .BalsamTint(.size22)
          cell.onboardingImg.image = UIImage(named: "onboarding\(indexPath.row + 1)")
          
          
          return cell
          
        
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let collectionViewHeight = collectionView.frame.height
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
      
     
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            
        // CollectionView Item Size
        let cellWidthIncludingSpacing = self.view.frame.width + layout.minimumLineSpacing
     
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

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
          
        if offSet/width <= 1.5 {
            nextBtn.isHidden = false
            startBtn.isHidden = true
        }
        else{
            nextBtn.isHidden = true
            startBtn.isHidden = false
        }
        
        pageControl.setPageOffset(offSet/width)
    

      }

}
