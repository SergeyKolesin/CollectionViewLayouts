//
//  MyCustomLayout.swift
//  LayoutTest
//
//  Created by Sergei Kolesin on 11/2/18.
//  Copyright © 2018 Sergei Kolesin. All rights reserved.
//

import UIKit

class MyCustomLayout: UICollectionViewLayout {

	public var spacing: CGFloat = 10
	private var itemWidth: CGFloat = 0
	private var itemHeight: CGFloat = 0
	private var bigItemWidth: CGFloat = 0
	private var bigItemHeight: CGFloat = 0
	private var numberOfItems = 0
	
	func collectionView() -> UICollectionView
	{
		guard let collectionView = self.collectionView else {
			print("FatalError")
			fatalError()
		}
		return collectionView
	}
	
	override open func prepare()
	{
		super.prepare()
		itemWidth = (collectionView().bounds.width - 2*spacing) / 3.0
		itemHeight = itemWidth
		bigItemWidth = 2*itemWidth + spacing
		bigItemHeight = bigItemWidth
		numberOfItems = collectionView().numberOfItems(inSection: 0)
	}
	
	override open var collectionViewContentSize: CGSize {
		
		var height = CGFloat(numberOfItems / 6) * (3 * itemHeight + 2 * spacing)
		let rest = numberOfItems % 6
		if rest == 1
		{
			height += itemHeight + spacing
		}
		else if rest == 2 || rest == 3
		{
			height += 2*(itemHeight + spacing)
		}
		else if rest == 4 || rest == 5
		{
			height += 3*(itemHeight + spacing)
		}
		return CGSize(width: collectionView().bounds.size.width, height: height)
	}
	
	open func frame(for indexPath: IndexPath) -> CGRect {
		
		let rest = indexPath.row % 6
		var size = CGSize()
		if (rest == 2)
		{
			size = CGSize(width: bigItemWidth, height: bigItemHeight)
		}
		else
		{
			size = CGSize(width: itemWidth, height: itemHeight)
		}
		
		var x = CGFloat()
		if rest == 0 || rest == 1 || rest == 3
		{
			x = 0
		}
		else if rest == 2 || rest == 4
		{
			x = itemWidth + spacing
		}
		else
		{
			x = 2*(itemWidth + spacing)
		}
		
		var y = CGFloat(indexPath.row / 6) * 3 * (itemHeight + spacing)
		if rest == 1
		{
			y += itemHeight + spacing
		}
		else if rest == 3 || rest == 4 || rest == 5
		{
			y += 2*(itemHeight + spacing)
		}
		let rect = CGRect(origin: CGPoint(x: x, y: y), size: size)
		return rect
	}
	
	override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
	{
		let attributes: [UICollectionViewLayoutAttributes] = (0..<self.numberOfItems).compactMap {
			let indexPath = IndexPath(item: $0, section: 0)
			let frame = self.frame(for: indexPath)
			if !frame.intersects(rect) {
				return nil
			}
			return self.layoutAttributesForItem(at: indexPath)
		}
		return attributes
	}
	
	override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		attributes.frame = self.frame(for: indexPath)
		var angle: CGFloat = 0
		if collectionView().panGestureRecognizer.velocity(in: collectionView()).y != 0
		{
			angle = 0.05*sin(collectionView().contentOffset.y / 10)
		}
		attributes.transform = CGAffineTransform(rotationAngle: angle)
		return attributes
	}
}
