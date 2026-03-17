//
//  HelperOnboardingViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 17.03.2026.
//

import UIKit
import SnapKit

protocol IHelperOnboardingView: AnyObject {
    
    var presenter: IHelperOnboardingPresenter? { get set }
}


final class HelperOnboardingViewController: UIViewController, IHelperOnboardingView {
    
    var presenter: IHelperOnboardingPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidload()
    }
}
