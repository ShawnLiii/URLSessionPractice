//
//  ToDoCollectionViewController.swift
//  URLSessionPractice
//
//  Created by Shawn Li on 5/15/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class ToDoCollectionViewController: UICollectionViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate
{

    var todos = [ToDo]()
    var dataVal = Data()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        getToDoDataSourceByURLSessionDataTask()
        getToDoDataSourceByURLConnection()
    }
    
    //MARK:- URLSession to get Data Source
    func getToDoDataSourceByURLSessionDataTask()
    {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else { return }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data
            {
                do
                {
                    self.todos = try JSONDecoder().decode([ToDo].self, from: data)
                    DispatchQueue.main.async
                    {
                        self.collectionView.reloadData()
                    }
                }
                catch
                {
                    print(error)
                }
            }
        }
        session.resume()
    }
    
    // MARK: - URLConnection
    func getToDoDataSourceByURLConnection()
    {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else { return }
        let request = URLRequest(url: url)
        let connection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
        connection.start()
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data)
    {
        dataVal.append(data)
    }
   
    func connectionDidFinishLoading(_ connection: NSURLConnection)
    {
        do
        {
            self.todos = try JSONDecoder().decode([ToDo].self, from: dataVal)
            
            DispatchQueue.main.async
            {
                self.collectionView.reloadData()
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Collection View configuration
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return todos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todo", for: indexPath) as! ToDoCollectionViewCell
        
        cell.titleTF.text = todos[indexPath.row].title
        cell.idLab.text = String(todos[indexPath.row].id)
        
        if todos[indexPath.row].completed
        {
            cell.contentView.backgroundColor = .systemTeal
        }
        else
        {
            cell.contentView.backgroundColor = .white
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        todos[indexPath.row].completed = !todos[indexPath.row].completed
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
