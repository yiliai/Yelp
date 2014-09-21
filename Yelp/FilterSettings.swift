//
//  FilterSettings.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/20/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

struct FilterSettings {
    
    static var filterSections = [FilterSection]()
    
    init() {
        // Add the deals section
        var dealsOption = OnOffOption(name: "Deals", onOff: false)
        var popularOptionsArray = [Option]()
        popularOptionsArray.append(dealsOption)
        var popularSection = FilterSection(name: "Most Popular", options: popularOptionsArray)
        FilterSettings.filterSections.append(popularSection)
        
        // Add the sort dropdown
        var sortOption = SingleSelectionOption(name: "Distance", selectionValues: SortOptions.allValues, selectedValue: SortOptions.BestMatched.toRaw(), expanded: false)
        var sortOptionsArray = [Option]()
        sortOptionsArray.append(sortOption)
        var sortSection = FilterSection(name: "Sort by", options: sortOptionsArray)
        FilterSettings.filterSections.append(sortSection)

        // Add the categories section
        //var categoriesOption = MultipleSelectionOption(name: "Categories", selectionValues: <#[Int]#>, selectedValues: <#[Int]#>, expanded: <#Bool#>)
    }
}

class FilterSection {
    var sectionName = ""
    var optionsArray = [Option]()
    
    init (name: String, options: [Option]) {
        self.sectionName = name
        optionsArray = options
    }
}

class Option {
    var optionName = ""
    init (name: String) {
        self.optionName = name
    }
}

class OnOffOption: Option {
    var onOffState: Bool
    
    init (name: String, onOff: Bool) {
        self.onOffState = onOff
        super.init(name: name)
    }
}

class SingleSelectionOption: Option {
    var selectionValues: [Int]
    var selectedValue: Int
    var expanded: Bool
    
    init (name: String, selectionValues: [Int], selectedValue: Int, expanded: Bool) {
        self.selectionValues = selectionValues
        self.selectedValue = selectedValue
        self.expanded = expanded
        super.init(name: name)
    }
}

class MultipleSelectionOption: Option {
    var selectionValues: [Int]
    var selectedValues: [Int]
    var expanded: Bool
    
    init (name: String, selectionValues: [Int], selectedValues: [Int], expanded: Bool) {
        self.selectionValues = selectionValues
        self.selectedValues = selectedValues
        self.expanded = expanded
        super.init(name: name)
    }
}

enum SortOptions: Int {
    case BestMatched = 0
    case Distance, HighestRated
    
    func simpleDescription() -> String {
        switch self {
        case .BestMatched:
            return "Best Matched"
        case .Distance:
            return "Distance"
        case .HighestRated:
            return "Highest Rated"
        default:
            return String(self.toRaw())
        }
    }
    static let allValues = [BestMatched.toRaw(), Distance.toRaw(), HighestRated.toRaw()]
}
enum DistanceOptions: Int {
    case Auto = 0
    case OneBlock, FiveBlocks, OneMile, FiveMiles
    
    func simpleDescription() -> String {
        switch self {
        case .Auto:
            return "Auto"
        case .OneBlock:
            return "1 Block"
        case .FiveBlocks:
            return "5 Blocks"
        case .OneMile:
            return "1 Miles"
        case .FiveMiles:
            return "5 Miles"
        default:
            return String(self.toRaw())
        }
    }
}
enum CategoryOptions: Int {
    case ActiveLife = 0
    case ArtsEntertainment, Automotive, BeautySpas, Bicycles, Education,EventPlanning, FinancialServices, Food, HealthMedical, HomeServices, HotelsTravel, MassMedia, Nightlife, Pets, Professional, PublicServices, RealEstate, Religious, Restaurants, Shopping
    func simpleDescription() -> String {
        switch self {
        case .ActiveLife:
            return "Active Life"
        case .ArtsEntertainment:
            return "Arts & Entertainment"
        case .Automotive:
            return "Automotive"
        case .BeautySpas:
            return "Beauty & Spas"
        case .Bicycles:
            return "Bicycles"
        default:
            return String(self.toRaw())
        }
    }
}