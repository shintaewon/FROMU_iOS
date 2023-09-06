//
//  CalendarEventCell.swift
//  FromU
//
//  Created by 신태원 on 2023/09/06.
//

import UIKit

class CalendarEventCell: UITableViewCell {

    let editButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "icn_edit_"), for: .normal)
        btn.contentMode = .scaleAspectFit
        return btn
    }()

    let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "icn_delete"), for: .normal)
        btn.contentMode = .scaleAspectFit
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButtons() {
        contentView.addSubview(editButton)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 36),
            editButton.heightAnchor.constraint(equalToConstant: 36),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 36),
            deleteButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}

