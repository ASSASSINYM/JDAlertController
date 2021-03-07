//
//  NavigationController.swift
//  JDNavigationController
//
//  Created by Jawad Ali on 26/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public class JDNavigationController: UINavigationController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    public var jDnavigationBar: JDNavigationBar? {
        get {
           return (self.navigationBar as? JDNavigationBar)
        }
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let label = UILabel(frame: jDnavigationBar?.bounds ?? .zero)
        label.text = jDnavigationBar?.topItem?.title
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 19)
        
        jDnavigationBar?.topItem?.titleView = label
        jDnavigationBar?.addStyle()
        if #available(iOS 11.0, *) {
            self.topViewController?.additionalSafeAreaInsets.top = ((self.navigationBar as? JDNavigationBar)?.heightShape ) ?? 0 + 20
        } else {
            // Fallback on earlier versions1
        }
    }

}
extension JDNavigationController: UINavigationControllerDelegate {

    /// Just   ` back button` without `text `
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
    }

}
