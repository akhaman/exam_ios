//
//  RecipeListController.swift
//  exam_5
//
//  Created by Руслан Ахмадеев on 23.01.2021.
//

import UIKit

class RecipeListController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
   
    let dataService: DataService
    private var recipes: [Recipe] = []

    init(dataService: DataService) {
        self.dataService = dataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        recipes = dataService.getRecipes()
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Список рецептов"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(showAddRecipeScreen))
    }
    
    @objc private func showAddRecipeScreen() {
        let controller = RecipeDetailsController(dataService: dataService) { [weak self] recipe in
            guard let self = self else { return }
            self.recipes.append(recipe)
            self.tableView.reloadRows(at: [.init(row: self.recipes.count - 1, section: 0)], with: .automatic)
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showUpdateRecipeScreen(_ recipe: Recipe) {
        let controller = RecipeDetailsController(dataService: dataService,
                                                 recipe: recipe) { [weak self] recipe in
            guard let index = self?.recipes.firstIndex(where: {$0.id == recipe.id}) else { return }
            self?.tableView.reloadRows(at: [.init(row: index, section: 0)], with: .automatic)
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension RecipeListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        cell?.accessoryType = .disclosureIndicator
        let recipe = recipes[indexPath.row]
        cell?.textLabel?.text = recipe.name
        return cell ?? UITableViewCell()
    }
}

extension RecipeListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipe = recipes[indexPath.row]
        showUpdateRecipeScreen(recipe)
    }
}
