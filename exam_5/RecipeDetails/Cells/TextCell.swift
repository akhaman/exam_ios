//
//  TextCell.swift
//  exam_5
//
//  Created by Руслан Ахмадеев on 23.01.2021.
//

import UIKit

protocol TextCellDelegate: AnyObject {
    func textCellDidChangeText(_ text: String)
}

class TextCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    
    private weak var delegate: TextCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillCell(title: String, text: String, delegate: TextCellDelegate?, editing: Bool = false) {
        titleLabel.text = title
        textView.text = text
        textView.isEditable = editing
        self.delegate = delegate
    }
}

extension TextCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textCellDidChangeText(textView.text)
    }
}
