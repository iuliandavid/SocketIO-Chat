//
//  AvatarPickerVC.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/30/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = AvatarsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        guard let title = sender.titleForSegment(at: sender.selectedSegmentIndex),
        let avatarType = AvatarType(rawValue : title.lowercased()) else {
            return
        }
        
        viewModel.type = avatarType
        collectionView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("No Avatar Controller View")
    }
}

extension AvatarPickerVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //save avatar name to UserDefaults
        UserDataService.instance.setAvatarName(avatarName: viewModel.avatars[indexPath.item])
        self.dismiss(animated: true, completion: nil)
    }
}

extension AvatarPickerVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.CellIdentifiers.avatarCellidentifier,
            for: indexPath) as? AvatarCell else {
            return AvatarCell()
        }
        
        guard let title = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex),
            let avatarType = AvatarType(rawValue : title.lowercased()) else {
                return AvatarCell()
        }
        cell.imageStringAndColor = (viewModel.avatars[indexPath.item], avatarType)
        
        return cell
        
    }
}

extension AvatarPickerVC: UICollectionViewDelegateFlowLayout {
    //number of cells based on device screen size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numOfColumns: CGFloat = 3
        
        if UIScreen.main.bounds.width > 320 {
            numOfColumns = 4
        }
        
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        
        let cellDimension = ((collectionView.bounds.width - padding) - (numOfColumns - 1) * spaceBetweenCells) / numOfColumns
        
        return CGSize(width: cellDimension, height: cellDimension)
    }
}
