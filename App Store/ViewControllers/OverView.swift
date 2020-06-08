//
//  OverView.swift
//  App Store
//
//  Created by sathish on 08/06/20.
//  Copyright © 2020 sathish. All rights reserved.
//

import UIKit
import AppstoreTransition
import SDWebImage

class OverView: UIViewController {
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var maintitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet var textview: UILabel!
    
    var item = APIItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        contentScrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        let _ = dismissHandler
        maintitleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        if let imgurl = URL(string: item.url) {
            backgroundImage.sd_setImage(with: imgurl, placeholderImage: nil, options: .refreshCached)
        }
        heightConstraint.constant = UIScreen.main.bounds.width * 1.272 - 16.0
        textview.text = item.content.htmlToString
        textview.textColor = .black
    }
    
    //MARK:- Actions
    @IBAction func CloseAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension OverView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // prevent bouncing when swiping down to close
        scrollView.bounces = scrollView.contentOffset.y > 100
        
        dismissHandler.scrollViewDidScroll(scrollView)
    }
    
}

extension OverView: CardDetailViewController {
    var scrollView: UIScrollView {
        return contentScrollView
    }
    
    var cardContentView: UIView {
        return headerView
    }
    
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
