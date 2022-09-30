//
//  ListChannelsViewController.swift
//  TVPlayer
//
//  Created by Сперанский Никита on 15.09.2022.
//

import UIKit
import AVKit

class ListChannelViewController: UIViewController {
    // MARK: - Propherties
    
    typealias DataSource = UICollectionViewDiffableDataSource<ChannelsListSection, Channel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ChannelsListSection, Channel>
    
    private var collectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)
    private let segmentedControl = UISegmentedControl(items: ["All Channels","Favorite"])

    
    private var dataSource: DataSource?
    private var channels: [Channel] = [] {
        didSet{
            reloadData()
        }
    }
    private var favoriteChannels: [Channel] {
        DataManager.shared.fetchChannels()
    }
    /// App colors
    private let darkGrayColor = UIColor(white: 0.2, alpha: 1)
    private let lightGrayColor = UIColor(white: 0.5, alpha: 1)
    
    // MARK: - Override View Controller life-circle function
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        createDataSource()
        fetchChannels()
    }
    
    // MARK: - View Controller elements setup
    private func setupElements() {
        /// `SuperView` settings
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        /// `Navigation Controller` settings
        title = "TV Player"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.gray]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.green]
        navBarAppearance.backgroundColor = .clear
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        /// `Search Controller` settings
        searchController.searchResultsUpdater = self  /// show results in main VC
        searchController.obscuresBackgroundDuringPresentation = false /// allows access to search results
        searchController.searchBar.placeholder = "Channel Search"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationItem.searchController = searchController
        definesPresentationContext = true  /// Позволяет опустить строку поиска при переходе на другой экран
        
        /// `Segmented Control` settings
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        segmentedControl.backgroundColor = darkGrayColor
        segmentedControl.tintColor = lightGrayColor
        segmentedControl.layer.cornerRadius = 5.0
        
        /// Text Characteristics Settings
        let selectedTextAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .heavy),
            .foregroundColor: darkGrayColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let normalTextAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .medium),
            .foregroundColor: lightGrayColor
        ]
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        
        /// `CollectionView` settings
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        
        collectionView.dragInteractionEnabled = true
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self

        /// Registration of cells
        collectionView.register(UINib(nibName: String(describing: ChannelCell.self), bundle: nil),
                                forCellWithReuseIdentifier: ChannelCell.reuseId)
        
        /// Adding elements to the screen
        view.addSubview(collectionView)
        view.addSubview(segmentedControl)
        
        /// Setting up the location of elements on the screen
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeAreaGuide = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 8),
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,constant: 7 ),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - 'Channels' array updates
    /// Actions when selecting segments in `segmentedControl`
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
         switch (segmentedControl.selectedSegmentIndex) {
         case 1: getFavoriteChannels()
         default: fetchChannels()
         }
     }
    /// Loading data into an array `channels`
    private func fetchChannels() {
        NetworkManager.shared.fetchChannelsData(completion: { channels, error in
            guard let channelsData = channels else {
                print("Channel loading error occurred.")
                print(error?.localizedDescription ?? "Download error not recognized")
                return
            }
            self.channels = channelsData.channels
        })
    }
    /// Loading data into an array `favoriteChannels`
    private func getFavoriteChannels() {
        self.channels = favoriteChannels
    }

    // MARK: - DataSource, Snapshot and Layout settings
    private func createDataSource() {
        dataSource = DataSource(collectionView: collectionView,
                                cellProvider: { (collectionView, indexPath, channel) -> UICollectionViewCell? in
            
            let isFavorite = self.favoriteChannels.contains(channel)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCell.reuseId,
                                                          for: indexPath) as? ChannelCell
            cell?.configure(with: channel, isFavorite: isFavorite)
            return cell
        })
    }
    
    private func reloadData() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(channels, toSection: .main)
        dataSource?.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(86))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 8, bottom: 0, trailing: 8)
            
            return section
        }
        return layout
    }
}

// MARK: - Collection View Drag/Drop Delegate
extension ListChannelViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let channel = channels[indexPath.row]
        let itemProvider = NSItemProvider(object: channel)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = channel
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        coordinator.items.forEach { dropItem in
          guard let sourceIndexPath = dropItem.sourceIndexPath else { return }
            switch (segmentedControl.selectedSegmentIndex) {
            case 1:
                DataManager.shared.changePlaceInFavArray(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
            default:
                let channel = channels[sourceIndexPath.row]
                channels.remove(at: sourceIndexPath.row)
                channels.insert(channel, at: destinationIndexPath.row)
            }
        }
    }    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession,
      withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
      return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

// MARK: - Collection View Delegate
extension ListChannelViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playChannelForIndexPath(indexPath: indexPath) /// Playing the channel of the selected cell
    }
    // Channel AVPlayer Implementation
    private func playChannelForIndexPath(indexPath: IndexPath) {
        let channel = channels[indexPath.row]      /// Понимаем какой канал был выбран
        let channelUrl = URL(string: channel.url) /// Извлекаем Url адресс
        let player = AVPlayer(url: channelUrl!)   /// Создаем плеер с данным адресом
        let playerVC = AVPlayerViewController()   /// Создаем VC
        playerVC.player = player                  /// Присваиваем плеер - плееру созданного VC
        
        present(playerVC, animated: true) {      /// Показываем VC и запускаем проигрывание
            player.play()
        }
    }
}

// MARK: - UISearchController settings
extension ListChannelViewController: UISearchResultsUpdating, UISearchBarDelegate {
    /// Updating search results
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    /// `Cancel` button actions
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        fetchChannels()
        searchBar.endEditing(true)
    }
    /// Filtering an array by request
    private func filterContentForSearchText(_ searchText: String) {
        var searchBarIsEmpty: Bool {
            guard let text = searchController.searchBar.text else { return true }
            return text.isEmpty
        }
        
        var isFiltering: Bool {
            return searchController.isActive && !searchBarIsEmpty
        }
        
        if isFiltering {
            channels = channels.filter({ (channel: Channel) -> Bool in
                return channel.nameRu.lowercased().contains(searchText.lowercased())
            })
        } else {
            fetchChannels()
        }
    }
}
