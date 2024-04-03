//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by ungQ on 4/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingListViewController: UIViewController {

	let viewModel = ShoppingListViewModel()

	let searchView = UIView()
	let textField = UITextField()
	let addButton = {
		let button = UIButton()
		button.setTitle("추가", for: .normal)
		return button
	}()

	let shoppingListTableView = {
		let tableView = UITableView()
		tableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
		tableView.backgroundColor = .white
		return tableView
	}()


	let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white

		configureLayout()
		bind()
    }

	func configureLayout() {

		view.addSubview(searchView)
		searchView.addSubview(textField)
		searchView.addSubview(addButton)
		view.addSubview(shoppingListTableView)

		searchView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
			make.height.equalTo(60)
		}

		addButton.snp.makeConstraints { make in
			make.trailing.verticalEdges.equalToSuperview().inset(12)
			make.width.equalTo(44)
		}

		textField.snp.makeConstraints { make in
			make.leading.verticalEdges.equalToSuperview().inset(12)
			make.trailing.equalTo(addButton.snp.leading).offset(-8)
		}

		shoppingListTableView.snp.makeConstraints { make in
			make.top.equalTo(searchView.snp.bottom).offset(8)
			make.horizontalEdges.equalToSuperview().inset(8)
			make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
		}



		searchView.backgroundColor = .darkGray
		textField.backgroundColor = .lightGray
		addButton.backgroundColor = .blue

	}

	func bind() {

		textField.rx.text.orEmpty
			.bind(to: viewModel.inputTextFieldString)
			.disposed(by: disposeBag)

		viewModel.inputTextFieldString
			.bind(to: textField.rx.text)
			.disposed(by: disposeBag)

		addButton.rx
			.tap
			.bind(to: viewModel.inputAddButtonTap)
			.disposed(by: disposeBag)


		viewModel.data
			.bind(to: shoppingListTableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)) {
				row, element, cell in
				
				cell.appNameLabel.rx.text
					.onNext(element.title)

				let checkButtonImage = element.isCheck ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
				cell.checkButton.setImage(checkButtonImage, for: .normal)
				cell.checkButton.rx.tap
					.bind(with: self) { owner, _ in
						owner.viewModel.repository.toggleCheck(element.id)

					}
					.disposed(by: cell.disposeBag)

				let bookmarkButtonImage = element.isBookmark ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
				cell.bookmarkButton.setImage(bookmarkButtonImage, for: .normal)
				cell.bookmarkButton.rx.tap
					.bind(with: self) { owner, _ in
						owner.viewModel.repository.toggleBookmark(element.id)

					}
					.disposed(by: cell.disposeBag)
			}
			.disposed(by: disposeBag)


		shoppingListTableView
			.rx
			.itemDeleted
			.bind(with: self, onNext: { owner, indexPath in
				owner.viewModel.inputDeleteButtonTap.accept(indexPath.row)
			})
			.disposed(by: disposeBag)
	}



}
