//
//  Functions.swift
//  CommonExtension
//
//  Created by Rahmannur Rizki Syahputra on 20/01/24.
//

import UIKit

/// Randomize colors based on the available data
public func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
	var colors: [UIColor] = []
	for _ in 0..<numbersOfColor {
		let red = Double(arc4random_uniform(256))
		let green = Double(arc4random_uniform(256))
		let blue = Double(arc4random_uniform(256))
		let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
		colors.append(color)
	}
	
	return colors
}
