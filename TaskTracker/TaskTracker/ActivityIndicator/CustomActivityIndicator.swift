//
//  CustomActivityIndicator.swift
//  TaskTracker
//
//  Created by Harsha on 11/01/21.
//

// Using Lottie Animations for Activity Indicator https://lottiefiles.com

import Foundation
import UIKit
import Lottie

class CustomActivityIndicator: UIView {
    
    static let instance = CustomActivityIndicator()
    let topAnimationView = AnimationView(name: "Loader")
    
    var viewColor: UIColor = .black
    var setAlpha: CGFloat = 0.3
    
    var transparentView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    func returnTransparentView(transparentView: UIView) -> UIView {
            transparentView.backgroundColor = viewColor.withAlphaComponent(setAlpha)
            transparentView.isUserInteractionEnabled = false
            topAnimationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            topAnimationView.center = transparentView.center
            topAnimationView.contentMode = .scaleAspectFill
            transparentView.addSubview(topAnimationView)
                transparentView.addSubview(self.topAnimationView)
            topAnimationView.animationSpeed = 1.0
            topAnimationView.loopMode = .loop
            
            topAnimationView.play()
            return transparentView
        }
    
    func showLoaderView(vc: UIViewController) {
        vc.view.addSubview(returnTransparentView(transparentView: transparentView))
        vc.view.bringSubviewToFront(transparentView)
        vc.view.isUserInteractionEnabled = false
    }
    
    func hideLoaderView(vc: UIViewController) {
        vc.navigationController?.isNavigationBarHidden = false
        for view in vc.view.subviews {
            if view == transparentView {
                view.removeFromSuperview()
            }
        }
        vc.view.isUserInteractionEnabled = true
    }
    
    func showLoaderView() {
        transparentView = returnTransparentView(transparentView: transparentView)
        UIApplication.shared.keyWindow?.addSubview(transparentView)
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
    }

    func hideLoaderView() {
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        self.transparentView.removeFromSuperview()
    }
}
