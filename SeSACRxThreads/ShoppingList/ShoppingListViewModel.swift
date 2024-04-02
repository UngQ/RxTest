//
//  ShoppingListViewModel.swift
//  SeSACRxThreads
//
//  Created by ungQ on 4/2/24.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class ShoppingListViewModel {

	let repository = ShoppingListRepository()
//	var shoppingList: [ShoppingList] = []

	let data = BehaviorSubject<[ShoppingList]>(value: [])

	var searchText = BehaviorSubject<String>(value: "")

	var filteredData: Observable<[ShoppingList]> {
		return Observable.combineLatest(data, searchText)
			.map { shoppingList, searchText in
				guard !searchText.isEmpty else { return shoppingList }
				return shoppingList.filter { $0.title.contains(searchText) }
			}
	}

	let disposeBag = DisposeBag()

	init() {
		loadRealmData()




	}

	func loadRealmData() {
		guard let realmData = repository.fetchList() else { return }
		let shoppingList = Array(realmData).map{ $0.toStruct() }
		data.onNext(shoppingList)

	}


	func addShoppingItem(title: String) {
		repository.createShoppingItem(title)
		loadRealmData()
	}

	func deleteShoppingItem(by id: ObjectId) {
		repository.deleteShoppingItem(id)
		loadRealmData()
	}


	
}
