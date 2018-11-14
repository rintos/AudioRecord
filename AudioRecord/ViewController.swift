//
//  ViewController.swift
//  AudioRecord
//
//  Created by Victor on 07/11/2018.
//  Copyright © 2018 Rinver. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var botaoGravar: UIButton!
    @IBOutlet weak var botaoPlay: UIButton!
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    
    var fileName : String = "audioFile.m4a"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        botaoPlay.isEnabled = false
        
    }
    
    func getDocumentsDirector() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    //iniciando a gravacao
    func setupRecorder(){
        let audioFileName = getDocumentsDirector().appendingPathComponent(fileName)
        let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey : 320000,
                              AVNumberOfChannelsKey: 2,
                              AVSampleRateKey : 44100.2 ] as [ String : Any]
        do {
            soundRecorder = try AVAudioRecorder(url: audioFileName, settings: recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    //play no audio
    func setupPlayer(){
        let audioFileName = getDocumentsDirector().appendingPathComponent(fileName)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileName)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 3.0
        } catch {
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        botaoPlay.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        botaoGravar.isEnabled = true
        botaoPlay.setTitle("Play", for: .normal)
        
    }
    
    @IBAction func gravarAction(_ sender: Any) {
        if botaoGravar.titleLabel?.text == "Record" {
            soundRecorder.record()
            botaoGravar.setTitle("Stop", for: .normal)
            botaoPlay.isEnabled = false
        } else {
            soundRecorder.stop()
            botaoGravar.setTitle("Record", for: .normal)
            botaoPlay.isEnabled = false
        }
    }
        
    @IBAction func playAction(_ sender: Any) {
        if botaoPlay.titleLabel?.text == "Play" {
            botaoPlay.setTitle("Stop", for: .normal)
            botaoGravar.isEnabled = false
            setupPlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            botaoPlay.setTitle("Play", for: .normal)
            botaoGravar.isEnabled = false
        }
        
        
    }
    

}

