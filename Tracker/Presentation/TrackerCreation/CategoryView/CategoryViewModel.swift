//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 29.12.2024.
//

import Foundation

protocol CategoryViewModelProtocol {
    var categoriesDidChange: Binding<[TrackerCategory]>? { get set }
    
    func loadCategories()
    func getCategoriesCount() -> Int
    func addCategory(_ newCategory: TrackerCategory)
    func getCategoryTitle(at indexPath: IndexPath) -> String?
    func getSelectedCategoryTitle() -> String? 
    func saveLastSelectedCategoryTitle(_ title: String?)
    func shouldShowPlaceholder() -> Bool
}

final class CategoryViewModel: CategoryViewModelProtocol {
    
    // MARK: - Public Properties
    
    var categoriesDidChange: Binding<[TrackerCategory]>?
    
    // MARK: - Private Properties
    
    private let trackerStorage = TrackerStorageService.shared
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            categoriesDidChange?(categories)
        }
    }
    
    // MARK: - Public Methods
    
    func loadCategories() {
        categories = trackerStorage.getCategories()
    }
    
    func getCategoriesCount() -> Int {
        categories.count
    }
    
    func addCategory(_ newCategory: TrackerCategory) {
        trackerStorage.createCategory(newCategory)
        loadCategories()
    }
    
    func getCategoryTitle(at indexPath: IndexPath) -> String? {
        guard indexPath.row < categories.count else { return nil }
        return categories[indexPath.row].title
    }
    
    func getSelectedCategoryTitle() -> String? {
        AppStateManager.shared.lastSelectedCategory
    }
    
    func saveLastSelectedCategoryTitle(_ title: String?) {
        AppStateManager.shared.lastSelectedCategory = title
    }
    
    func shouldShowPlaceholder() -> Bool {
        categories.isEmpty
    }
}

