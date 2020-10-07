//
//  DismissGuardianUIHostingController.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-30.
//

import SwiftUI
import Foundation

class DismissGuardianUIHostingController<Content>: UIHostingController<Content>, UIAdaptivePresentationControllerDelegate where Content: View {
    var preventDismissal: Bool
    var dismissGuardianDelegate: DismissGuardianDelegate?

    init(rootView: Content, preventDismissal: Bool) {
        self.preventDismissal = preventDismissal
        super.init(rootView: rootView)
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.presentationController?.delegate = self

        self.dismissGuardianDelegate?.attemptedUpdate(flag: false)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.dismissGuardianDelegate?.attemptedUpdate(flag: true)
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return !self.preventDismissal
    }
}

protocol DismissGuardianDelegate {
    func attemptedUpdate(flag: Bool)
}
