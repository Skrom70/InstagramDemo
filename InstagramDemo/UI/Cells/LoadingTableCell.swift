//
//  LoadingTableCell.swift
//  InstagramDemo
//
//  Created by Viacheslav Tolstopianteko on 16.11.2022.
//

import UIKit
import Kingfisher
import SnapKit

class LoadingTableCell: UITableViewCell {
	
	static let id = "LoadingTableCell"
	
	let contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
	
	lazy var activityIndicator = UIActivityIndicatorView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.configure()
	}
		
	private func configure() {
		self.contentView.addSubview(activityIndicator)
		
		self.selectionStyle = .none
		
		activityIndicator.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.top.equalToSuperview().offset(contentInsets.top)
			$0.bottom.equalToSuperview().inset(contentInsets.bottom)
		}

		activityIndicator.startAnimating()
		activityIndicator.hidesWhenStopped = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
