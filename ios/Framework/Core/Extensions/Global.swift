/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import UIKit


public func nullIfEmpty(string: String?) -> String? {
	if string == nil {
		return nil
	}
	else if string! == "" {
		return nil
	}

	return string
}

public func synchronized(lock: AnyObject, closure: Void -> Void) {
	objc_sync_enter(lock)
	closure()
	objc_sync_exit(lock)
}


public func delayed(delay: NSTimeInterval, block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), block)
}


public func allBundles(#currentClass: AnyClass, #currentTheme: String?) -> [NSBundle] {
	return [bundleForTheme(currentTheme),
			(currentTheme == "default") ? nil : bundleForTheme("default"),
			bundleForCore(),
			NSBundle(forClass: currentClass),
			NSBundle.mainBundle()
		].filter { bundle in
			bundle != nil
		}.map { bundle in
			bundle!
		}
}

public func bundleForTheme(themeName: String?) -> NSBundle? {

	func prettifyThemeName(themeName: String) -> String {
		let head = themeName.substringToIndex(advance(themeName.startIndex, 1)).uppercaseString
		let tail = dropFirst(themeName).lowercaseString
		return "\(head)\(tail)"
	}

	func bundleName() -> String {
		return "LiferayScreens-\(themeName!.lowercaseString)"
	}

	let screensFrameworkBundle = NSBundle(forClass: BaseScreenlet.self)

	var themeBundlePath = (themeName == nil)
			? nil
			: screensFrameworkBundle.pathForResource(bundleName(),
				ofType: "bundle")

	// the bundle could be also in a theme framework
	// In this case it will be 'org.cocoapods.ModuleName' (generated by CocoaPods)

	if let themeNameValue = themeName
			where themeBundlePath == nil {

		let prettyThemeName = prettifyThemeName(themeNameValue)
		let bundleId = "org.cocoapods.LiferayScreensTheme\(prettyThemeName)"

		if let themeFrameworkBundle = NSBundle(identifier: bundleId) {
			themeBundlePath = themeFrameworkBundle.pathForResource(bundleName(),
				ofType: "bundle")
		}
	}

	return (themeBundlePath == nil) ? nil : NSBundle(path: themeBundlePath!)
}

public func bundleForCore() -> NSBundle? {
	let frameworkBundle = NSBundle(forClass: BaseScreenlet.self)

	let coreBundlePath = frameworkBundle.pathForResource("LiferayScreens-core", ofType: "bundle")

	return (coreBundlePath == nil) ? nil : NSBundle(path: coreBundlePath!)
}


public func imageInAnyBundle(#name: String, #currentClass: AnyClass, #currentTheme: String?) -> UIImage? {
	let bundles = allBundles(currentClass: currentClass, currentTheme: currentTheme)

	for bundle in bundles {
		if let path = bundle.pathForResource(name, ofType: "png") {
			return UIImage(contentsOfFile: path)
		}
	}

	return nil
}


public func LocalizedString(tableName: String, var key: String, obj: AnyObject) -> String {
	key = "\(tableName)-\(key)"

	let bundles = allBundles(currentClass: obj.dynamicType, currentTheme: tableName)

	for bundle in bundles {
		let res = NSLocalizedString(key,
					tableName: tableName,
					bundle: bundle,
					value: key,
					comment: "");

		if res.lowercaseString != key {
			return res
		}
	}

	return key
}


public func isOSAtLeastVersion(version: String) -> Bool {
	let currentVersion = UIDevice.currentDevice().systemVersion

	if currentVersion.compare(version,
			options: .NumericSearch,
			range: nil,
			locale: nil) != NSComparisonResult.OrderedAscending {

		return true
	}

	return false
}


public func isOSEarlierThanVersion(version: String) -> Bool {
	return !isOSAtLeastVersion(version)
}


public func adjustRectForCurrentOrientation(rect: CGRect) -> CGRect {
	var adjustedRect = rect

	if isOSEarlierThanVersion("8.0") {
		// For 7.x and earlier, the width and height are reversed when
		// the device is landscaped
		switch UIDevice.currentDevice().orientation {
			case .LandscapeLeft, .LandscapeRight:
				adjustedRect = CGRectMake(
						rect.origin.y, rect.origin.x,
						rect.size.height, rect.size.width)
			default: ()
		}
	}

	return adjustedRect
}

public func centeredRectInView(view: UIView, #size: CGSize) -> CGRect {
	return CGRectMake(
			(view.frame.size.width - size.width) / 2,
			(view.frame.size.height - size.height) / 2,
			size.width,
			size.height)
}