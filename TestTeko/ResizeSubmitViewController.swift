//
//  File.swift
//  TestTeko
//
//  Created by ERT_Macbook_123 on 10/30/22.
//

import Foundation
import UIKit

class ResizeSubmitViewController: UIPresentationController {
    let blurEffectView: UIVisualEffectView
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    @objc
    func dismiss() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        blurEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismiss)))
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(
            origin: CGPoint(x: (containerView?.frame.width ?? 0) * 0.075,
                            y: (containerView?.frame.height ?? 0) * 0.15),
            size: CGSize(width: (containerView?.frame.width ?? 0) * 0.85,
                         height: (containerView?.frame.height ?? 0) * 0.7)
        )
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.blurEffectView.alpha = 0
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func presentationTransitionWillBegin() {
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.blurEffectView.alpha = 0.7
        }, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.layer.masksToBounds = true
        presentedView?.layer.cornerRadius = 10
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView?.bounds ?? CGRect()
    }
}
