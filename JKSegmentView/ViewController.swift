//
//  ViewController.swift
//  JKSegmentView
//
//  Created by Jitendra Solanki on 7/26/17.
//  Copyright © 2017 jitendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController , JKSegmentViewDelegate {
    @IBOutlet weak var segmentView: JKSegmentView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        segmentView.setupViewWithSegments(segments: ["Today","Tomorrow"])
        segmentView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didSelectSegmentAt(index segmentIndex: Int, view segmentView: JKSegmentView) {
         print("delegate worked")
    }
}

