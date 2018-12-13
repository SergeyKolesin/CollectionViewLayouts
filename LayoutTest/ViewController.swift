//
//  ViewController.swift
//  LayoutTest
//
//  Created by Sergei Kolesin on 10/29/18.
//  Copyright © 2018 Sergei Kolesin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	@IBOutlet weak var collectionView: UICollectionView!
	
	let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"]
	
	lazy var layout1 : ReelLayout = {
		let layout = ReelLayout()
		return layout;
	}()
	
	lazy var layout2 : MyCustomLayout = {
		let layout = MyCustomLayout()
		return layout;
	}()
	
	@IBAction func tapButton(_ sender: Any)
	{
		if collectionView.collectionViewLayout == layout1
		{
			collectionView.setCollectionViewLayout(layout2, animated: true)
		}
		else
		{
			collectionView.setCollectionViewLayout(layout1, animated: true)
		}
		self.collectionView.collectionViewLayout.invalidateLayout()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.setCollectionViewLayout(layout1, animated: false)
		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false
	}

	public func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return items.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? MyCell else {
			return UICollectionViewCell()
		}
		cell.backgroundColor = UIColor.red
		if indexPath.section == 0
		{
			cell.titleLabel.text = items[indexPath.row]
		}
		
		return cell
	}
	
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if let collectionView = scrollView as? UICollectionView {
			collectionView.collectionViewLayout.invalidateLayout()
		}
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		self.collectionView.collectionViewLayout.invalidateLayout()
	}
	
}

