//
//  ViewController.swift
//  Project10
//
//  Created by Pham Ha Thu Anh on 2020/06/28.
//  Copyright © 2020 AnhWorld. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //typecast
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        } else {
            picker.sourceType = UIImagePickerController.SourceType.camera
        }
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true) //dismiss the topmost view controller
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) //we want that for our current user
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        if person.name == "Unknown" {
            let namingAC = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            namingAC.addTextField()
        
            namingAC.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak namingAC] _ in
                guard let newName = namingAC?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            })
        
            namingAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(namingAC, animated: true)
        } else {
            let editingAC = UIAlertController(title: "Stuffs to do", message: "What do you want to do?", preferredStyle: .alert)
            editingAC.addTextField()
            editingAC.addAction(UIAlertAction(title: "Rename person", style: .default) { [weak self, weak editingAC] _ in
                guard let editedName = editingAC?.textFields?[0].text else { return }
                person.name = editedName
                self?.collectionView.reloadData()
            })
            
            editingAC.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
                _ = self?.people.remove(at: indexPath.item)
                self?.collectionView.reloadData()
            })
            present(editingAC, animated: true)
            
        }
    }


}
