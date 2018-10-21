//
//  ViewController.swift
//  TFS-chat
//
//  Created by Evgeniy on 23/09/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class ProfileController: UIViewController {
    // MARK: - Outlets

    @IBOutlet
    private var avatarImageView: UIImageView!

    @IBOutlet
    private var changeAvatarButton: UIButton!

    @IBOutlet
    private var editButton: UIButton!

    @IBOutlet
    private var nameLabel: UILabel!

    @IBOutlet
    private var aboutYouLabel: UILabel!

    @IBOutlet
    private var nameTextField: UITextField!

    @IBOutlet
    private var aboutYouPlaceholderLabel: UILabel!

    @IBOutlet
    private var aboutYouTextView: UITextView!

    @IBOutlet
    private var gcdButton: UIButton!

    @IBOutlet
    private var operationButton: UIButton!

    // MARK: - Members

    private let viewModel:
        ProfileControllerViewModel = ProfileControllerViewModelImp()

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        setupModule()
        setupEditButton()
    }

    // MARK: - Methods

    private func setupModule() {
        setupViewModel()
        nameTextField.delegate = self
        aboutYouTextView.delegate = self

        let editingControls: [UIView] = [nameTextField, aboutYouPlaceholderLabel,
                                         aboutYouTextView, changeAvatarButton]
        editingControls.forEach { $0.alpha = 0 }
    }

    private func setupViewModel() {
        viewModel.saveButtonEnabled = { [weak self] enabled in
            guard let `self` = self else { return }
            let btns: [UIButton] = [self.gcdButton, self.operationButton]
            btns.forEach { $0.isEnabled = enabled }

            print("^ enabled: \(enabled)")
        }
    }

    private func setupHeader() {
        setupChangeAvatarButton()
        setupAvatarImageView()
    }

    private func setupChangeAvatarButton() {
        let cornerRadius = changeAvatarButton.bounds.width / 2
        let imageInset: CGFloat = 20

        changeAvatarButton.layer.cornerRadius = cornerRadius
        changeAvatarButton.clipsToBounds = true

        let highlightedImage = UIImage(named: "icnCamera")?.withRenderingMode(.alwaysTemplate)
        changeAvatarButton.imageView?.tintColor = CUI.Profile.highlightColor
        changeAvatarButton.setImage(highlightedImage, for: .highlighted)

        changeAvatarButton.imageView?.contentMode = .scaleAspectFit
        changeAvatarButton.imageEdgeInsets = UIEdgeInsets(top: imageInset, left: imageInset,
                                                          bottom: imageInset, right: imageInset)
    }

    private func setupAvatarImageView() {
        avatarImageView.layer.cornerRadius = changeAvatarButton.layer.cornerRadius
        avatarImageView.clipsToBounds = true
    }

    private func setupEditButton() {
        editButton.layer.cornerRadius = 8
        editButton.layer.borderWidth = 1

        let borderColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
        editButton.layer.borderColor = borderColor.cgColor

        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchUpInside)
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupHeader()
    }

    // MARK: - Actions

    @objc
    private func toggleEditMode() {
        setEditing(!isEditing, animated: true)

        let editingControlsAlpha: CGFloat = isEditing ? 1 : 0
        let infoControls: [UIView] = [nameLabel, aboutYouLabel]
        let editingControls: [UIView] = [nameTextField, aboutYouPlaceholderLabel,
                                         aboutYouTextView, changeAvatarButton]

        UIView.animate(withDuration: 0.3) {
            infoControls.forEach { $0.alpha = 1 - editingControlsAlpha }
            editingControls.forEach { $0.alpha = editingControlsAlpha }
        }

        if !isEditing {
            viewModel.endEditing()
        }
    }

    @IBAction
    private func handleGCDTap() {}

    @IBAction
    private func handleOperationTap() {}

    @IBAction
    private func pickImage() {
        let alertController = UIAlertController(title: "Выбери изображение профиля",
                                                message: nil,
                                                preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let chooseFromGallery = UIAlertAction(title: "Выбрать из библиотеки", style: .default) { [weak self] _ in
                self?.presentImagePicker(with: .photoLibrary)
            }
            alertController.addAction(chooseFromGallery)
        }

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhoto = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] _ in
                self?.presentImagePicker(with: .camera)
            }
            alertController.addAction(takePhoto)
        }

        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alertController.addAction(cancel)

        if let ipadPopover = alertController.popoverPresentationController {
            ipadPopover.sourceView = changeAvatarButton
            ipadPopover.sourceRect.origin.y = changeAvatarButton.frame.height / 2
        }

        present(alertController, animated: true)
    }

    @IBAction
    private func dismiss() {
        dismiss(animated: true)
    }

    // MARK: - Helpers

    private func presentImagePicker(with type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        picker.allowsEditing = true

        present(picker, animated: true)
    }
}

extension ProfileController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        handleTextFieldText(textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextFieldText(textField.text)

        return true
    }

    private func handleTextFieldText(_ text: String?) {
        viewModel.name = text
    }
}

extension ProfileController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        handleTextViewText(textView.text)
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        handleTextViewText(textView.text)
        return true
    }

    private func handleTextViewText(_ text: String?) {
        viewModel.aboutYou = text
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var pickedImage: Any?
        pickedImage = info[.editedImage] ?? info[.originalImage]

        if let pickedImage = pickedImage as? UIImage {
            avatarImageView.image = pickedImage
            avatarImageView.contentMode = .scaleAspectFill

            viewModel.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
