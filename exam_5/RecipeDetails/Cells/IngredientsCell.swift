//
//  IngredientsCell.swift
//  exam_5
//
//  Created by Руслан Ахмадеев on 23.01.2021.
//

import UIKit

protocol IngredientsCellDelegate: UIViewController {
    func cellDidUpdate(ingredients: [String])
}

class IngredientsCell: UITableViewCell {
    private let ingredientHeight: CGFloat = 24

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableHeightConstraint: NSLayoutConstraint!
    
    
    private var ingredients: [String] = []
    
    private weak var delegate: IngredientsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        titleLabel.text = "Ингредиенты"
        
    }
    @IBAction func addButtonDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "add", message: "add", preferredStyle: .alert)
        let textField = UITextField()
        alert.addTextField(configurationHandler: nil)
        alert.addAction(.init(title: "ok", style: .default, handler: {[weak self] (action) in
            guard let text = alert.textFields?.first?.text else { return }
            self?.ingredients.append(text)
            
            self?.delegate?.cellDidUpdate(ingredients: self?.ingredients ?? [])
        }))
        
        delegate?.present(alert, animated: true, completion: nil)
        
    }
    
    func fillCell(ingredients: [String], delegate: IngredientsCellDelegate) {
        self.ingredients = ingredients
        self.delegate = delegate
        tableHeightConstraint.constant = CGFloat(ingredients.count) * ingredientHeight
    }
}

extension IngredientsCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = ingredients[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        cell?.textLabel?.text = name
        return cell ?? UITableViewCell()
    }
}
