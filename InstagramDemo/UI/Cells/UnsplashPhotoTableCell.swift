//
//  NewsTableCell.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 09.11.2022.
//

import UIKit
import Kingfisher
import SnapKit

private struct Strings {
	@Localizable static var LIKE		= "LIKE"
	
	static func setupLikes(_ value: Int) {
		_LIKE = Localizable(wpareedValue: _LIKE.key, arguments: String(value))
	}
}

private struct Icons {
	
	static private let configuration = UIImage.SymbolConfiguration(weight: .bold)
	
	static let likes					= UIImage(systemName: "heart", withConfiguration: configuration)
	static let comment					= UIImage(systemName: "message", withConfiguration: configuration)
	static let share					= UIImage(systemName: "paperplane", withConfiguration: configuration)
	static let save						= UIImage(systemName: "bookmark", withConfiguration: configuration)
}


class UnsplashPhotoTableCell: UITableViewCell, BaseViewProtocol {
	
	static let id = "UnsplashPhotoTableCell"
	
	let contentInsets 						= UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
	let likesNumberInsets 					= UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 8)
	let photoHeight							= UIScreen.main.bounds.width * 1.5
	let avatarImageSize						= 40.0
	let actionSize							= 35.0
	let actionSpacing						= 10.0
	let likesNumberMinWidth					= 30.0
	
	lazy var autorAvatar 					= UIImageView()
	lazy var autorName 						= UILabel()
	lazy var photoDescription				= UILabel()
	lazy var photo 							= UIImageView()
	lazy var likesButton					= UIButton(configuration: .plain(), primaryAction: .none)
	lazy var commentButton					= UIButton(configuration: .plain(), primaryAction: .none)
	lazy var shareButton					= UIButton(configuration: .plain(), primaryAction: .none)
	lazy var saveButton						= UIButton(configuration: .plain(), primaryAction: .none)
	lazy var spacer  						= UIView()
	lazy var likesNumber        			= UILabel()
		
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.configure()
	}
	
	func setup(autorName: String, autorUrl: URL, photoDescription: String, photoUrl: URL, likes: Int) {
		self.autorAvatar.kf.setImage(with: autorUrl)
		self.autorName.text = autorName
		self.photoDescription.text = photoDescription
		self.photo.kf.setImage(with: photoUrl)
	
			
		Strings.setupLikes(likes)
		self.likesNumber.text = Strings.$LIKE
	}
	
	private func configure() {
		self.contentView.addSubview(photo)
		self.contentView.addSubview(autorAvatar)
		self.contentView.addSubview(autorName)
		self.contentView.addSubview(likesNumber)
		self.contentView.addSubview(photoDescription)
		
		self.selectionStyle = .none
		
		autorName.font = Fonts.SFProText(size: 14, weight: .Semibold)
		
		likesNumber.font = Fonts.SFProText(size: 14, weight: .Semibold)
		
		photoDescription.font = Fonts.SFProText(size: 14, weight: .Medium)

		autorAvatar.snp.makeConstraints {
			$0.left.equalToSuperview().offset(contentInsets.left)
			$0.top.equalToSuperview().offset(contentInsets.top)
			$0.width.height.equalTo(avatarImageSize)
		}
		
		autorName.snp.makeConstraints {
			$0.left.equalTo(autorAvatar.snp.right).offset(contentInsets.left)
			$0.centerY.equalTo(autorAvatar.snp.centerY)
			$0.right.equalToSuperview().inset(contentInsets.right)
		}
		
		photo.snp.makeConstraints {
			$0.left.equalTo(safeAreaLayoutGuide.snp.left)
			$0.right.equalTo(safeAreaLayoutGuide.snp.right)
			$0.top.equalTo(autorAvatar.snp.bottom).offset(contentInsets.top)
			$0.height.equalTo(photoHeight)
		}
		
		let stack = UIStackView(arrangedSubviews: [likesButton, commentButton, shareButton, spacer, saveButton])
		stack.axis = .horizontal
		stack.spacing = actionSpacing
		
		self.contentView.addSubview(stack)
		
		stack.snp.makeConstraints {
			$0.left.equalToSuperview().offset(contentInsets.left)
			$0.right.equalToSuperview().inset(contentInsets.right)
			$0.top.equalTo(photo.snp.bottom).offset(contentInsets.right)
		}
		
		likesButton.snp.makeConstraints {
			$0.width.height.equalTo(actionSize)
		}
		
		commentButton.snp.makeConstraints {
			$0.width.height.equalTo(actionSize)
		}
		
		shareButton.snp.makeConstraints {
			$0.width.height.equalTo(actionSize)
		}
		
		spacer.snp.makeConstraints {
			$0.height.equalTo(actionSize)
		}
		
		saveButton.snp.makeConstraints {
			$0.width.height.equalTo(actionSize)
		}
		
		likesNumber.snp.makeConstraints {
			$0.left.equalToSuperview().offset(likesNumberInsets.left)
			$0.top.equalTo(likesButton.snp.bottom)
			$0.width.greaterThanOrEqualTo(likesNumberMinWidth)
			$0.bottom.equalToSuperview().inset(likesNumberInsets.bottom)
		}
		
		likesNumber.snp.contentHuggingHorizontalPriority = 252
		
		photoDescription.snp.makeConstraints {
			$0.left.equalTo(likesNumber.snp.right).offset(likesNumberInsets.right)
			$0.top.equalTo(likesNumber.snp.top)
			$0.right.equalToSuperview().inset(contentInsets.right)
		}
		
		photoDescription.numberOfLines = 2
		
		photo.contentMode = .scaleAspectFill
		
		autorAvatar.layer.cornerRadius = avatarImageSize / 2
		autorAvatar.layer.masksToBounds = true
		autorAvatar.layer.shadowRadius = 4
		autorAvatar.layer.borderWidth = 1
		autorAvatar.layer.borderColor = UIColor.gray.cgColor
		
		likesButton.setImage(Icons.likes, for: .normal)
		commentButton.setImage(Icons.comment, for: .normal)
		shareButton.setImage(Icons.share, for: .normal)
		saveButton.setImage(Icons.save, for: .normal)

	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
