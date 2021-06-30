//
//  OrderTableCell.swift
//  Ratatouille
//
//  Created by Kato Drake Smith on 11/06/2021.
//

import UIKit

class OrderTableCell: UITableViewCell {

    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderIngredients: UILabel!
    
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderWaiter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
