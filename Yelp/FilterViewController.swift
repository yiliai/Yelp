//
//  FilterViewController.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/20/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

let FOOTER_HEIGHT = CGFloat(30)
let ROW_HEIGHT = CGFloat(44)

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var filterNavigationItem: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var filterSettingsTableView: UITableView!

    var filterDelegate: FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = YELP_RED
        navigationBar.tintColor = UIColor.whiteColor()
        
        // Add the cancel button on the left
        let cancelButton = YelpButton(text: "Cancel")
        cancelButton.addTarget(self, action: "cancelAction", forControlEvents: UIControlEvents.TouchUpInside)
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        var negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -8;
        filterNavigationItem.setLeftBarButtonItems([negativeSpacer, cancelBarButton], animated: false)
        
        // Add the search button on the right
        let searchButton = YelpButton(text: "Search")
        searchButton.addTarget(self, action: "searchAction", forControlEvents: UIControlEvents.TouchDown)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        filterNavigationItem.setRightBarButtonItems([negativeSpacer, searchBarButton], animated: false)
        
        filterSettingsTableView.dataSource = self
        filterSettingsTableView.delegate = self

        let switchCellNib = UINib(nibName: "SwitchTableViewCell", bundle: nil);
        filterSettingsTableView.registerNib(switchCellNib, forCellReuseIdentifier: "switchCell")
        
        let dropdownCellNib = UINib(nibName: "DropdownTableViewCell", bundle: nil);
        filterSettingsTableView.registerNib(dropdownCellNib, forCellReuseIdentifier: "dropdownCell")
        
        let checkboxCellNib = UINib(nibName: "CheckboxTableViewCell", bundle: nil);
        filterSettingsTableView.registerNib(checkboxCellNib, forCellReuseIdentifier: "checkboxCell")
    }
    func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSLog("Dismissing the filter view")
            FilterSettings.cancel()
        })
    }
    func searchAction() {
        NSLog("Searching based on the filters...")
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSLog("Searching based on the filters...")
            FilterSettings.save()
            self.filterDelegate?.applyFilter()
        })
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //NSLog ("numberOfSectionsInTableView:\(FilterSettings.filterSections.count)")
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
                totalRows += singleSelection.expanded ? singleSelection.displayValues.count : 1
            }
            else if let multipleSelection = option as? MultipleSelectionOption {
                totalRows += multipleSelection.expanded ? multipleSelection.displayValues.count : 3
            }
        }
        //println("\(totalRows) ROWS IN SECTION \(section)")
        return totalRows
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ROW_HEIGHT
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let option = FilterSettings.filterSections[indexPath.section].optionsArray[0]
        if let onOff = option as? OnOffOption  {
            let cell = filterSettingsTableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath) as SwitchTableViewCell
            cell.label.text = onOff.name
            cell.settingSwitch.setOn(onOff.onOffState, animated: false)
            cell.indexPath = indexPath
            return cell
        }
        else if let singleSelection = option as? SingleSelectionOption {
            let cell = filterSettingsTableView.dequeueReusableCellWithIdentifier("checkboxCell", forIndexPath: indexPath) as CheckboxTableViewCell
            if !singleSelection.expanded {
                cell.optionLabel.text = singleSelection.displayValues[singleSelection.selected]
                cell.toggleState(CheckboxState.Collapsed)
            }
            else {
                cell.optionLabel.text = singleSelection.displayValues[indexPath.row]
                if singleSelection.selected == indexPath.row {
                    cell.toggleState(CheckboxState.Checked)
                }
                else {
                    cell.toggleState(CheckboxState.Unchecked)
                }
            }
            return cell
        }
        else if let multipleSelection = option as? MultipleSelectionOption {
            let cell = filterSettingsTableView.dequeueReusableCellWithIdentifier("checkboxCell", forIndexPath: indexPath) as CheckboxTableViewCell
            cell.optionLabel.text = multipleSelection.displayValues[indexPath.row]
            multipleSelection.selectedValues.containsIndex(indexPath.row) ? cell.toggleState(CheckboxState.Checked) : cell.toggleState(CheckboxState.Unchecked)
            return cell
        }
        return UITableViewCell(style: .Default, reuseIdentifier: nil)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let option = FilterSettings.filterSections[section].optionsArray[0]
        if let multipleSelection = option as? MultipleSelectionOption {
            if multipleSelection.expanded {
                return nil
            }
            var footerView = UIView()
            footerView.frame = CGRectMake(0, 0, tableView.frame.width, 30)
            let button = UIButton(frame: footerView.bounds)
            button.setTitle("See All", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            button.layer.backgroundColor = UIColor.whiteColor().CGColor
            footerView.addSubview(button)
            button.tag = section
            button.addTarget(self, action: "tapOnSeeAll:", forControlEvents: UIControlEvents.TouchUpInside)
            return footerView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let option = FilterSettings.filterSections[section].optionsArray[0]
        if let multipleSelection = option as? MultipleSelectionOption {
            return multipleSelection.expanded == false ? FOOTER_HEIGHT : 0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let option = FilterSettings.filterSections[indexPath.section].optionsArray[0]
        if let singleSelection = option as? SingleSelectionOption {
            var indexPathArray = [NSIndexPath]()
            for i in 0...singleSelection.displayValues.count-1 {
                let newIndexPath = NSIndexPath(forRow: i, inSection: indexPath.section)
                indexPathArray.append(newIndexPath)
            }
            if !singleSelection.expanded {
                //println("ADD NEW ROWS: \(indexPathArray.count)")
                singleSelection.expanded = true
                filterSettingsTableView.beginUpdates()
                filterSettingsTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow:0, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
                filterSettingsTableView.insertRowsAtIndexPaths(indexPathArray, withRowAnimation: UITableViewRowAnimation.Top)
                filterSettingsTableView.endUpdates()
            }
            else {
                singleSelection.expanded = false
                singleSelection.selected = indexPath.row
                //println("DELETING...\(indexPathArray.count) rows")
                filterSettingsTableView.beginUpdates()
                filterSettingsTableView.deleteRowsAtIndexPaths(indexPathArray, withRowAnimation: UITableViewRowAnimation.Middle)
                filterSettingsTableView.insertRowsAtIndexPaths([NSIndexPath(forRow:0, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
                filterSettingsTableView.endUpdates()
            }
        }
        else if let multipleSelection = option as? MultipleSelectionOption {
            //println("MULTISELECT")
            multipleSelection.selectedValues.containsIndex(indexPath.row) ? multipleSelection.selectedValues.removeIndex(indexPath.row) : multipleSelection.selectedValues.addIndex(indexPath.row)
            filterSettingsTableView.beginUpdates()
            filterSettingsTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            filterSettingsTableView.endUpdates()
        }
    }
    
    func tapOnSeeAll(sender: AnyObject?) {
        let section = (sender as UIButton).tag
        let option = FilterSettings.filterSections[section].optionsArray[0]

        if let multipleSelection = option as? MultipleSelectionOption {
            var indexPathArray = [NSIndexPath]()
            for i in 3...multipleSelection.displayValues.count-1 {
                let newIndexPath = NSIndexPath(forRow: i, inSection: section)
                indexPathArray.append(newIndexPath)
            }
            multipleSelection.expanded = true
            filterSettingsTableView.beginUpdates()
            filterSettingsTableView.insertRowsAtIndexPaths(indexPathArray, withRowAnimation: UITableViewRowAnimation.Top)
            filterSettingsTableView.endUpdates()
        
        }
    }
}