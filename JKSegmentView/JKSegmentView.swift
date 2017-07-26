//
//  JKSegmentView.swift
//  JKDropDownList
//
//  Created by Jitendra Solanki on 7/26/17.
//  Copyright © 2017 jitendra. All rights reserved.
//

import UIKit

protocol JKSegmentViewDelegate:class {
    func didSelectSegmentAt(index segmentIndex:Int,view segmentView:JKSegmentView)
}
class JKSegmentView: UIView {

    let BASETAG_VALUE = 100
    let BOTTOM_BORDER_VIEW_TAG = 300
    let INDICATOR_VIEW_TAG = 305
    var currentSelectedSegmentTag = 0
    var previousSelectedSegmentTag = 0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     */
    
    @IBInspectable var segmentTitleColor:UIColor?
    @IBInspectable var segmentSelectedTitleColor:UIColor?
    @IBInspectable var segmentBackgroundColor:UIColor?
    @IBInspectable var segmentSelectedBackgroundColor:UIColor?
    @IBInspectable var borderTintColor:UIColor?
    @IBInspectable var indicatorColor:UIColor?
    
    @IBInspectable var selectedIndex:Int = 0
    
    
    weak var delegate:JKSegmentViewDelegate?
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    
    override init(frame: CGRect) {
         super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
    
    
    //MARK:- Default setup
    func setupViewWithSegments(segments:[String]){
         //width for each segment
        let width = self.frame.size.width / CGFloat(segments.count)
        
        for i in 0...(segments.count-1){
            
            
            if let _ = self.viewWithTag(BASETAG_VALUE + i)as? UIButton{
                continue
            }else{
                
               let btn = UIButton(frame: CGRect(x: width * CGFloat(i), y: 0, width: width, height: self.frame.size.height))
               
               btn.setTitle(segments[i], for: .normal)
               btn.setTitleColor(segmentTitleColor, for: .normal)
               btn.backgroundColor = segmentBackgroundColor
               btn.tag = BASETAG_VALUE + i
               btn.addTarget(self, action: #selector(segmentSelected(sender:)), for: .touchUpInside)
               self.addSubview(btn)
           
         }
            
        }
        
        setBottomBorderView()
        setSegmentSelectedFor(tag: BASETAG_VALUE+selectedIndex)
    }
    
    private func setBottomBorderView(){
        
        var borderView:UIView!
        
        if let borderV = self.viewWithTag(BOTTOM_BORDER_VIEW_TAG){
            borderView = borderV
        }else{
            borderView = UIView()
            borderView.tag = BOTTOM_BORDER_VIEW_TAG
        }
        
        
        var frame = self.bounds
        frame.origin.y += frame.size.height-1
        frame.size.height = 1
        borderView.frame = frame
//        borderView.frame = CGRect(x: 0, y: self.frame.origin.y + self.frame.size.height-1, width:self.frame.origin.x + self.frame.size.width, height: 1)
        borderView.backgroundColor = borderTintColor
        
        self.addSubview(borderView)

    }
    
    func indicatorViewWith(frame:CGRect)->UIView{
        if let indicator = self.viewWithTag(INDICATOR_VIEW_TAG){
            return indicator
        }else{
            let indicatorView = UIView()
            indicatorView.tag = INDICATOR_VIEW_TAG
            indicatorView.backgroundColor = indicatorColor
            indicatorView.frame = CGRect(x:frame.origin.x, y:frame.size.height-1, width: frame.size.width, height:1)
            self.addSubview(indicatorView)
            return indicatorView
        }
    }
    //MARK:- Select a segment
    
    func updateIndicatorViewFor(segment:UIButton){
        //get indicator
        let indicatorV = indicatorViewWith(frame: segment.frame)
    
        
        let centerX = segment.frame.origin.x + segment.frame.size.width/2
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: { 
             indicatorV.center = CGPoint(x: centerX, y:segment.frame.origin.y+segment.frame.size.height)
        }) { (isCompleted) in
             self.isUserInteractionEnabled = true
        }
        
    }
    
    func setSegmentSelectedFor(tag tagvalue:Int){
        

        if let segView = self.viewWithTag(tagvalue)as? UIButton{
            
            previousSelectedSegmentTag = currentSelectedSegmentTag
            currentSelectedSegmentTag = tagvalue
            
            segView.backgroundColor = segmentSelectedBackgroundColor
            segView.setTitleColor(segmentSelectedTitleColor, for: .normal)
            updateIndicatorViewFor(segment: segView)

            //get the prevoius selected segment and set default appearance
            if let lastSelectedSegView = self.viewWithTag(previousSelectedSegmentTag)as? UIButton{
                lastSelectedSegView.backgroundColor = segmentBackgroundColor
                lastSelectedSegView.setTitleColor(segmentTitleColor, for: .normal)
            }
            
        }

    }
    
    func segmentSelected(sender: UIButton){
        if currentSelectedSegmentTag != sender.tag{
         setSegmentSelectedFor(tag: sender.tag)
         delegate?.didSelectSegmentAt(index: BASETAG_VALUE-sender.tag, view: self)
        }
    }
}
