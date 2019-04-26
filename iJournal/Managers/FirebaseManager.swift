//
//  FirebaseManager.swift
//  Tiki
//
//  Created by Carlos Pendola on 4/2/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import OneSignal
import Firebase
import JGProgressHUD
import CoreLocation

class FirebaseManager {
    
    let my_firebase_storage_bucket = "tiki-31a2e.appspot.com"
    let db = Firestore.firestore()
    // MARK: - Shared instance
    static let shared = FirebaseManager()
    
    // MARK: - Params
    var loggedInUser: User? {
        return Auth.auth().currentUser
    }
    var loggedInUserProfile: UserProfile? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LoggedInUserProfileUpdated"), object: nil)
        }
    }
    
    var userEntries: [Entry] = [] {
        didSet {
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "stampsUpdated"), object: nil)
        }
    }
    
    var lastQrCode:String = ""
    // MARK: - ProfileControl
    func fetchLoggedInUserProfile(completion: @escaping (Bool) -> Void) {
        guard let user = loggedInUser else {
            print("Logged-in user profile not fetched. No logged in user.")
            completion(false)
            return
        }
        db.collection("profiles").whereField("userUID", isEqualTo: user.uid).addSnapshotListener { (queryResult, error) in
            let docSnapshot = queryResult?.documents.first
            if error != nil {
                print("Error fetching logged-in user's profile: \((error, error!.localizedDescription))")
                completion(false)
            } else if docSnapshot?.data() == nil {
                print("ERROR: The logged in user profile was nil.")
                completion(false)
            } else {
                guard let docSnapshot = docSnapshot else { print("Document snapshot was nil when fetching logged in user profile") ; completion(false) ; return }
                let profile = UserProfile(documentSnapshot: docSnapshot)
                
                self.loggedInUserProfile = profile
                completion(true)
            }
        }
    }
    
    func checkIfUsernameIsUnique(username: String, completion: @escaping (Bool, Error?) -> Void) {
        db.collection("profiles").whereField("username", isEqualTo: username).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying usernames: \((error, error.localizedDescription))")
                completion(false, error)
            } else {
                guard let querySnapshot = querySnapshot else { print("Query snapshot was nil") ; completion(false, nil) ; return }
                if querySnapshot.documents.isEmpty == true {
                    // Username is unique
                    completion(true, nil)
                } else {
                    // Username is not unique
                    completion(false, nil)
                }
            }
        }
    }
    
    func generateUniqueUsername(completion: @escaping (Bool, String?) -> Void) {
        let username = "User \(String(UUID().uuidString.suffix(6)))"
        checkIfUsernameIsUnique(username: username) { (usernameIsUnique, error) in
            if let error = error {
                print("Error checking if username was unique: \((error, error.localizedDescription))")
                completion(false, nil)
                return
            } else if usernameIsUnique {
                completion(true, username)
            } else {
                // Username is not unique
                self.generateUniqueUsername(completion: { success, username  in
                    completion(success, username)
                })
            }
        }
    }
    
    func createAndUploadProfileForLoggedInUser(username: String, completion: @escaping (Bool) -> Void) {
        guard let user = loggedInUser else { print("Profile not created. No logged in user.") ; completion(false) ; return }
        let permissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let profile = UserProfile(username: username, userUID: user.uid,  pushNotificationID: permissionSubscriptionState?.subscriptionStatus.userId, entries:[], profile_image: "" )
        getProfileReferenceWith(uid: user.uid) { (existingProfileReference) in
            // If profile with uid already exists update only the reference to the user.
            if existingProfileReference != nil {
                print("Profile already exists. Updating profile userUID to google userUID.")
                existingProfileReference!.updateData([
                    "userUID" : profile.userUID
                    ], completion: { error in
                        if let error = error {
                            print("Error updating profile uid: \((error, error.localizedDescription))")
                            completion(false)
                        } else {
                            completion(true)
                        }
                })
            } else {
                self.db.collection("profiles").document().setData(profile.dictionaryRepresentation()) { error in
                    if let error = error {
                        print("Error adding user: \((error, error.localizedDescription))")
                        completion(false)
                    } else {
                        print("Successfully added profile!")
                        completion(true)
                    }
                }
            }
        }
    }
    
    func getProfileWith(references: [DocumentReference], completion: @escaping ([UserProfile]) -> Void) {
        var profiles = [UserProfile]()
        let dispatchGroup = DispatchGroup()
        for reference in references {
            dispatchGroup.enter()
            reference.getDocument { (documentSnapshot, error) in
                if let error = error {
                    print("Error getting document with reference: \((error, error.localizedDescription))")
                    completion([])
                } else {
                    guard let documentSnapshot = documentSnapshot,
                        let profile = UserProfile(documentSnapshot: documentSnapshot) else { print("Unable to init User Profile.") ; completion([]) ; return }
                    profiles.append(profile)
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(profiles)
        }
    }
    
    func getProfilesWith(keyword: String, completion: @escaping ([UserProfile]) -> Void) {
        let lowercased = keyword.lowercased()
        db.collection("profiles").whereField("usernameCaseInsensitive", isEqualTo: lowercased).getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error querying users by username: \((error, error!.localizedDescription))")
                completion([])
            } else if querySnapshot?.documents == nil {
                print("No documents returned.")
                completion([])
            } else {
                var profiles: [UserProfile] = []
                for profileDoc in querySnapshot!.documents {
                    guard let profile = UserProfile(documentSnapshot: profileDoc) else { print("Unable to init User Profile.") ; completion([]) ; return }
                    profiles.append(profile)
                }
                completion(profiles)
            }
        }
    }
    
    func getProfileReferenceWith(uid: String, completion: @escaping (DocumentReference?) -> Void) {
        db.collection("profiles").whereField("userUID", isEqualTo: uid).getDocuments(completion: { (querySnapshot, error) in
            let docSnapshot = querySnapshot?.documents.first
            if error != nil {
                print("Error getting profile with that uid or no profile exists yet: \((error, error!.localizedDescription))")
                completion(nil)
            } else if docSnapshot?.exists == false || docSnapshot == nil {
                print("That profile doesn't exist yet.")
                completion(nil)
            } else {
                completion(docSnapshot?.reference)
            }
        })
    }
    
    /// This will add the logged-in profile to the target profile's followers array in database & the target profile to the logged-in user's following array.
    func follow(profile: UserProfile, completion: @escaping (Bool) -> Void) {
        guard let profileToFollowRef = profile.documentRef,
            let loggedInProfileRef = loggedInUserProfile?.documentRef else { print("A reference was missing") ; return }
        profileToFollowRef.updateData([
            "followers" : FieldValue.arrayUnion([loggedInProfileRef])
        ]) { error in
            if let error = error {
                print("Error updating target user's follower array: \((error, error.localizedDescription))")
                completion(false)
                return
            } else {
                print("Successfully updated target user's follower array")
                loggedInProfileRef.updateData([
                    "following" : FieldValue.arrayUnion([profileToFollowRef])
                ]) { error in
                    if let error = error {
                        print("Error updating logged-in user's following array: \((error, error.localizedDescription))")
                        completion(false)
                    } else {
                        print("Successfully updated logged-in user's following array")
                        guard let pushNotificationID = profile.pushNotificationID else { print("No pushNotificationID. Not notifying.") ; completion(true) ; return }
                        PushNotificationManager.shared.notifyProfileWith(playerId: pushNotificationID, followerUsername: self.loggedInUserProfile?.username ?? "Somebody")
                        completion(true)
                    }
                }
            }
        }
    }
    
    /// This will remove the logged-in profile from the target profile's followers array in database & remove the target profile from the logged-in user's following array.
    func unfollow(profile: UserProfile, completion: @escaping (Bool) -> Void) {
        guard let profileToUnfollowRef = profile.documentRef,
            let loggedInProfileRef = loggedInUserProfile?.documentRef else { print("A reference was missing") ; return }
        profileToUnfollowRef.updateData([
            "followers" : FieldValue.arrayRemove([loggedInProfileRef])
        ]) { error in
            if let error = error {
                print("Error updating target user's follower array: \((error, error.localizedDescription))")
                completion(false)
                return
            } else {
                print("Successfully updated target user's follower array")
                loggedInProfileRef.updateData([
                    "following" : FieldValue.arrayRemove([profileToUnfollowRef])
                ]) { error in
                    if let error = error {
                        print("Error updating logged-in user's following array: \((error, error.localizedDescription))")
                        completion(false)
                    } else {
                        print("Successfully updated logged-in user's following array")
                        completion(true)
                    }
                }
            }
        }
    }
    

    func createUserAndProfileWith(username: String, email: String, password: String, completion: @escaping (Bool, Bool, String?) -> Void) {
        self.checkIfUsernameIsUnique(username: username) { usernameIsUnique, error in
            if let error = error {
                print("Error checking if username was unique: \((error, error.localizedDescription))")
            } else if usernameIsUnique {
                Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
                    if let error = error {
                        print("Error creating user: \((error, error.localizedDescription))")
                        self.handleError(error: error, shouldNotify: { (shouldNotify, message) in
                            completion(false, shouldNotify, message)
                            return
                        })
                    } else {
                        self.createAndUploadProfileForLoggedInUser(username: username, completion: { (success) in
                            if success {
                                completion(true, false, nil)
                            } else {
                                completion(false, true, "An error occurred.")
                            }
                        })
                    }
                }
            } else {
                completion(false, true, "That username is already in use.")
            }
        }
    }
    
    func signInWith(email: String, password: String, completion: @escaping (Bool, Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                print("Error signing in: \((error, error.localizedDescription))")
                self.handleError(error: error, shouldNotify: { (shouldNotify, message) in
                    completion(false, shouldNotify, message)
                    return
                })
            } else {
                completion(true, false, nil)
            }
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            self.loggedInUserProfile = nil
            completion(nil)
        } catch {
            print("There was an error signing out \(error.localizedDescription)")
            completion(error)
        }
    }
    
    func updateUserName(to newUsername: String, completion: @escaping (Error?) -> Void) {
        self.loggedInUserProfile?.documentRef?.updateData(["username": newUsername], completion: completion)
        self.loggedInUserProfile?.documentRef?.updateData(["usernameCaseInsensitive" : newUsername], completion: completion)
    }
    
    
    
   func handleError(error: Error, shouldNotify: @escaping (Bool, String?) -> Void) {
        guard let code = AuthErrorCode(rawValue: error._code) else { print("There was no error code from error.") ; return }
        let genericIncorrectCredentialsMessage = "We couldn't find an account with that info."
        // Cases marked should notify user
        switch code {
        case .invalidCustomToken:
            print("ERROR: A validation error with the custom token")
            shouldNotify(false, nil)
            return
        case .customTokenMismatch:
            print("ERROR: The service account and the API key belong to different projects")
            shouldNotify(false, nil)
            return
        case .invalidCredential:
            print("ERROR: The IDP token or requestUri is invalid")
            shouldNotify(false, nil)
            return
        case .userDisabled:
            print("ERROR: The user's account is disabled on the server")
            shouldNotify(false, nil)
            return
        case .operationNotAllowed:
            print("ERROR: The administrator disabled sign in with the specified identity provider")
            shouldNotify(false, nil)
            return
        case .emailAlreadyInUse:
            print("ERROR: The email used to attempt a sign up is already in use.")
            shouldNotify(true, "That email is already in use. Try logging in.")
            return
        case .invalidEmail:
            // Notify
            print("ERROR: The email is invalid")
            shouldNotify(true, "There's an issue with the email you entered.")
            return
        case .wrongPassword:
            // Notify
            print("ERROR: The user attempted sign in with a wrong password")
            shouldNotify(true, genericIncorrectCredentialsMessage)
            return
        case .tooManyRequests:
            // Notify
            print("ERROR: That too many requests were made to a server method")
            shouldNotify(true, "Login is locked (too many server requests)")
            return
        case .userNotFound:
            // Notify
            print("ERROR: The user account was not found")
            shouldNotify(true, genericIncorrectCredentialsMessage)
            return
        case .accountExistsWithDifferentCredential:
            // Notify
            print("ERROR: Account linking is required. Account exists with different credentials.")
            shouldNotify(true, genericIncorrectCredentialsMessage)
            return
        case .requiresRecentLogin:
            print("ERROR: The user has attemped to change email or password more than 5 minutes after signing in")
            shouldNotify(false, nil)
            return
        case .providerAlreadyLinked:
            print("ERROR: An attempt to link a provider to which the account is already linked")
            shouldNotify(false, nil)
            return
        case .noSuchProvider:
            print("ERROR: An attempt to unlink a provider that is not linked")
            shouldNotify(false, nil)
            return
        case .invalidUserToken:
            print("ERROR: User's saved auth credential is invalid, the user needs to sign in again")
            shouldNotify(false, nil)
            return
        case .networkError:
            // Notify
            print("ERROR: A network error occurred (such as a timeout, interrupted connection, or unreachable host). These types of errors are often recoverable with a retry. The @cNSUnderlyingError field in the @c NSError.userInfo dictionary will contain the error encountered")
            shouldNotify(true, "The network crapped out.")
            return
        case .userTokenExpired:
            print("ERROR: The saved token has expired, for example, the user may have changed account password on another device. The user needs to sign in again on the device that made this request")
            shouldNotify(false, nil)
            return
        case .invalidAPIKey:
            print("ERROR: An invalid API key was supplied in the request")
            shouldNotify(false, nil)
            return
        case .userMismatch:
            print("ERROR: An attempt was made to reauthenticate with a user which is not the current user")
            shouldNotify(false, nil)
            return
        case .credentialAlreadyInUse:
            // Notify
            print("ERROR: An attempt to link with a credential that has already been linked with a different Firebase account")
            shouldNotify(false, nil)
            return
        case .weakPassword:
            // Notify
            print("ERROR: An attempt to set a password that is considered too weak")
            shouldNotify(true, "That password is too weak.")
            return
        case .appNotAuthorized:
            print("ERROR: App is not authorized to use Firebase Authentication with the provided API Key")
            shouldNotify(false, nil)
            return
        case .keychainError:
            // Notify
            print("ERROR: Error occurred while attempting to access the keychain")
            shouldNotify(true, "We were unable to access your keychain.")
            return
        default:
            print("ERROR: An internal error occurred")
            shouldNotify(false, nil)
            return
        }
    }
    
    
    
    
    //**iJOURNAL**/
    func addEntry(completion: @escaping (Bool) -> Void) {
        
        guard let loggedInProfileRef = loggedInUserProfile?.documentRef else {
            print("A reference was missing")
            return
        }
        
        // This is an array of dictionaries.
        var dictionaries = [[String: Int]]()
        
        // Create a dictionary and add it to the array.
        let dictionary1: [String: Int] = ["cat": 100]
        dictionaries.append(dictionary1)
        
        // Create another dictionary.
        let dictionary2: [String: Int] = ["dog": 200]
        dictionaries.append(dictionary2)
        
        
        
        let entry = Entry(userUID: "userid", profile_id: loggedInProfileRef, documentRef:nil, documentID: "prueba no mas", data: dictionaries, date: Date())
        
        self.db.collection("entries").document().setData(entry.dictionaryRepresentation()) { error in
            if let error = error {
                print("Error adding entry: \((error, error.localizedDescription))")
                completion(false)
            } else {
                print("Successfully added entry!")
                completion(true)
            }
        }
    }
    
    
    
    
    func getUserEntries( completion: @escaping (Bool) -> Void) {
        print("getUserEntries")
        guard let profileRef = loggedInUserProfile?.documentRef
        else {
            print("No logged in user")
            completion(false)
            return
        }
        db.collection("entries").whereField("profile_id", isEqualTo: profileRef).addSnapshotListener { (querySnapshot, error) in
            if querySnapshot?.documents == nil || error != nil {
                print("Error querying entries: \((error, error!.localizedDescription))")
                completion(false)
            } else {
                self.userEntries = []
                for doc in querySnapshot!.documents {
                    if let stamps = Entry(documentSnapshot: doc) {
                        self.userEntries.append(stamps)
                    }
                }
                completion(true)
            }
        }
    }
    
    
    
    func uploadAudioToFirebase(fileUrl: URL , completion: @escaping (Bool) -> Void) {
        print("uploadAudioToFirebase")
        print(fileUrl)
        
        //let fileUrl = self.getAudioFileURL()
        let storage = Storage.storage()
        let metadata = StorageMetadata()
        
        
        metadata.contentType = "audio/mp4"
        //let refStr = (Auth.auth().currentUser?.email)! + "|" + "\(NSUUID().uuidString)" + "|" + "recording.m4a"
        //let pathStr = "Messages/\(NSUUID().uuidString)/\(refStr)"
        //let uploadRef = storage.reference().child(pathStr)
        let storageRef = Storage.storage().reference().child("audioNotes").child("recording.m4a")
        storageRef.putFile(from: fileUrl, metadata: nil) { metadata,
            error in
            if error == nil {
                print("Successfully Uploaded Audio")
                completion(true)
                return
                /*let downloadUrl = (metadata?.downloadURL())!
                print("URL: \(downloadUrl)")
                
                var messageInfoArray = refStr.components(separatedBy: "|")
                let messageDict = ["Sender": messageInfoArray[0], "MessageBody": "recording-audioRecorded", "AudioURL": "\(pathStr)", "AudioID": messageInfoArray[1], "IsAudio": "\(NSUUID().uuidString)-True"]
                
                let childUpdates = ["Mensagens/\(messageInfoArray[1])": messageDict]
                Database.database().reference().updateChildValues(childUpdates)*/
                
            }
            else {
                dump(metadata)
                print("UploadError \(String(describing: error?.localizedDescription))")
                completion(false)
                return
            }
        }
    }
    
    func getAudioFileURL() -> URL {
        return getDirectory().appendingPathComponent(".m4a")
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
}


