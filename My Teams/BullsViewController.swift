//
//  BullsViewController.swift
//  My Teams
//
//  Created by Janet Weber on 2/26/16.
//  Copyright © 2016 Weber Solutions. All rights reserved.
//
// https://forums.developer.apple.com/thread/3544

import UIKit

class BullsViewController: UIViewController,
        UIPickerViewDelegate, UIPickerViewDataSource {

    private var players:[String : [String]]!// dictionary holding player last names and info array
    private var playerNames:[String]!       // array of player last names (dictionary keys)
    private var playerInfo:[String]!        // array of player info (one for each key - first name, nbaID)
    private let URLstart = "http://stats.nba.com/player/#!/" // nba player stat url start
    private let slash = "/"                    // slash
    private let schedURL = "http://i.cdn.turner.com/drp/nba/bulls/sites/default/files/scheduletv_50_1516.pdf"
    
    // declare outlets for picker, webview, and main image
    @IBOutlet weak var playerPicker: UIPickerView!
    @IBOutlet weak var playerWebView: UIWebView!
    @IBOutlet weak var bullsImage: UIImageView!
    
    // ************************************************************************
    override func viewWillAppear(animated: Bool) {
        // reload the view EVERY time tab chosen - otherwise displays last view
        playerWebView.hidden=true
        bullsImage.hidden=false
    }
    
    // ************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // provide access to the plist file for this view cubsplayers.plist and
        // load players dictionary from plist file, then load playerNames array
        // from players dictionary - sorted.
        let bundle = NSBundle.mainBundle()
        let plistURL = bundle.URLForResource("bullsPlayers", withExtension: "plist")
        players = NSDictionary(contentsOfURL: plistURL!) as! [String : [String]]
        let allPlayers = players.keys
        playerNames = allPlayers.sort()
    }
    
    // ************************************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ************************************************************************
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:-
    // MARK: Picker Data Source Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return playerNames.count
    }
    
    // MARK:-
    // MARK: Picker Delegate Methods
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Construct full name for picker to display
        let lname = playerNames[row]
        let fname = players[lname]![0]
        let fullName = fname + " " + lname
        return fullName
    }
    
    // ************************************************************************
    @IBAction func onButtonPressed(sender: AnyObject) {
        // This function displays either the player stat URL or team schedule in the
        // webview.  The player stat url is constructed from picker selection.

        var urlstr : String = ""    // declare/init empty string to hold eventual url to display
        
        if (sender.tag == 1) {      // Player stat button is sender
            let row = playerPicker.selectedRowInComponent(0) // get selection from picker
            let playerLname = playerNames[row]               // get last name (dict key) from playerNames array
            let playerInfo = players[playerLname]            // playerInfo array is value for dict key
            let nbaID = playerInfo![1]                       // get info from playerInfo array to construct
            let statURL = URLstart + nbaID + slash           // url
            urlstr = statURL
        } else {                    // schedule button is sender.
            urlstr = schedURL
        }

        let myURL = NSURL(string: urlstr)                   // load webview and display
        playerWebView.loadRequest(NSURLRequest(URL: myURL!))
        playerWebView.hidden=false
    }  // end of onButtonPressed
}
