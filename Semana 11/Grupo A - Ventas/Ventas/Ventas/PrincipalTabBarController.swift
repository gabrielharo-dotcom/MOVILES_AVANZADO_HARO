//
//  PrincipalTabBarController.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit

class PrincipalTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let pestanas = Sesion.shared.esSupervisor ? [1, 2, 3, 4, 7] : [3, 4, 5, 6, 7]
        viewControllers = (viewControllers ?? []).filter { pestanas.contains($0.tabBarItem.tag) }
    }
}
