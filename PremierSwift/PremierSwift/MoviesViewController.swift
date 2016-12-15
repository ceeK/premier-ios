import UIKit

final class MoviesViewController: UITableViewController {
    
    private var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Movies"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(MovieTableViewCell.self)
        
        // Load resource via operation...
        let webservice = Webservice()
        webservice.load(resource: Movie.topMovies) { response in
            switch response {
            case .success(let movies):
                print(movies)
            case .error(let error):
                print(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        
        let cell: MovieTableViewCell = tableView.dequeue(forIndexPath: indexPath)
        cell.configure(title: movie.title, synopsis: movie.synopsis)
    
        return cell
    }
    
}
