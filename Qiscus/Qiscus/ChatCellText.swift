//
//  ChatCellText.swift
//  qonsultant
//
//  Created by Ahmad Athaullah on 7/21/16.
//  Copyright © 2016 qiscus. All rights reserved.
//

import UIKit

public enum CellPosition {
    case left, right
}
public enum CellTypePosition {
    case single,first,middle,last
}
open class ChatCellText: UITableViewCell {
    
    var firstComment:Bool = true
    let maxWidth:CGFloat = 190
    let minWidth:CGFloat = 80
    let defaultDateLeftMargin:CGFloat = -5
    var indexPath:IndexPath?
    
    var screenWidth:CGFloat{
        get{
            return UIScreen.main.bounds.size.width
        }
    }
    var linkTextAttributesLeft:[String: Any]{
        get{
            return [
                NSForegroundColorAttributeName: QiscusColorConfiguration.sharedInstance.leftBaloonLinkColor,
                NSUnderlineColorAttributeName: QiscusColorConfiguration.sharedInstance.leftBaloonLinkColor,
                NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
            ]
        }
    }
    var linkTextAttributesRight:[String: AnyObject]{
        get{
            return [
            NSForegroundColorAttributeName: QiscusColorConfiguration.sharedInstance.rightBaloonLinkColor,
            NSUnderlineColorAttributeName: QiscusColorConfiguration.sharedInstance.rightBaloonLinkColor,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue as AnyObject
            ]
        }
    }
    @IBOutlet weak var baloonView: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarImageBase: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    @IBOutlet weak var textViewWidth: NSLayoutConstraint!
    @IBOutlet weak var dateLabelRightMargin: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textLeading: NSLayoutConstraint!
    @IBOutlet weak var statusTrailing: NSLayoutConstraint!
    @IBOutlet weak var avatarLeading: NSLayoutConstraint!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var balloonTopMargin: NSLayoutConstraint!
    @IBOutlet weak var userNameLeading: NSLayoutConstraint!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        textView.contentInset = UIEdgeInsets.zero
        statusImage.contentMode = .scaleAspectFit
        avatarImage.layer.cornerRadius = 19
        avatarImage.clipsToBounds = true
        avatarImage.isHidden = true
        avatarImage.contentMode = .scaleAspectFill
     }
    
    open func setupCell(_ comment: QiscusComment, last:Bool, position:CellPosition, cellTypePos: CellTypePosition? = nil){
        baloonView.image = ChatCellText.balloonImage(cellVPos: cellTypePos)
        let user = comment.sender
        let avatar = Qiscus.image(named: "in_chat_avatar")
        avatarImage.image = avatar
        avatarImage.isHidden = true
        avatarImageBase.isHidden = true
        userNameLabel.text = ""
        userNameLabel.isHidden = true
        balloonTopMargin.constant = 0
        cellHeight.constant = 0
        if cellTypePos != nil{
            if cellTypePos == .first || cellTypePos == .single{
                userNameLabel.text = user?.userFullName
                userNameLabel.isHidden = false
                balloonTopMargin.constant = 20
                cellHeight.constant = 20
            }
        }
        if last {
            baloonView.image = ChatCellText.balloonImage(withPosition: position,cellVPos: cellTypePos)
            avatarImageBase.isHidden = false
            avatarImage.isHidden = false
            if user != nil{
                avatarImage.loadAsync(user!.userAvatarURL, placeholderImage: avatar)
            }
        }
        textView.isUserInteractionEnabled = false
        textView.text = comment.commentText as String
        dateLabel.text = comment.commentTime.lowercased()
        let textSize = textView.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        
        textViewHeight.constant = textSize.height
        
        var textWidth = textSize.width
        if textSize.width > minWidth {
            textWidth = textSize.width
        }else{
            textWidth = minWidth
        }
        
        textViewWidth.constant = textWidth
        textLeading.constant = 8
        
        if position == .left {
            avatarLeading.constant = 0
            if last {
                leftMargin.constant = 34
                textLeading.constant = 23
            }else{
                leftMargin.constant = 49
            }
            userNameLabel.textAlignment = .left
            userNameLeading.constant = 53
            baloonView.tintColor = QiscusColorConfiguration.sharedInstance.leftBaloonColor
            textView.textColor = QiscusColorConfiguration.sharedInstance.leftBaloonTextColor
            textView.linkTextAttributes = linkTextAttributesLeft
            dateLabel.textColor = QiscusColorConfiguration.sharedInstance.leftBaloonTextColor
            dateLabelRightMargin.constant = defaultDateLeftMargin
            statusImage.isHidden = true
        }else{
            avatarLeading.constant = screenWidth - 64
            if last {
                avatarImageBase.isHidden = false
                leftMargin.constant = screenWidth - textWidth - 84
                dateLabelRightMargin.constant = -35
                statusTrailing.constant = -20
            }else{
                leftMargin.constant = screenWidth - textWidth - 99
                dateLabelRightMargin.constant = -20
                statusTrailing.constant = -5
            }
            userNameLabel.textAlignment = .right
            userNameLeading.constant = screenWidth - 275
            baloonView.tintColor = QiscusColorConfiguration.sharedInstance.rightBaloonColor
            textView.textColor = QiscusColorConfiguration.sharedInstance.rightBaloonTextColor
            textView.linkTextAttributes = linkTextAttributesRight
            dateLabel.textColor = QiscusColorConfiguration.sharedInstance.rightBaloonTextColor
            statusImage.isHidden = false
            statusImage.tintColor = QiscusColorConfiguration.sharedInstance.rightBaloonTextColor

            if comment.commentStatus == QiscusCommentStatus.sending {
                dateLabel.text = QiscusTextConfiguration.sharedInstance.sendingText
                statusImage.image = Qiscus.image(named: "ic_info_time")?.withRenderingMode(.alwaysTemplate)
            }else if comment.commentStatus == .sent {
                statusImage.image = Qiscus.image(named: "ic_sending")?.withRenderingMode(.alwaysTemplate)
            }else if comment.commentStatus == .delivered{
                statusImage.image = Qiscus.image(named: "ic_read")?.withRenderingMode(.alwaysTemplate)
            }else if comment.commentStatus == .read{
                statusImage.tintColor = UIColor.green
                statusImage.image = Qiscus.image(named: "ic_read")?.withRenderingMode(.alwaysTemplate)
            }else if comment.commentStatus == .failed {
                dateLabel.text = QiscusTextConfiguration.sharedInstance.failedText
                dateLabel.textColor = QiscusColorConfiguration.sharedInstance.failToSendColor
                statusImage.image = Qiscus.image(named: "ic_warning")?.withRenderingMode(.alwaysTemplate)
                statusImage.tintColor = QiscusColorConfiguration.sharedInstance.failToSendColor
            }
            
        }
        dateLabel.layer.zPosition = 22
        textView.layer.zPosition = 23
        statusImage.layer.zPosition = 24
        textView.layoutIfNeeded()
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    open class func calculateRowHeightForComment(comment: QiscusComment) -> CGFloat {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.dataDetectorTypes = .all
        textView.linkTextAttributes = [
            NSForegroundColorAttributeName: QiscusColorConfiguration.sharedInstance.rightBaloonLinkColor,
            NSUnderlineColorAttributeName: QiscusColorConfiguration.sharedInstance.rightBaloonLinkColor,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
        ]
        
        let maxWidth:CGFloat = 190
        var estimatedHeight:CGFloat = 110
        
        textView.text = comment.commentText
        let textSize = textView.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        
        estimatedHeight = textSize.height + 18
        
        return estimatedHeight
    }
    open class func balloonImage(withPosition position:CellPosition? = nil, cellVPos:CellTypePosition? = nil)->UIImage?{
        var balloonEdgeInset = UIEdgeInsetsMake(13, 13, 13, 13)
        var balloonImage = Qiscus.image(named:"text_balloon_left")?.resizableImage(withCapInsets: balloonEdgeInset, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
        if position != nil {
            if position == .left {
                balloonEdgeInset = UIEdgeInsetsMake(13, 28, 13, 13)
                if cellVPos != nil {
                    if cellVPos == .last {
                        balloonImage = Qiscus.image(named:"text_balloon_last_l")?.resizableImage(withCapInsets: balloonEdgeInset, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
                    }else{
                        balloonImage = Qiscus.image(named:"text_balloon_left")?.resizableImage(withCapInsets: balloonEdgeInset, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
                    }
                }else{
                    balloonImage = Qiscus.image(named:"text_balloon_left")?.resizableImage(withCapInsets: balloonEdgeInset, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
                }
            }else{
                balloonEdgeInset = UIEdgeInsetsMake(13, 13, 13, 28)
                if cellVPos != nil {
                    if cellVPos == .last {
                        balloonImage = Qiscus.image(named:"text_balloon_last_r")?.resizableImage(withCapInsets: balloonEdgeInset, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
                    }else{
                        balloonImage = Qiscus.image(named:"text_balloon_right")?.resizableImage(withCapInsets: balloonEdgeInset, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
                    }
                }else{
                    balloonImage = Qiscus.image(named:"text_balloon_right")?.resizableImage(withCapInsets: balloonEdgeInset, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
                }
            }
        }else{
            if cellVPos != nil{
                if cellVPos == .first{
                    balloonImage = Qiscus.image(named:"text_balloon_first")?.resizableImage(withCapInsets: balloonEdgeInset, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
                }else if cellVPos == .middle{
                    balloonImage = Qiscus.image(named:"text_balloon_mid")?.resizableImage(withCapInsets: balloonEdgeInset, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
                }
            }else{
                balloonImage = Qiscus.image(named:"text_balloon")?.resizableImage(withCapInsets: balloonEdgeInset, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
            }
            
        }
        return balloonImage
    }
    open override func becomeFirstResponder() -> Bool {
        return true
    }
    open func resend(){
        if QiscusCommentClient.sharedInstance.commentDelegate != nil{
            QiscusCommentClient.sharedInstance.commentDelegate?.performResendMessage(onIndexPath: self.indexPath!)
        }
    }
    open func deleteComment(){
        if QiscusCommentClient.sharedInstance.commentDelegate != nil{
            QiscusCommentClient.sharedInstance.commentDelegate?.performDeleteMessage(onIndexPath: self.indexPath!)
        }
    }
}
