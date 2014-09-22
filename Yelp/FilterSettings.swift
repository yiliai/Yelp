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
    static var filterSectionsSaved = [FilterSection]()

    init() {
        // Add the deals section
        var dealsOption = OnOffOption(name: "Deals", key: "deals_filter", onOff: false)
        var popularOptionsArray = [Option]()
        popularOptionsArray.append(dealsOption)
        var popularSection = FilterSection(name: "Most Popular", options: popularOptionsArray)
        FilterSettings.filterSections.append(popularSection)
        
        // Add the sort dropdown
        var sortOption = SingleSelectionOption(name: "Sort", key: SortOptions.key, queryValues: SortOptions.queryValues, displayValues: SortOptions.allValues, selected: SortOptions.BestMatched.toRaw(), expanded: false)
        var sortSection = FilterSection(name: "Sort by", options: [sortOption])
        FilterSettings.filterSections.append(sortSection)

        // Add the distance dropdown
        var distanceOption = SingleSelectionOption(name: "Distance", key: DistanceOptions.key, queryValues: DistanceOptions.queryValues, displayValues: DistanceOptions.allValues, selected: DistanceOptions.Auto.toRaw(), expanded: false)
        var distanceSection = FilterSection(name: "Distance", options: [distanceOption])
        FilterSettings.filterSections.append(distanceSection)

        // Add the categories section
        var categoriesOption = MultipleSelectionOption(name: "Categories", key: CategoryOptions.key, queryValues: CategoryOptions.queryValues, displayValues: CategoryOptions.allValues, selectedValues: [], expanded: false)
        var categorySection = FilterSection(name: "Categories", options: [categoriesOption])
        FilterSettings.filterSections.append(categorySection)
        
        FilterSettings.save()
    }
    static func save() {
        FilterSettings.filterSectionsSaved.removeAll(keepCapacity: true)
        for section in FilterSettings.filterSections {
            let newSection = FilterSection(section: section)
            FilterSettings.filterSectionsSaved.append(newSection)
        }
    }
    static func cancel() {
        FilterSettings.filterSections.removeAll(keepCapacity: true)
        for section in FilterSettings.filterSectionsSaved {
            let newSection = FilterSection(section: section)
            FilterSettings.filterSections.append(newSection)
        }
    }
    static func getParameters() -> NSDictionary {
        var parameters = NSMutableDictionary()
        for section in FilterSettings.filterSections {
            parameters.addEntriesFromDictionary(section.getParameters())
        }
        return parameters
    }
}

class FilterSection {
    var sectionName = ""
    var optionsArray = [Option]()
    
    init (name: String, options: [Option]) {
        self.sectionName = name
        optionsArray = options
    }
    init (section: FilterSection) {
        for option in section.optionsArray {
            if let onOffOption = option as? OnOffOption {
                optionsArray.append(OnOffOption(option: onOffOption))
            }
            else if let singleSelection = option as? SingleSelectionOption {
                optionsArray.append(SingleSelectionOption(option:singleSelection))
            }
            else if let multipleSelection = option as? MultipleSelectionOption {
                optionsArray.append(MultipleSelectionOption(option:multipleSelection))
            }
        }
        self.sectionName = section.sectionName
    }
    func getParameters() -> NSDictionary {
        //var query =
        var parameters = NSMutableDictionary()
        for option in optionsArray {
            let optionParameters = option.getParameters()
            parameters.addEntriesFromDictionary(optionParameters)
        }
        return parameters
    }
}

protocol Option {
    func getParameters() -> NSDictionary
}

class OnOffOption: Option {
    var onOffState: Bool
    var name = ""
    var key = ""
    init (name: String, key: String, onOff: Bool) {
        self.name = name
        self.key = key
        self.onOffState = onOff
    }
    init (option: OnOffOption) {
        self.name = option.name
        self.key = option.key
        self.onOffState = option.onOffState
    }
    func getParameters() -> NSDictionary {
        var parameter = Dictionary<String,Bool>()
        if onOffState {
            parameter[key] = onOffState
        }
        return parameter
    }
}

class SingleSelectionOption: Option {
    var name = ""
    var key = ""
    var queryValues: [Int]
    var displayValues: [String]
    var selected: Int
    var expanded: Bool
    
    init (name: String, key: String, queryValues: [Int], displayValues: [String], selected: Int, expanded: Bool) {
        self.name = name
        self.key = key
        self.queryValues = queryValues
        self.displayValues = displayValues
        self.selected = selected
        self.expanded = expanded
    }
    init (option: SingleSelectionOption) {
        self.name = option.name
        self.key = option.key
        self.queryValues = option.queryValues
        self.selected = option.selected
        self.displayValues = option.displayValues
        self.expanded = option.expanded
    }
    func getParameters() -> NSDictionary {
        var parameter = Dictionary<String,Int>()
        parameter[key] = queryValues[selected]
        return parameter
    }
}

class MultipleSelectionOption: Option {
    var name = ""
    var key = ""
    var queryValues: [String]
    var displayValues: [String]
    var selectedValues: NSMutableIndexSet
    var expanded: Bool
    
    init (name: String, key: String, queryValues: [String], displayValues: [String], selectedValues: [Int], expanded: Bool) {
        self.name = name
        self.key = key
        self.queryValues = queryValues
        self.displayValues = displayValues
        self.selectedValues = NSMutableIndexSet()
        for value in selectedValues {
            self.selectedValues.addIndex(value)
        }
        self.expanded = expanded
    }
    init (option: MultipleSelectionOption) {
        self.name = option.name
        self.key = option.key
        self.queryValues = option.queryValues
        self.displayValues = option.displayValues
        self.selectedValues = NSMutableIndexSet()
        
        var index = option.selectedValues.firstIndex
        while (index != NSNotFound) {
            self.selectedValues.addIndex(index)
            index = option.selectedValues.indexGreaterThanIndex(index)
        }
        self.expanded = option.expanded
    }
    func getParameters() -> NSDictionary {
        var parameter = Dictionary<String,String>()
        var query: String?
        if (selectedValues.count == 0) {
            return parameter
        }
        var index = self.selectedValues.firstIndex
        while (index != NSNotFound) {
            if query == nil {
                query = queryValues[index]
            }
            else {
                query = query! + "," + queryValues[index]
            }
            index = self.selectedValues.indexGreaterThanIndex(index)
        }
        parameter[key] = query
        return parameter
    }
}

enum SortOptions: Int {
    case BestMatched = 0
    case Distance, HighestRated
    
    func description() -> String {
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
    static let allValues = [BestMatched.description(), Distance.description(), HighestRated.description()]
    static var key: String {
        get {
            return "sort"
        }
    }
    static var queryValues: [Int] {
        get {
            var array = [Int]()
            for i in 0...2 {
                array.append(i)
            }
            return array
        }
    }
}
enum DistanceOptions: Int {
    case Auto = 0
    case OneBlock, FiveBlocks, OneMile, FiveMiles
    
    func description() -> String {
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
    func queryValue() -> Int {
        switch self {
        case .Auto:
            return 0
        case .OneBlock:
            return 100
        case .FiveBlocks:
            return 500
        case .OneMile:
            return 1600
        case .FiveMiles:
            return 8000
        default:
            return self.toRaw()
        }
    }
    static var allValues: [String] {
        get {
            var array = [String]()
            for i in 0...4 {
                array.append(DistanceOptions.fromRaw(i)!.description())
            }
            return array
        }
    }
    static var queryValues: [Int] {
        get {
            var array = [Int]()
            for i in 0...4 {
                array.append(DistanceOptions.fromRaw(i)!.queryValue())
            }
            return array
        }
    }
    static var key: String {
        get {
            return "radius"
        }
    }
}
enum CategoryOptions: Int {
    case ActiveLife = 0
    case ArtsEntertainment, Automotive, BeautySpas, Bicycles, Education, EventPlanning, FinancialServices, Food, HealthMedical, HomeServices, HotelsTravel, MassMedia, Nightlife, Pets, Professional, PublicServices, RealEstate, Religious, Restaurants, Shopping
    func description() -> String {
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
        case .Education:
            return "Education"
        case .EventPlanning:
            return "Event Planning"
        case .FinancialServices:
            return "Financial Services"
        case .Food:
            return "Food"
        case .HealthMedical:
            return "Health & Medical"
        case .HomeServices:
            return "Home Services"
        case .HotelsTravel:
            return "Hotels & Travel"
        case .MassMedia:
            return "Mass Media"
        case .Nightlife:
            return "Nightlife"
        case .Pets:
            return "Pets"
        case .Professional:
            return "Professional Services"
        case .PublicServices:
            return "Public Services"
        case .RealEstate:
            return "Real Estate"
        case .Religious:
            return "Religious Organizations"
        case .Restaurants:
            return "Restaurants"
        case .Shopping:
            return "Shopping"
        default:
            return String(self.toRaw())
        }
    }
    func queryValue() -> String {
        switch self {
        case .ActiveLife:
            return "active"
        case .ArtsEntertainment:
            return "arts"
        case .Automotive:
            return "auto"
        case .BeautySpas:
            return "beautysvc"
        case .Bicycles:
            return "bicycles"
        case .Education:
            return "education"
        case .EventPlanning:
            return "eventservices"
        case .FinancialServices:
            return "financialservices"
        case .Food:
            return "food"
        case .HealthMedical:
            return "health"
        case .HomeServices:
            return "homeservices"
        case .HotelsTravel:
            return "hotelstravel"
        case .MassMedia:
            return "massmedia"
        case .Nightlife:
            return "nightlife"
        case .Pets:
            return "pets"
        case .Professional:
            return "professional"
        case .PublicServices:
            return "publicservicesgovt"
        case .RealEstate:
            return "realestate"
        case .Religious:
            return "religiousorgs"
        case .Restaurants:
            return "restaurants"
        case .Shopping:
            return "shopping"
        default:
            return String(self.toRaw())
        }
    }
    static var allValues: [String] {
        get {
            var array = [String]()
            for i in 0...20 {
                array.append(CategoryOptions.fromRaw(i)!.description())
            }
            return array
        }
    }
    static var key: String {
        get {
            return "category_filter"
        }
    }
    static var queryValues: [String] {
        get {
            var array = [String]()
            for i in 0...20 {
                array.append(CategoryOptions.fromRaw(i)!.queryValue())
            }
            return array
        }
    }

}