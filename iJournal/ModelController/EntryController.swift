//
//  EntryController.swift
//  JustLayout
//
//  Created by Colin Smith on 4/29/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit


class EntryController {
    
    static let shared = EntryController()
    var entries: [Entry] =   [Entry]()
    
    /*var entries: [Entry] = [Entry(title: "Pulp Fiction", date: "20 April 1996", content: [
        Element(info: "Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?", file: .text),
        Element(info: UIImage(named: "samuel") as Any, file: .image),
        Element(info: "Your bones don't break, mine do. That's clear. Your cells react to bacteria and viruses differently than mine. You don't get sick, I do. That's also clear. But for some reason, you and I react the exact same way to water. We swallow it too fast, we choke. We get some in our lungs, we drown. However unreal it may seem, we are connected, you and I. We're on the same curve, just on opposite ends.", file: .text),
        Element(info: UIImage(named: "pulp"), file: .image),
        Element(info: "The path of the righteous man is beset on all sides by the inequities of the selfish and the tyranny of evil men. Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of darkness, for he is truly his brother's keeper and the finder of lost children. And I will strike down upon thee with great vengeance and furious anger those who attempt to poison and destroy my brothers. And you will know my name is the Lord when I lay my vengeance upon thee.", file: .text)
        
        ]),
        Entry(title: "Bob Ross Happy Trees", date: "20 April 1984", content: [
            Element(info: "We'll put all the little clouds in and let them dance around and have fun. We'll put some happy little leaves here and there. It's important to me that you're happy. This is gonna be a happy little seascape. Now we don't want him to get lonely, so we'll give him a little friend. We'll put a happy little sky in here. Trees grow in all kinds of ways. They're not all perfectly straight. Not every limb is perfect.Let's make some happy little clouds in our world. Let's put some highlights on these little trees. The sun wouldn't forget them. Now we can begin working on lots of happy little things.", file: .text),
            Element(info: UIImage(named: "bobross") as Any, file: .image),
            Element(info: "Put it in, leave it alone. We'll do another happy little painting. That's the way I look when I get home late; black and blue. Didn't you know you had that much power? You can move mountains. You can do anything. When you buy that first tube of paint it gives you an artist license. We start with a vision in our heart, and we put it on canvas. Just let these leaves jump off the brush.", file: .text)
            ]),
        Entry(title: "Endgame Spoilers", date: "26 April 2019", content: [Element(info: "At the end of “Ant-Man and the Wasp,” Scott Lang (Paul Rudd) got stuck in the Quantum Realm. He gets out thanks to a curious rat, but Scott arrives back in a San Francisco where five years have passed since the snap and everyone is still recovering from half the population going poof. Worrying about what happened to his daughter Cassie, Scott races to find her and then discovers she’s five years older. “You're so big!” Scott says, a sly reference to his own size-changing abilities.", file: .text),Element(info: UIImage(named: "scott") as Any, file: .image), Element(info: "Cap’s assignment in the Avengers' time heist is to make off with Loki’s scepter (hosting the Mind Stone) during the alien invasion from the original “Avengers” film. The best bit, though, is the callback to the elevator fight scene in “Captain America: The Winter Soldier.” Instead of throwing down with a bunch of baddies, this time Cap knows the code: He says, “Hail Hydra” to one of them, so that he can get off the lift with the stone without a scuffle. Unfortunately, after he's out, he encounters his past self, kicking off some serious fisticuffs.", file: .text),Element(info: UIImage(named: "cap") as Any, file: .image)])
        
    ]*/
    
    
    
    
    //CRUD
    
    
    
    
    func createNewEntryWith(title: String, date: String){
        //let newTitle = Entry(title: title, date: date)
        //entries.append(newTitle)
    }
    
    func updateEntry(newTitle: String, addedContent: Element, entryToUpdate: Entry){
        //entryToUpdate.title = newTitle
        //entryToUpdate.content.append(addedContent)
    }
    
    /*
     func fileURL() -> URL {
     let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
     let documentDirectory = filePath[0]
     let fileName = "iJournal.json"
     let fullURL = documentDirectory.appendingPathComponent(fileName)
     
     return fullURL
     }
     
     func saveToPersistentStore() {
     let encoder = JSONEncoder()
     do{
     let data = try encoder.encode(entries)
     
     try data.write(to: fileURL())
     }catch{
     print("There was error saving to Persistnt Store \(error) \(error.localizedDescription)")
     
     }
     }
     func loadFromPersistentStore(){
     do{
     let data = try Data(contentsOf: fileURL())
     let decoder = JSONDecoder()
     let entries = try decoder.decode([Entry].self, from: data)
     self.entries = entries
     }catch{
     print("There was error loading from persistent store \(error) \(error.localizedDescription)")
     }
     }*/
    
    
    func fetchImage(url:String, count:Int, completion: @escaping(UIImage?, Int) -> Void ){
        guard let baseImageURL = URL(string: url) else{
            completion(nil,count)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: baseImageURL) { (data, _, error) in
            if let error = error {
                print("Error fetching an image \(error) : \(error.localizedDescription)")
                completion(nil,count)
                return
            }
            guard let data = data else{
                completion(nil,count)
                return
            }
            
            let image = UIImage(data:data)
            completion(image,count)
        }
        dataTask.resume()
    }
}
