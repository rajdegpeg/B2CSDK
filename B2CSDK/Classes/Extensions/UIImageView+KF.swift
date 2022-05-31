//
//  UIImageView+KF.swift
//  B2CSDK
//
//  Created by Raj Kadam on 31/05/22.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setKFImage(imageString: String, cornerRadius: CGFloat = 0) {
        let url = URL(string: imageString)
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: ImageConstants.placeholderImage),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
