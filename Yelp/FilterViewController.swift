//
//  FilterViewController.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/20/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var filterSettingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = YELP_RED
        navigationBar.tintColor = UIColor.whiteColor()
        
        cancelButton.target = self
        cancelButton.action = "cancelAction"
        filterSettingsTableView.dataSource = self
        filterSettingsTableView.delegate = self

        let switchCellNib = UINib(nibName: "SwitchTableViewCell", bundle: nil);
        filterSettingsTableView.registerNib(switchCellNib, forCellReuseIdentifier: "switchCell")
        
        let dropdownCellNib = UINib(nibName: "DropdownTableViewCell", bundle: nil);
        filterSettingsTableView.registerNib(dropdownCellNib, forCellReuseIdentifier: "dropdownCell")
        
        let checkboxCellNib = UINib(nibName: "CheckboxTableViewCell", bundle: nil);
        filterSettingsTableView.registerNib(checkboxCellNib, forCellReuseIdentifier: "checkboxCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSLog("Dismissing the filter view")
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        NSLog ("numberOfSectionsInTableView:\(FilterSettings.filterSections.count)")
        return FilterSettings.filterSections.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FilterSettings.filterSections[section].sectionName
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalRows = 0
        for option in FilterSettings.filterSections[section].optionsArray as [Option] {
            if option is OnOffOption {
                totalRows += 1
            }
            else if let singleSelection = option as? SingleSelectionOption {
                totalRows += singleSelection.expanded ? singleSelection.selectionValues.count : 1
            }
            else if let multipleSelection = option as? MultipleSelectionOption {
                totalRows += multipleSelection.expanded ? multipleSelection.selectionValues.count : 1
            }
        }
        return totalRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //NSLog ("cellForRowAtIndexPath")
        
        let option = FilterSettings.filterSections[indexPath.section].optionsArray[0]
        if let onOff = option as? OnOffOption  {
            let cell = filterSettingsTableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath) as SwitchTableViewCell
            cell.label.text = onOff.optionName
            cell.settingSwitch.setOn(onOff.onOffState, animated: false)
            return cell
        }
        else if let singleSelection = option as? SingleSelectionOption {
            if !singleSelection.expanded {
                let cell = filterSettingsTableView.dequeueReusableCellWithIdentifier("dropdownCell", forIndexPath: indexPath) as DropdownTableViewCell
                cell.optionLabel.text = "Option " + String(singleSelection.selectedValue)
                return cell
            }
            else {
                let cell = filterSettingsTableView.dequeueReusableCellWithIdentifier("checkboxCell", forIndexPath: indexPath) as CheckboxTableViewCell
                cell.highlighted = false
                cell.optionLabel.text = "Option " + String(singleSelection.selectionValues[indexPath.row])
                if singleSelection.selectedValue == indexPath.row {
                    cell.highlighted = true
                }
                return cell
            }
        }
        return UITableViewCell(style: .Default, reuseIdentifier: nil)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func getCellType(indexPath: NSIndexPath) -> CellType {
        
        let option = FilterSettings.filterSections[indexPath.section].optionsArray[0]
        if option is OnOffOption {
            return CellType.Switch
        }
        else if let singleSelection = option as? SingleSelectionOption {
            if singleSelection.expanded && singleSelection.selectedValue == indexPath.row {
                return CellType.CheckboxChecked
            }
            else if singleSelection.expanded {
                return CellType.CheckboxUnchecked
            }
            else {
                return CellType.Dropdown
            }
        }
        return CellType.Switch
    }
}
enum CellType {
    case Switch, Dropdown, CheckboxChecked, CheckboxUnchecked
}
