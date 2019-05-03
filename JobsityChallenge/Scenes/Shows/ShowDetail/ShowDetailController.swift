//
//  ShowDetailController.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/30/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class ShowDetailController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var scheduleDaysLabel: UILabel!
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    @IBOutlet weak var seasonPickerButton: UIButton!
    @IBOutlet weak var episodesTableView: UITableView!
    @IBOutlet weak var episodesTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var seasonPicker: UIPickerView!
    @IBOutlet weak var seasonPickerTop: NSLayoutConstraint!
    
    var viewModel: ShowDetailViewModel!
    private let disposeBag = DisposeBag()
    
    private let episodeDetailSegue = "EpisodeDetail"
    
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
        viewModel.genres
            .bind(to: genresLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.scheduleDays
            .bind(to: scheduleDaysLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.scheduleTime
            .bind(to: scheduleTimeLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.season
            .bind(to: seasonPickerButton.rx.title())
            .disposed(by: disposeBag)
        viewModel.seasonPickerTop
            .bind(to: seasonPickerTop.rx.constant)
            .disposed(by: disposeBag)
        viewModel.seasons
            .bind(to: seasonPicker.rx.itemTitles) { $1 }
            .disposed(by: disposeBag)
        
        seasonPicker.rx
            .itemSelected
            .asObservable()
            .bind(onNext: {
                self.viewModel.setupSeason(season: $0.row + 1) })
            .disposed(by: disposeBag)
        
        viewModel.episodesViewModels
            .bind(to: episodesTableView.rx
                .items(cellIdentifier: "EpisodeCell", cellType: UITableViewCell.self)) { row, model, cell in
                    cell.textLabel?.text = model.name }
            .disposed(by: disposeBag)
        
        episodesTableView.rx
            .observe(CGSize.self, "contentSize")
            .map() { $0?.height ?? 0.0 }
            .bind(to: episodesTableViewHeight.rx.constant)
            .disposed(by: disposeBag)
        
        episodesTableView.rx.itemSelected
            .map {
                self.viewModel.episode(at: $0.row)
            }.subscribe(onNext: {
                self.performSegue(withIdentifier: self.episodeDetailSegue, sender: $0)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func toggleSeasonPicker(_ sender: UIButton) {
        viewModel?.toggleSeasonPicker(toggle: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == episodeDetailSegue {
            let episodeDetailController = segue.destination as! EpisodeDetailController
            let episodeDetailViewModel = EpisodeDetailViewModel(showEpisode: sender as! ShowEpisode)
            episodeDetailController.viewModel = episodeDetailViewModel
        }
    }
}
