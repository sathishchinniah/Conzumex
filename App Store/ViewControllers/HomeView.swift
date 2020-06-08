//
//  HomeView.swift
//  App Store
//
//  Created by sathish on 08/06/20.
//  Copyright © 2020 sathish. All rights reserved.
//

import UIKit
import AppstoreTransition
import SDWebImage

class HomeView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    private var transition: CardTransition?
    var isLoadingRequired = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: CARD_CELL, bundle: Bundle.main), forCellWithReuseIdentifier: CARD_CELL)
        
        let layout = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        let aspect: CGFloat = 1.272
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width:width, height: width * aspect)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isLoadingRequired {
            isLoadingRequired = false
            self.loader.startAnimating()
            APIModel.shared.process { (model) in
                self.loader.stopAnimating()
                self.collectionView.reloadData()
            }
        }
        
    }
}

//MARK:- DataSource

extension HomeView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return APIModel.shared.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CARD_CELL, for: indexPath) as! CardCell
        let item = APIModel.shared.list[indexPath.item]
        cell.maintitleLabel.text = item.title
        cell.subtitleLabel.text = item.subtitle
        if let imgurl = URL(string: item.url) {
            cell.backgroundImage.sd_setImage(with: imgurl, placeholderImage: nil, options: .refreshCached)
        }
        return cell
    }
    
}

//MARK:- Delegate

extension HomeView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: OVER_VIEW) as! OverView
        
        // Get tapped cell location
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        cell.settings.cardContainerInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        cell.settings.isEnabledBottomClose = true
        
        transition = CardTransition(cell: cell, settings: cell.settings)
        viewController.settings = cell.settings
        viewController.transitioningDelegate = transition
        
        let item = APIModel.shared.list[indexPath.item]
        viewController.item = item
        
        // If `modalPresentationStyle` is not `.fullScreen`, this should be set to true to make status bar depends on presented vc.
        //viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.modalPresentationStyle = .custom
        
        presentExpansion(viewController, cell: cell, animated: true)
    }
  
}

extension HomeView: CardsViewController {
    
}
