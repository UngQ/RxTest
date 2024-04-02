//
//  ShoppingListTableViewCell.swift
//  SeSACRxThreads
//
//  Created by ungQ on 4/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingListTableViewCell: UITableViewCell {

	static let identifier = "ShoppingListTableViewCell"

	let appNameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .bold)
		label.textColor = .black
		return label
	}()


	let checkButton: UIButton = {
		let button = UIButton()
		button.tintColor = .black
		return button
	}()

	let bookmarkButton: UIButton = {
		let button = UIButton()
		button.tintColor = .systemYellow
		return button
	}()

	var disposeBag = DisposeBag()

	override func prepareForReuse() {
		disposeBag = DisposeBag()
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.selectionStyle = .none
		configure()
	}



	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configure() {
		contentView.addSubview(appNameLabel)
		contentView.addSubview(checkButton)
		contentView.addSubview(bookmarkButton)

		checkButton.snp.makeConstraints {
			$0.centerY.equalToSuperview()
			$0.leading.equalTo(20)
			$0.size.equalTo(30)
		}

		appNameLabel.snp.makeConstraints {
			$0.centerY.equalTo(checkButton)
			$0.leading.equalTo(checkButton.snp.trailing).offset(8)
			$0.trailing.equalTo(bookmarkButton.snp.leading).offset(-8)
		}

		bookmarkButton.snp.makeConstraints {
			$0.centerY.equalTo(checkButton)
			$0.trailing.equalToSuperview().inset(20)
			$0.size.equalTo(30)
		}
	}
}


