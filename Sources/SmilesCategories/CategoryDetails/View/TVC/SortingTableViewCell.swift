//
//  SortingTableViewCell.swift
//  House
//
//  Created by Hannan on 27/09/2020.
//  Copyright © 2020 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesUtilities
import SmilesOffers
import UIKit

enum SortingChoice: Int {
    case SingleSelection
    case MultiSelection
}

class SortingTableViewCellModel {
    var title: String
    var mode: SortingChoice = .SingleSelection
    var isSelected = false
    var multiChoiceUpTo = 0
    var isSelectionMandatory = false
    var sortingModel: FilterDO?
    var bottomLineHidden = false
    
    init(title: String, mode: SortingChoice, isSelected: Bool, multiChoiceUpTo: Int, isSelectionMandatory: Bool, sortingModel: FilterDO, bottomLineHidden: Bool? = false) {
        self.title = title
        self.mode = mode
        self.isSelected = isSelected
        self.multiChoiceUpTo = multiChoiceUpTo
        self.isSelectionMandatory = isSelectionMandatory
        self.sortingModel = sortingModel
        self.bottomLineHidden = bottomLineHidden ?? false
    }
}

class MyFiltersTableViewCellModel {
    var title: String
    var type: String
    var mode: SortingChoice = .SingleSelection
    var isSelected = false
    var model: Any?
    var font: UIFont = .montserratRegularFont(size: 15)
    var color: UIColor = .appGreyColor_128
    var selectedFont: UIFont = .montserratSemiBoldFont(size: 15)
    
    init(title: String, type: String = "", mode: SortingChoice, isSelected: Bool, multiChoiceUpTo: Int, model: Any?,font: UIFont = .montserratRegularFont(size: 15), color: UIColor = .appGreyColor_128, selectedFont: UIFont = .montserratSemiBoldFont(size: 15)) {
        self.title = title
        self.type = type
        self.mode = mode
        self.isSelected = isSelected
        self.model = model
        self.font = font
        self.color = color
        self.selectedFont = selectedFont
    }
}

class SortingTableViewCell: SuperTableViewCell {
    var modelObject: SortingTableViewCellModel?
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .montserratMediumFont(size: 15.0)
        }
    }
    
    @IBOutlet var selectionImageView: UIImageView!
    @IBOutlet var bottomLineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? SortingTableViewCellModel {
            modelObject = model
            
            titleLabel.text = model.title
            
            if model.mode == .SingleSelection {
                selectionImageView.image = model.isSelected ? UIImage(named: "SingleSelectionSelected") : UIImage(named: "SingleSelectionUnSelected")
            } else {
                selectionImageView.image = model.isSelected ? UIImage(named: "MultiSelectionSelected") : UIImage(named: "MultiSelectionUnSelected")
            }
            
            bottomLineView.isHidden = model.bottomLineHidden
        }
        
        if let model = rowModel.rowValue as? MyFiltersTableViewCellModel {
            titleLabel.text = model.title
            titleLabel.textColor = model.color
            titleLabel.font = model.font
            
            if model.mode == .SingleSelection {
                selectionImageView.image = model.isSelected ? UIImage(named: "SingleSelectionSelected") : UIImage(named: "SingleSelectionUnSelected")
            } else {
                selectionImageView.image = model.isSelected ? UIImage(named: "MultiSelectionSelected") : UIImage(named: "MultiSelectionUnSelected")
            }
            
            if model.isSelected {
                titleLabel.font = model.selectedFont
            } else {
                titleLabel.font = model.font
            }
        }
    }
    
    static func rowModel(model: SortingTableViewCellModel?) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "SortingTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = model
        rowModel.isSelected = model?.isSelected ?? false
        return rowModel
    }
    
    static func rowModel(model: MyFiltersTableViewCellModel?) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "SortingTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = model
        rowModel.isSelected = model?.isSelected ?? false
        return rowModel
    }
}
