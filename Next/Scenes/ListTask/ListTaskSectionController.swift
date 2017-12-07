//
//  ListTaskSectionController.swift
//  Next
//
//  Created by Guilherme Souza on 07/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import IGListKit

final class ListTaskSectionController: ListSectionController {
    var item: TaskViewModel!

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: 96)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCellFromStoryboard(withIdentifier: ListTaskCell.reuseIdentifier,
                                                                        for: self, at: index) as! ListTaskCell

        return cell
    }

    override func didUpdate(to object: Any) {
        assert(object is TaskViewModel)
        item = object as? TaskViewModel
    }
}
