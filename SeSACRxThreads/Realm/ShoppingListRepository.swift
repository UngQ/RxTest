//
//  ShoppingListRepository.swift
//  SeSACRxThreads
//
//  Created by ungQ on 4/2/24.
//

import Foundation
import RealmSwift

final class ShoppingListRepository {

	var realm: Realm?

	init() {
		do {
			realm = try Realm()
		} catch {
			print(error)
		}

		
	}

	func fetchList() -> Results<ShoppingListRealmModel>? {
		guard let realm = realm else { return nil }

		print(realm.configuration.fileURL)

		let result = realm.objects(ShoppingListRealmModel.self)
		return result
	}

	func fetchList2() -> [ShoppingListRealmModel] {
		guard let realm = realm else { return [] }

		print(realm.configuration.fileURL)

		let result = realm.objects(ShoppingListRealmModel.self)
		return Array(result)
	}

	func createShoppingItem(_ title: String) {
		guard let realm = realm else { return }

		let item = ShoppingListRealmModel(title: title)

		do {
			try realm.write {
				realm.add(item)
			}
		} catch {
			print("Realm Add Error")
		}
	}

	func toggleCheck(_ id: ObjectId) {
		guard let realm = realm else { return }

		let list = fetchList()

		do {
			try realm.write {
				list?.filter{ $0.id == id }.first?.isCheck.toggle()
			}
		} catch {
			print(error)
		}
	}

	func toggleBookmark(_ id: ObjectId) {
		guard let realm = realm else { return }

		let list = fetchList()

		do {
			try realm.write {
				list?.filter{ $0.id == id }.first?.isBookmark.toggle()
			}
		} catch {
			print(error)
		}
	}

	func deleteShoppingItem(_ id: ObjectId) {
		guard let realm = realm else { return }

		let list = fetchList()

		do {
			try realm.write {
				guard let data = list?.filter({ $0.id == id }).first else { return }
				realm.delete(data)
			}
		} catch {
			print("Realm delete error")
		}
	}

}
