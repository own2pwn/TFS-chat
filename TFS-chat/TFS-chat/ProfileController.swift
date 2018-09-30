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
    var avatarImageView: UIImageView!

    @IBOutlet
    var changeAvatarButton: UIButton!

    @IBOutlet
    var editButton: UIButton!

    // MARK: - Overrides

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        /*
         printEditButtonFrame()

         В методе `init(coder:)` @IBOutlet'ы еще не будут инициализированы и будут равны nil.
         Т.к. переменные объявлены как Implicitly Unwrapped,
         то при доступе к nil (и соответственно force unwrap'e) происходит падение приложения.

         Если бы мы попытались вывести фрейм как print(editButton?.frame)
         то получили бы в консоле `nil` без падения.

         @IBOutlet'ы должны уже быть инициализированы на момент вызова `viewDidLoad`
         или после вызова `super.loadView()` в `loadView()`

         Например:

         ```
         override func loadView() {
         print(avatarImageView == nil) // true
         super.loadView()
         print(avatarImageView == nil) // false
         }
         ```

         */
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        printEditButtonFrame()
        setupEditButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        printEditButtonFrame()
        /*
         В `viewDidload` размер и позиции кнопки были установлены в соответствии значениям из сториборда
         в `viewDidAppear` уже были просчитаны констрейнты и фрейм кнопки был установлен в соответствии
         значениям высчитанных констрейнтов.
         */
    }

    // MARK: - Methods

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
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupHeader()
    }

    // MARK: - Actions

    @IBAction
    func pickImage() {
        print("Выбери изображение профиля")
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

    // MARK: - Helpers

    private func printEditButtonFrame() {
        print(editButton.frame)
    }

    private func presentImagePicker(with type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        picker.allowsEditing = true

        present(picker, animated: true)
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var pickedImage: Any?
        pickedImage = info[.editedImage] ?? info[.originalImage]

        if let pickedImage = pickedImage as? UIImage {
            avatarImageView.image = pickedImage
            avatarImageView.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
}
