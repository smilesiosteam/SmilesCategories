//
//  SmilesCoordinatorBoard.swift
//  House
//
//  Created by Hanan Ahmed on 11/11/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import UIKit

protocol SmilesCoordinatorBoard : UIViewController {

    static func instantiateFromStoryBoard(withStoryBoard name:String) -> Self

}

extension SmilesCoordinatorBoard {

    static func instantiateFromStoryBoard(withStoryBoard name:String) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        let id = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
