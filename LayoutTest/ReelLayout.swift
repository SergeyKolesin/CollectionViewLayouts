//
//  ReelLayout.swift
//  LayoutTest
//
//  Created by Sergei Kolesin on 11/1/18.
//  Copyright © 2018 Sergei Kolesin. All rights reserved.
//

import UIKit

class ReelLayout: UICollectionViewLayout {
	public var itemHeight: CGFloat = 100
	public var spacing: CGFloat = 0
	let minScale: CGFloat = 0.5
	private var width: CGFloat = 0
	private var numberOfItems = 0
	
	override open func prepare() {
		super.prepare()
		self.width = self.collectionView?.bounds.width ?? 0
		self.numberOfItems = self.collectionView?.numberOfItems(inSection: 0) ?? 0
	}
	
	override open var collectionViewContentSize: CGSize {
		let height = self.frame(for: IndexPath(item: self.numberOfItems, section: 0)).maxY + collectionView!.bounds.size.height/2 - itemHeight/2
		return CGSize(width: self.width, height: height)
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
	
	open func frame(for indexPath: IndexPath) -> CGRect {
		return CGRect(
			x: 0,
			y: CGFloat(indexPath.item) * (self.itemHeight + self.spacing) + collectionView!.bounds.size.height/2 - itemHeight/2,
			width: (self.collectionView?.bounds.width ?? 0) * 0.7,
			height: self.itemHeight)
	}
	
	override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		attributes.frame = self.frame(for: indexPath)
		guard let collectionView = self.collectionView else {
			return attributes
		}
		let center = CGPoint(x: collectionView.bounds.size.width/2, y: attributes.center.y)
		attributes.center = center
		let centerY = attributes.center.y - collectionView.contentOffset.y
		let scale = max(minScale + (1 - 2 * abs(centerY - collectionView.bounds.size.height/2) / collectionView.bounds.size.height)*(1 - minScale), minScale)
		attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
		return attributes
	}
	
	override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
							 withScrollingVelocity velocity: CGPoint) -> CGPoint
	{
		guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
		if let items = self.layoutAttributesForElements(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.collectionViewContentSize))
		{
			var minDelta = self.collectionViewContentSize.height
			var indexPath: IndexPath?
			for item in items
			{
				let centerY = item.center.y
				let delta = abs(centerY - proposedContentOffset.y - collectionView.bounds.size.height/2)
				if delta < minDelta
				{
					minDelta = delta
					indexPath = item.indexPath
				}
			}
			if let attributes = self.layoutAttributesForItem(at: indexPath!) {
				let offsetY = attributes.center.y - collectionView.bounds.size.height/2
				return CGPoint(x: 0.0, y: offsetY)
			}
		}
		print("!!!!targetContentOffset")
		return CGPoint(x: 0.0, y: 0.0)
	}
}
