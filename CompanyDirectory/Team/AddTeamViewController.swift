//
//  AddTeamViewController.swift
//  CompanyDirectory
//
//  Created by 大林拓実 on 2021/02/21.
//

import UIKit

protocol AddTeamProtocol: class {
    func viewDidDismiss()
}

class AddTeamViewController: UIViewController {
    weak var delegate: AddTeamProtocol?
    let database = Database()
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    var isDirty: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    @IBAction func touchUpInsideSaveButton() {
        guard let name = nameTextField.text else { return }
        guard let description = descriptionTextView.text else { return }
        
        let newTeam = Team(name: name, description: description)
        newTeam.save()
        
        delegate?.viewDidDismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpInsideCancelButton() {
        if isDirty {
            let alertController = UIAlertController(title: "編集内容の破棄", message: "編集内容を破棄しますか？", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

extension AddTeamViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isDirty = true
    }
}

extension AddTeamViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        isDirty = true
    }
}
