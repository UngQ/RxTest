//
//  ShoppingListRealmModel.swift
//  SeSACRxThreads
//
//  Created by ungQ on 4/2/24.
//

import Foundation
import RealmSwift


final class ShoppingListRealmModel: Object {
	@Persisted(primaryKey: true) var id: ObjectId
	@Persisted var regDate: Date
	@Persisted var title: String
	@Persisted var isCheck: Bool
	@Persisted var isBookmark: Bool

	convenience init(title: String) {
		self.init()
		self.regDate = Date()
		self.title = title
		self.isCheck = false
		self.isBookmark = false
	}
}


struct ShoppingList: Hashable {
	let id: ObjectId
	let regDate: Date
	let title: String
	let isCheck: Bool
	let isBookmark: Bool
}

extension ShoppingListRealmModel {
	func toStruct() -> ShoppingList {
		return ShoppingList(id: self.id,
							regDate: self.regDate,
							title: self.title,
							isCheck: self.isCheck,
							isBookmark: self.isBookmark)
	}
}
