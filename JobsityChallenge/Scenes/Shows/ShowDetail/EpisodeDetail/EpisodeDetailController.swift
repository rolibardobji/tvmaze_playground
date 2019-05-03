//
//  EpisodeDetailController.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 5/1/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class EpisodeDetailController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var episodeAndSeasonLabel: UILabel!
    
    var viewModel: EpisodeDetailViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.start()
    }
    
    func setupBindings() {
        viewModel.coverURL
            .bind(onNext: { self.coverImageView.sd_setImage(with: $0, placeholderImage: UIImage(named: self.viewModel?.coverPlaceholder ?? ""), completed: nil) })
            .disposed(by: disposeBag)
        viewModel.name
            .bind(onNext:) {
                self.title = $0
            }
            .disposed(by: disposeBag)
        viewModel.summary
            .bind(to: summaryLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.episodeAndSeason
            .bind(to: episodeAndSeasonLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
