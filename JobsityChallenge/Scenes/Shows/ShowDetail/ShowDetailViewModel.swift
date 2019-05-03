//
//  ShowDetailViewModel.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/30/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import RxSwift

class ShowDetailViewModel: NSObject {
    var coverURL: PublishSubject<URL?> = PublishSubject()
    var name: PublishSubject<String> = PublishSubject()
    var summary: PublishSubject<String> = PublishSubject()
    var genres: PublishSubject<String> = PublishSubject()
    var scheduleDays: PublishSubject<String> = PublishSubject()
    var scheduleTime: PublishSubject<String> = PublishSubject()
    var season: PublishSubject<String> = PublishSubject()
    var seasonPickerTop: PublishSubject<CGFloat> = PublishSubject()
    var seasons: PublishSubject<[String]> = PublishSubject()
    var episodesViewModels: PublishSubject<[EpisodeCellViewModel]> = PublishSubject()
    var error: PublishSubject<String> = PublishSubject()
    var loading: PublishSubject<Bool> = PublishSubject()
    let coverPlaceholder = "plchldr_show"
    
    private var show: Show
    private var groupedEpisodes: [Int : [ShowEpisode]] = [:]
    private var currentlyDisplayedSeason = 1
    private var showEpisodesTVMazeOperations: ShowEpisodesTVMazeOperations
    private let disposeBag = DisposeBag()
    
    init(show: Show, showEpisodesTVMazeOperations: ShowEpisodesTVMazeOperations) {
        self.show = show
        self.showEpisodesTVMazeOperations = showEpisodesTVMazeOperations
        super.init()
    }
    
    func start() {
        coverURL.onNext(URL(string: show.cover))
        name.onNext(show.name)
        summary.onNext(show.summary.removeHTMLTags() ?? "")
        genres.onNext(show.genres.joined(separator: ", "))
        scheduleDays.onNext(show.schedule.1.joined(separator: ", "))
        scheduleTime.onNext(show.schedule.0)
        season.onNext("Season 1")
        seasonPickerTop.onNext(0.0)
        loading.onNext(true)
        episodes(for: show.identifier)
    }
    
    private func episodes(for show: Int) {
        showEpisodesTVMazeOperations.episodes(for: show) { (response) in
            self.loading.onNext(false)
            
            switch response {
            case let .success(episodes):
                self.groupedEpisodes = Dictionary(grouping: episodes) { $0.season }
                self.seasons.onNext(self.groupedEpisodes.keys.sorted { $0 < $1 }.map { "Season \($0)" })
                self.episodesViewModels.onNext((self.groupedEpisodes[1] ?? []).map {
                    EpisodeCellViewModel(name: $0.name)
                })
            case let .error(error):
                self.error.onNext(error)
            }
        }
    }
    
    func setupSeason(season: Int) {
        episodesViewModels.onNext((groupedEpisodes[season] ?? []).map { EpisodeCellViewModel(name: $0.name) })
        self.season.onNext("Season \(season)")
        toggleSeasonPicker(toggle: false)
        currentlyDisplayedSeason = season
    }
    
    func toggleSeasonPicker(toggle: Bool) {
        seasonPickerTop.onNext(toggle ? -160 : 0)
    }
    
    func episode(at index: Int) -> ShowEpisode? {
        return groupedEpisodes[currentlyDisplayedSeason]![index]
    }
}

struct EpisodeCellViewModel {
    var name: String
}
