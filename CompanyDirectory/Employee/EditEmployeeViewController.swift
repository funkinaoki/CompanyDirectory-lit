//
//  AddEmployeeViewController.swift
//  CompanyDirectory
//
//  Created by 藤井陽介 on 2021/02/20.
//

import UIKit

protocol EditEmployeeProtocol {
    func viewDidDismiss()
}

class EditEmployeeViewController: UIViewController {
    var delegate: EditEmployeeProtocol?
    let database = Database()

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contactAddressTextField: UITextField!
    @IBOutlet var statusSwitch: UISwitch!
    @IBOutlet var teamTextField: UITextField!
    @IBOutlet var teamPickerView: UIPickerView!

    var isDirty: Bool = false
    var selectedTeam: Team?
    var employee: Employee?

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        contactAddressTextField.delegate = self
        teamTextField.delegate = self
        teamPickerView.delegate = self

        initUI(employee)
    }

    func initUI(_ employee: Employee?) {
        if let employee = employee {
            nameTextField.text = employee.name
            contactAddressTextField.text = employee.contactAddress
            selectedTeam = database.teams.first(where: { $0.id == employee.teamID})
            teamTextField.text = selectedTeam?.name
            statusSwitch.setOn(employee.isOnline, animated: false)
        }
    }

    @IBAction func valueChangedStatusSwitch(_ sender: Any) {
        isDirty = true
    }

    @IBAction func touchUpInsideSaveButton() {
        guard let name = nameTextField.text else { return }
        guard let contactAddress = contactAddressTextField.text else { return }
        let status = statusSwitch.isOn

        let updateEmployee = Employee(id: employee?.id ?? UUID(), name: name, isOnline: status, contactAddress: contactAddress, teamID: selectedTeam?.id)
        updateEmployee.save()

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

extension EditEmployeeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return database.teams.count + 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row != database.teams.count {
            return database.teams[row].name
        } else {
            return "なし"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != database.teams.count {
            selectedTeam = database.teams[row]
        } else {
            selectedTeam = nil
        }
        
        teamTextField.text = selectedTeam?.name ?? "なし"
        isDirty = true
    }

}

extension EditEmployeeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isDirty = true
    }
}
