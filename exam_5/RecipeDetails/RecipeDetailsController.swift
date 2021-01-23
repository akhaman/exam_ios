//
//  RecipeDetailsController.swift
//  exam_5
//
//  Created by Руслан Ахмадеев on 23.01.2021.
//

import UIKit

class RecipeDetailsController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonDidTap))
//        button.isEnabled = false
        return button
    }()
    
    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonDidTap))
        return button
    }()
    
    let dataService: DataService
    
    private var initialRecipe: Recipe?
    private var updatedRecipe: Recipe?
    
    private var completion: ((Recipe) -> Void)?
    
    private var mode: Mode = .create
    private var isEditingNow: Bool = false {
        didSet {
            updateNavigationBar()
            tableView.reloadData()
        }
    }

    private enum Mode {
        case create
        case view
    }
    
    private var cellModels: [DetailRecipeCell] = []
    
    init(dataService: DataService) {
        self.dataService = dataService
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(dataService: DataService,
                     recipe: Recipe? = nil,
                     completion: @escaping (Recipe) -> Void) {
        self.init(dataService: dataService)
        self.initialRecipe = recipe
        self.completion = completion
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mode = (initialRecipe == nil) ? .create : .view
        isEditingNow = (mode == .create) ? true : false
        setupModels()
        setupTableView()
    }
    
    // MARK: - Actions
    
    private func setupModels() {
        
        updatedRecipe = self.updatedRecipe ?? initialRecipe ?? Recipe(name: "", ingredients: [], instruction: "")
        guard let updatedRecipe = updatedRecipe else {
            return
        }
        cellModels.removeAll()
        cellModels.append(.ingredients(text: updatedRecipe.ingredients))
        cellModels.append(.instruction(text: updatedRecipe.instruction))
    }
    
    private func setupTableView() {
        
        tableView.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: TextCell.description())
        tableView.register(UINib(nibName: "IngredientsCell", bundle: nil), forCellReuseIdentifier: IngredientsCell.description())
        tableView.reloadData()
    }
    
    private func updateNavigationBar() {
        switch mode {
        case .create:
            navigationItem.rightBarButtonItem = saveButton
        case .view:
            navigationItem.rightBarButtonItem = isEditingNow ? saveButton : editButton
        }
    }
    
    @objc private func saveButtonDidTap() {
        guard let recipe = updatedRecipe else { return }
        switch mode {
        case .create:
            dataService.createRecipe(recipe)
            completion?(recipe)
            navigationController?.popViewController(animated: true)
        case .view:
            dataService.updateRecipe(recipe)
            isEditingNow = false
            completion?(recipe)
        }
    }
    
    @objc private func editButtonDidTap() {
        isEditingNow = true
    }
}

extension RecipeDetailsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = cellModels[indexPath.row]
        
        let cell: UITableViewCell?
        
        switch model {
        case .ingredients(let ingredients):
            cell = tableView.dequeueReusableCell(withIdentifier: IngredientsCell.description())
            (cell as? IngredientsCell)?.fillCell(ingredients: ingredients, delegate: self)
        case .instruction(let text):
            cell = tableView.dequeueReusableCell(withIdentifier: TextCell.description())
            (cell as? TextCell)?.fillCell(title: "Инструкция", text: text, delegate: self, editing: isEditingNow)
        }
        
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
}

extension RecipeDetailsController: UITableViewDelegate {
    
}

extension RecipeDetailsController: IngredientsCellDelegate {
    func cellDidUpdate(ingredients: [String]) {
        updatedRecipe?.ingredients = ingredients
        setupModels()
        tableView.reloadData()
    }
}

extension RecipeDetailsController: TextCellDelegate {
    func textCellDidChangeText(_ text: String) {
        updatedRecipe?.instruction = text
        setupModels()
        tableView.reloadData()
    }
}

enum DetailRecipeCell {
    case ingredients(text: [String])
    case instruction(text: String)
}
