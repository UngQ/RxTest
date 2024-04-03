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

	var shoppingList: [ShoppingList] = []
	lazy var data = BehaviorSubject(value: shoppingList)

	var inputTextFieldString = BehaviorSubject<String>(value: "")
	let inputAddButtonTap = PublishRelay<Void>()
	let inputDeleteButtonTap = PublishRelay<Int>()

	//

	lazy var currentList = repository.fetchList()
	var observationToken = NotificationToken()

	let disposeBag = DisposeBag()

	init() {
		makeRealmObserve()

		bindInputTextFieldString()

		inputAddButtonTap
			.withLatestFrom(inputTextFieldString)
			.distinctUntilChanged()
			.bind(with: self, onNext: { owner, value in
				owner.repository.createShoppingItem(value)
			})
			.disposed(by: disposeBag)

		inputDeleteButtonTap

			.bind(with: self) { owner, value in
				print(value)
				var result: [ShoppingList] = []
				do {
					try result = owner.data.value()
					owner.repository.deleteShoppingItem(result[value].id)
				} catch {
					print("error")
				}
			}
			.disposed(by: disposeBag)

	}

	func bindInputTextFieldString() {
		inputTextFieldString
			.subscribe(with: self) { owner, value in
				let result = value.isEmpty ? owner.shoppingList : owner.shoppingList.filter { $0.title.contains(value) }
				owner.data.onNext(result)
				print(value)
			}
			.disposed(by: disposeBag)
	}

	func makeRealmObserve() {
		guard let list = currentList else { return }


		observationToken = list.observe { changes in
			switch changes {
			case .initial:
				print("initial")
				self.shoppingList = Array(list).map { $0.toStruct() }
				self.data.onNext(self.shoppingList)
			case .update:
				print("update")
				self.shoppingList = Array(list).map { $0.toStruct() }
				self.data.onNext(self.shoppingList)
				self.bindInputTextFieldString()
			case .error:
				print("error")
			}
		}
	}
}
