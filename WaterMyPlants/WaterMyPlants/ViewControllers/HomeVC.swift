//
//  HomeVC.swift
//  WaterMyPlants
//
//  Created by Shawn James on 6/19/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    @IBOutlet weak var verticalCollectionView: UICollectionView!
    @IBOutlet weak var plusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendUserToLoginIfNecessary()
        setupInitialViews()
    }
    
    /// Checks if user is logged in. If the aren't, they are sent to login
    private func sendUserToLoginIfNecessary() {
        if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
            performSegue(withIdentifier: "OnboardingSegue", sender: self)
        }
    }
    
    private func setupInitialViews() {
        setupPlusButton()
        setupNavigationBar()
    }
    
    private func setupPlusButton() {
        // image
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        // shadow
        plusButton.layer.shadowColor = UIColor(red: 171/255, green: 178/255, blue: 186/255, alpha: 1).cgColor
        plusButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        plusButton.layer.shadowOpacity = 1
        plusButton.layer.shadowRadius = 4
        // shape
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layer.masksToBounds = false
    }
    
    private func setupNavigationBar() {
        self.navigationController!.navigationBar.largeTitleTextAttributes = [.font: UIFont(name: "HoeflerText-Black", size: 34)!]
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        performSpringAnimation(forButton_: sender)
    }
    
    private func performSpringAnimation(forButton_ button: UIButton) {
        UIButton.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (_) in
            UIButton.animate(withDuration: 0.005, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                button.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    // MARK: - Collection views data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == horizontalCollectionView ? 10 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalCollectionView {
            let horizontalCell = horizontalCollectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! HorizontalCVCell
            stylizeCell(horizontalCell)
            return horizontalCell
        } else { // verticalCollectionView
            let  verticalCell = verticalCollectionView.dequeueReusableCell(withReuseIdentifier: "VerticalCell", for: indexPath) as! VerticalCVCell
            stylizeCell(verticalCell)
            return verticalCell
        }
    }
        /// Used to style the cells if there are many tweaks done to the cell. Otherwise this method may not be neccasary.
        func stylizeCell(_ cell: UICollectionViewCell) {
            cell.layer.cornerRadius = 12
        }
    
    /// Customizes sizing for collectionViews
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == horizontalCollectionView {
            return CGSize(width: 97, height: 127)
        } else { // verticalCollectionView
            return CGSize(width: self.view.frame.width / 2 - 27, height: self.view.frame.width / 2)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}