# Import file "Framer-Timeslots"
sketchViewInCal = Framer.Importer.load("imported/Framer-Timeslots@1x")
# Import file "Framer-ConfirmationPage"
sketchConfirmationPage = Framer.Importer.load("imported/Framer-ConfirmationPage@1x")
# Import file "Framer-ConfirmPanel"
sketchConfirmPanel = Framer.Importer.load("imported/Framer-ConfirmPanel@1x")
# Import file "Framer-HostMeetingContents"
sketchHostMeetingContent = Framer.Importer.load("imported/Framer-HostMeetingContents@1x")


# Import file "Framer-VotePanel"
sketchVotePanel = Framer.Importer.load("imported/Framer-VotePanel@1x")
# Import file "Framer-MeetingContents"
sketchDetailsInvitee = Framer.Importer.load("imported/Framer-MeetingContents@1x")


# Import file "Framer-Meetings"
sketchMeetings = Framer.Importer.load("imported/Framer-Meetings@1x")









###-----------------------------------------------------------------
PUBLIC:

Colors
Public Funtions
General panels: change cover photo, event options, view in map, invitees
-----------------------------------------------------------------###

# Colors
White="#ffffff"
Grey="#D8DADF"
lightGrey="#fcfcfc"
bgGrey="#F8F8F8"

paleOrange="#FFF6EF"
lightOrange="FFEEE0"
Orange="#FF8627"
darkOrange="#F68023"

pressedLightRed="#FFE8E8"
lightRed="#FFF1F1"
Red="#EB5858"

brightBlue="#0086FF"
darkBlue="#3A4A6A"


# meetings states
isRefreshingMeetings=false
isInvitationsVoted=false
isHostingEventConfirmed=false
currentTimeslotId=0 #Record

# Live data of the value of selected timeslots
valueOfSelected=0

#don't know how to use class so just use simple functions
selectable=(timeslotName)->
		timeslotName.onTap ->
			#切换圆点选中状态
			if timeslotName.children[1].visible==true then timeslotName.children[1].visible=false else timeslotName.children[1].visible=true
			
			#记录选中状态的数目
			if timeslotName.children[1].visible==false 
				valueOfSelected+=1 
			else 
				valueOfSelected-=1
			
			textVoteButton.text="Vote for #{valueOfSelected} timeslots"
			textHaveSelected.text="You have selected #{valueOfSelected} timeslot(s)"
			if valueOfSelected>0 
				#切换按钮背景状态
				bg_VoteButton.backgroundColor=Orange 
				#切换按钮文字颜色
				textVoteButton.color="#fff"
				#切换可点击状态
				VoteButton.ignoreEvents = false 
			
			else 
				bg_VoteButton.backgroundColor=paleOrange
				#切换按钮文字颜色
				textVoteButton.color="#FFC79A"
				#切换可点击状态
				VoteButton.ignoreEvents = true
			 
			
		
#reset timeslots
resetTimeslots=(timeslotName) ->
	timeslotName.children[1].visible=true


allTimeslotsList = [sketchConfirmPanel.Timeslots_Line1, sketchConfirmPanel.Timeslots_Line2, sketchConfirmPanel.Timeslots_Line3,
sketchViewInCal.Timeslots_Block11,sketchViewInCal.Timeslots_Block21,sketchViewInCal.Timeslots_Block31]

# For host
valueOfSelectedToConfirm=0
selectableConfirm=(timeslotName,id)->
		timeslotName.onTap ->
			isATimeSelected=false
			#取消所有的选择
			for each in allTimeslotsList
				if each.name!=timeslotName.name
					each.children[1].visible=true
			
			#切换圆点选中状态（选中当前点击）
			if timeslotName.children[1].visible==true 
				timeslotName.children[1].visible=false
				#如果当前有选中
				isATimeSelected=true
				currentTimeslotId=id
				textHaveSelected.text="You have selected the final time"
			else
				timeslotName.children[1].visible=true
				currentTimeslotId=0
				textHaveSelected.text="You haven't selected the final time"
				
			
			if isATimeSelected
				#切换按钮背景状态
				bg_ConfirmButton.backgroundColor=Orange 
				#切换按钮文字颜色
				textConfirmButton.color="#fff"
				#切换可点击状态
				ConfirmButton.ignoreEvents = false 
			
			else 
				bg_ConfirmButton.backgroundColor=paleOrange
				#切换按钮文字颜色
				textConfirmButton.color="#FFC79A"
				#切换可点击状态
				ConfirmButton.ignoreEvents = true
			 
			
		



# move links
moveInvitationLinkTo=(card)->
	#Click the invitations:
	card.onClick (event, layer) ->
		if not scrollMeetings.isMoving
			page_DetailsAsInvitee.stateCycle("Show","Hide")
			
			page_DetailsAsInvitee.on Events.AnimationEnd, ->
				mask_VotePanel.animate
					opacity: 0.5
					time:0.5
					curve:Bezier.ease
	
				subpage_VotePanel.animate
						y: Align.bottom(-5)
						time:0.5
						curve:Bezier.ease
						
				sketchVotePanel.Arow.animate
					rotation: 0
					time:0.5
					curve:Bezier.ease
				
				#因为一开始panel为hide状态，此时enable了
				subpage_VotePanel.ignoreEvents=true
				
				###
				mask_VotePanel.on Events.AnimationEnd, ->
					mask_VotePanel.stateSwitch("Show")
				subpage_VotePanel.on Events.AnimationEnd, ->
					subpage_VotePanel.stateSwitch("Show")
				sketchVotePanel.Arow.on Events.AnimationEnd, ->
					sketchVotePanel.Arow.stateSwitch("Down")
				###


moveHostingEventLinkTo=(card)->
	#Click the hosting event:
	card.onClick (event, layer) ->
		if not scrollMeetings.isMoving
			page_DetailsAsHost.stateCycle("Show","Hide")
			
			page_DetailsAsHost.on Events.AnimationEnd, ->
				mask_ConfirmPanel.animate
					opacity: 0.5
					time:0.5
					curve:Bezier.ease
	
				subpage_ConfirmPanel.animate
						y: Align.bottom(-5)
						time:0.5
						curve:Bezier.ease
						
				sketchConfirmPanel.Arow.animate
					rotation: 0
					time:0.5
					curve:Bezier.ease
			











###-----------------------------------------------------------------
PAGE MANAGEMENT:
page_Meetings
page_DetailsAsInvitee
page_DetailsAsHost
-----------------------------------------------------------------###

page_Meetings=new Layer
	width: Screen.width
	height: Screen.height
	backgroundColor: bgGrey

page_DetailsAsInvitee=new Layer
	width: Screen.width
	height: Screen.height
	backgroundColor: lightGrey

page_DetailsAsHost=new Layer
	width: Screen.width
	height: Screen.height
	backgroundColor: lightGrey


###--------------------------------------
CONTENT: page_Meetings
------------------------------------------###

# Group in page page_Meetings
sketchMeetings.Meetings.parent=page_Meetings
sketchMeetings.NavBar.parent=page_Meetings
sketchMeetings.BottomBar.parent=page_Meetings

# Set bottom bar
sketchMeetings.BottomBar.y=Align.bottom

# Set scroll content
scrollMeetings = ScrollComponent.wrap(sketchMeetings.ScrollGroup)
scrollMeetings.contentInset = {bottom: 130}
scrollMeetings.scrollHorizontal = false
scrollMeetings.propagateEvents = false
#高度为空白区域
scrollMeetings.height=1096


# Meetings Status
meetingAnimationTime=0.5
currentMeetingStatus=0
meetingTitle=new TextLayer
	parent: page_Meetings
	text:"Invitations(1)"
	fontSize: 34
	color:"#000"
	fontStyle: "bold"
	x: Align.center
	y:60

# notice for new invitations
newInvitationNotice=new Layer
	parent: page_Meetings
	x: Align.center
	y: 140
	height: 50
	width: 200
	borderRadius: 100
	shadowBlur: 4
	backgroundColor: Red
	shadowY: 0
	opacity: 0
	
txtNewInvitationNotice=new TextLayer
	x: Align.center
	y: Align.center
	parent: newInvitationNotice
	text:"1 New Invitation"
	color: "#fff"
	fontSize: 24


newInvitationNotice.onClick (event, layer) ->
	MeetingsStatus2()

###
#MeetingsStatus1:
#Hide all and waiting for user to refresh
###

MeetingsStatus1=()->
	newInvitationNotice.animate
		y: 150
		opacity: 1
		options: 
			time: 1
			curve: Bezier.ease
		
	meetingTitle.text="Invitations(1)"
	sketchMeetings.Hosting_Title.visible=true
	sketchMeetings.M3.visible=true
	currentMeetingStatus=1
	sketchMeetings.Hosting_Title.y=0
	sketchMeetings.M3.y=40
	moveHostingEventLinkTo(sketchMeetings.M3)
	
	sketchMeetings.M1.visible=false
	sketchMeetings.Replied_Title.visible=false
	sketchMeetings.M1_Replied.visible=false
	sketchMeetings.M3_Confirmed.visible=false
	sketchMeetings.M3_AllVoted.visible=false		

###
MeetingsStatus2:
Show Invitation
###

MeetingsStatus2=()->
	newInvitationNotice.destroy()
		
	currentMeetingStatus=2
	sketchMeetings.M1.visible=true
	sketchMeetings.M1.scaleY=0
	sketchMeetings.M1.animate
		scaleY: 1
		options: 
			delay: meetingAnimationTime
			time: meetingAnimationTime
			curve: Bezier.ease
	
	sketchMeetings.Hosting_Title.y=10
	sketchMeetings.Hosting_Title.animate
		y:sketchMeetings.M1.height+10
		options: 
			time: meetingAnimationTime
			curve: Bezier.ease
	
	sketchMeetings.M3.y=40
	sketchMeetings.M3.animate
		y: sketchMeetings.M1.height+50
		options: 
			time: meetingAnimationTime
			curve: Bezier.ease
					
	sketchMeetings.M3_AllVoted.y=40
	sketchMeetings.M3_AllVoted.animate
		y: sketchMeetings.M1.height+50
		options: 
			time: meetingAnimationTime
			curve: Bezier.ease
	
	sketchMeetings.Hosting_Title.on Events.AnimationEnd, ->
		sketchMeetings.M3.visible=false
		sketchMeetings.M3_AllVoted.visible=true
	
	sketchMeetings.Replied_Title.visible=false
	sketchMeetings.M1_Replied.visible=false
	sketchMeetings.M3_Confirmed.visible=false	
	
	moveInvitationLinkTo(sketchMeetings.M1)
	moveHostingEventLinkTo(sketchMeetings.M3_AllVoted)
	meetingTitle.text="Invitations(2)"

###
MeetingsStatus3:
Invitation Replied
###

MeetingsStatus3=()->
	moveInvitationLinkTo(sketchMeetings.M1_Replied)
	currentMeetingStatus=3
	sketchMeetings.M3.visible=false
	sketchMeetings.M3_AllVoted.visible=true
	sketchMeetings.M3_Confirmed.visible=false	
	
	sketchMeetings.M1.visible=true
	sketchMeetings.M1.scaleY=1
	sketchMeetings.M1.animate
		opacity:0
		scaleY: 0
		options: 
			time: meetingAnimationTime
			curve: Bezier.ease
			
	sketchMeetings.Hosting_Title.y=sketchMeetings.M1.height+20
	sketchMeetings.Hosting_Title.animate
		y:0
		options: 
			delay: meetingAnimationTime
			time: meetingAnimationTime
			curve: Bezier.ease
			
	sketchMeetings.M3_AllVoted.y=sketchMeetings.M1.height+50
	sketchMeetings.M3_AllVoted.animate
		y: 40
		options:
			delay: meetingAnimationTime
			time: meetingAnimationTime
			curve: Bezier.ease
			
	sketchMeetings.Replied_Title.visible=false
	sketchMeetings.M1_Replied.visible=false
			
	sketchMeetings.Hosting_Title.on Events.AnimationEnd, ->
		sketchMeetings.M1.visible=false
		sketchMeetings.Replied_Title.visible=true
		sketchMeetings.Replied_Title.y=40+sketchMeetings.M3_AllVoted.height+20
		sketchMeetings.Replied_Title.opacity=0
		sketchMeetings.Replied_Title.animate
			opacity: 1
			options: 
				time: meetingAnimationTime
				curve: Bezier.ease
				
		sketchMeetings.M1_Replied.visible=true
		sketchMeetings.M1_Replied.y=40+sketchMeetings.M3_AllVoted.height+50
		sketchMeetings.M1_Replied.opacity=0
		sketchMeetings.M1_Replied.animate
			opacity: 1
			options: 
				time: meetingAnimationTime
				curve: Bezier.ease
	
	meetingTitle.text="Invitations(1)"

### 
MeetingsStatus4:
Hosting Event Confirmed
###

MeetingsStatus4=()->
	moveHostingEventLinkTo(sketchMeetings.M3_Confirmed)
	
	currentMeetingStatus=4
	
	sketchMeetings.M1.visible=false
	sketchMeetings.M3.visible=false

	sketchMeetings.Hosting_Title.opacity=1
	sketchMeetings.Hosting_Title.animate
		opacity: 0
		options: 
			time: meetingAnimationTime-0.1
			curve: Bezier.ease
	sketchMeetings.Hosting_Title.visible=false
	
	sketchMeetings.M3_AllVoted.y=40
	sketchMeetings.M3_AllVoted.opacity=1
	sketchMeetings.M3_Confirmed.y=40
	sketchMeetings.M3_Confirmed.opacity=0
	
	sketchMeetings.Replied_Title.visible=true
	sketchMeetings.M1_Replied.visible=true
	sketchMeetings.M3_Confirmed.visible=true
	
	sketchMeetings.Replied_Title.animate
		y: 10
	
	sketchMeetings.M3_AllVoted.animate
		opacity: 0
		options: 
			time: meetingAnimationTime
			curve: Bezier.ease
			
	sketchMeetings.M3_Confirmed.animate
		opacity: 1
		options: 
			time: meetingAnimationTime
			curve: Bezier.ease
	sketchMeetings.M1_Replied.y=40+sketchMeetings.M3_Confirmed.height+50
	sketchMeetings.M1_Replied.animate
		y: 40+sketchMeetings.M3_Confirmed.height+20
		options: 
			time: meetingAnimationTime
			curve: Bezier.ease
			
	meetingTitle.text="Invitations"
	
###
Switching status
###

#default
MeetingsStatus1()


# call meeting status 2
scrollMeetings.on Events.ScrollStart, ->
	if scrollMeetings.direction=="up"
		isRefreshingMeetings=true

			
			

scrollMeetings.on Events.ScrollEnd, ->
	if currentMeetingStatus==1 and isRefreshingMeetings
		MeetingsStatus2()
		isRefreshingMeetings=false

# call meeting status 3 in vote button/cant go button
# call meeting status 4 (final) in confirm button





###--------------------------------------
CONTENT: page_DetailsAsInvitee
	subpage_VotePanel
	subpage_MeetingContent
------------------------------------------###

# Behaviour of page_DetailsAsInvitee
page_DetailsAsInvitee.states.Hide =
	x: Screen.width
	y: 0
	animationOptions:
		time:0.8
		curve:Bezier.ease
page_DetailsAsInvitee.states.Show =
	x: 0
	animationOptions:
		time:0.8
		curve:Bezier.ease
page_DetailsAsInvitee.stateSwitch("Hide")

# Create sub-pages
subpage_MeetingContent=ScrollComponent.wrap(sketchDetailsInvitee.DetailsUnconfirmed)
subpage_MeetingContent.contentInset = {bottom: 120}
subpage_MeetingContent.scrollHorizontal = false
subpage_MeetingContent.propagateEvents = false

subpage_VotePanel=new Layer
	x: Align.center
	y: Screen.height-110
	width: Screen.width-10
	height: 613
	shadowSpread: 0
	shadowColor: "rgba(0,0,0,0.1)"
	borderRadius: 8
	shadowBlur: 20

mask_VotePanel=new Layer
	width: Screen.width
	height: Screen.height
	backgroundColor: Grey
	opacity: 0

# Group in page page_DetailsAsInvitee
sketchDetailsInvitee.NavBar.parent=page_DetailsAsInvitee
subpage_MeetingContent.parent=page_DetailsAsInvitee
mask_VotePanel.parent=page_DetailsAsInvitee
subpage_VotePanel.parent=page_DetailsAsInvitee
sketchDetailsInvitee.NavBar.index=3


# Back Btn
sketchDetailsInvitee.btnBack.onClick (event, layer) ->
	mask_VotePanel.stateSwitch("Hide")
	subpage_VotePanel.stateSwitch("Hide")
	sketchVotePanel.Arow.stateSwitch("Up")
	page_DetailsAsInvitee.stateCycle("Show","Hide")
	
	
	

#Behaviours of Meeting Content
	
	
#Behaviours of Vote Panel 
VotePanelSwitch =() ->
	subpage_VotePanel.stateCycle("Show","Hide")
	sketchVotePanel.Arow.stateCycle("Down","Up")
	mask_VotePanel.stateCycle("Show","Hide")


subpage_VotePanel.states.Hide =
		y: Screen.height-110
		animationOptions:
			time:0.5
			curve:Bezier.ease
			
subpage_VotePanel.states.Show =
		y: Align.bottom(-5)
		animationOptions:
			time:0.5
			curve:Bezier.ease

subpage_VotePanel.stateSwitch("Hide")

sketchVotePanel.VotePanel.parent=subpage_VotePanel

selectable(sketchVotePanel.Timeslots_Line1)
selectable(sketchVotePanel.Timeslots_Line2)
selectable(sketchVotePanel.Timeslots_Line3)

sketchVotePanel.VPHeader.onClick (evnet,layer) ->
	VotePanelSwitch()

# View In Cal Button
sketchVotePanel.ViewInCal.onClick (event, layer) ->
	ViewInCal_page1(true)
	
#Hide Button
sketchVotePanel.Hide.onClick (event, layer) ->
	sketchVotePanel.Arow.stateCycle("Down","Up")
	subpage_VotePanel.stateCycle("Hide","Show")
	mask_VotePanel.stateCycle("Show","Hide")
	
sketchVotePanel.Arow.states.Down=
	rotation: 0
	animationOptions:
			time:0.5
			curve:Bezier.ease

sketchVotePanel.Arow.states.Up=
	rotation: 180
	animationOptions:
			time:0.5
			curve:Bezier.ease

sketchVotePanel.Arow.stateSwitch("Up")



#Behaviours of mask_VotePanel

mask_VotePanel.states.Show=
	opacity: 0.5
	ignoreEvents:false
	animationOptions:
		time:0.5
		curve:Bezier.ease

mask_VotePanel.states.Hide=
	opacity: 0
	ignoreEvents:true
	animationOptions:
		time:0.5
		curve:Bezier.ease

mask_VotePanel.stateSwitch("Hide")

mask_VotePanel.onClick (event, layer) ->
	VotePanelSwitch()
	
	
	

#Vote Button
VoteButton=new Layer
	parent: subpage_VotePanel
	y: Align.bottom(-30)
	x: Align.left(10)
	width: 518
	height: 110
	backgroundColor: "#fff"
	index:100

bg_VoteButton = new Layer
	parent: VoteButton
	index:101
	width: 518
	height: 110
	backgroundColor: paleOrange
	borderRadius: 8
	
textVoteButton=new TextLayer
	parent: VoteButton
	index:101
	x: Align.center
	y: Align.center
	color:"#FFC79A"
	text:"Vote for #{valueOfSelected} timeslots"
	fontSize: 34
	width: 320
	fontFamily: "-apple-system"
	
VoteButton.onTapStart (event, layer) ->
	bg_VoteButton.backgroundColor=darkOrange
	textVoteButton.color="#fff"

VoteButton.onTapEnd (event, layer) ->
	bg_VoteButton.backgroundColor=lightOrange
	textVoteButton.color=darkOrange
	textVoteButton.text="Voted for #{valueOfSelected} timeslots"
	#reset can't go button
	bg_CantgoButton.backgroundColor="#fff"
	textCantgoButton.color="#aaa"
	page_DetailsAsInvitee.stateCycle("Show","Hide")
	
	# event status
	isInvitationsVoted=true
	MeetingsStatus3()
	

#Vote Button Default Status
VoteButton.ignoreEvents = true 

#Cant go Button
CantgoButton=new Layer
	parent: subpage_VotePanel
	y: Align.bottom(-30)
	x: Align.right(-10)
	width: 200
	height: 110
	backgroundColor: "#fff"
	
bg_CantgoButton = new Layer
	parent: CantgoButton
	width: 200
	height: 110
	backgroundColor: "#fff"
	borderRadius: 8

textCantgoButton=new TextLayer
	parent: CantgoButton
	text:"Can't go"
	color: "#aaa"
	x: Align.center
	y: Align.center

CantgoButton.onTapStart (event, layer) ->
	bg_CantgoButton.backgroundColor=pressedLightRed
	textCantgoButton.color="#aaa"
	
CantgoButton.onTapEnd (event, layer) ->
	bg_CantgoButton.backgroundColor=lightRed
	textCantgoButton.color=Red
	#reset and disable the vote button
	valueOfSelected=0
	textVoteButton.text="Vote for #{valueOfSelected} timeslots"
	bg_VoteButton.backgroundColor="#fff"
	textVoteButton.Color="#ccc"
	bg_VoteButton.backgroundColor="#fff"
	textVoteButton.color="#aaa"
	
	#reset all timeslots
	resetTimeslots(sketchVotePanel.Timeslots_Line1)
	resetTimeslots(sketchVotePanel.Timeslots_Line2)
	resetTimeslots(sketchVotePanel.Timeslots_Line3)
	
	page_DetailsAsInvitee.stateCycle("Show","Hide")
	
	# event status
	isInvitationsVoted=true
	if currentMeetingStatus==2
		MeetingsStatus3()


#Vote Panel Visual Stuff
sketchVotePanel.VotePanel.width=740
sketchVotePanel.VotePanel.height=613
sketchVotePanel.VotePanel.borderRadius=8


















###--------------------------------------
CONTENT: page_DetailsAsHost
	subpage_ConfirmPanel
	subpage_HostMeetingContent
------------------------------------------###

# Behaviour of page_DetailsAsHost
page_DetailsAsHost.states.Hide =
	x: Screen.width
	y: 0
	animationOptions:
		time:0.8
		curve:Bezier.ease
page_DetailsAsHost.states.Show =
	x: 0
	animationOptions:
		time:0.8
		curve:Bezier.ease
# default status
page_DetailsAsHost.stateSwitch("Hide")

# Create sub-pages
subpage_HostMeetingContent=ScrollComponent.wrap(sketchHostMeetingContent.DetailsUnconfirmed)
subpage_HostMeetingContent.contentInset = {bottom: 120}
subpage_HostMeetingContent.scrollHorizontal = false
subpage_HostMeetingContent.propagateEvents = false

# create confirmation panel
subpage_ConfirmPanel=new Layer
	x: Align.center
	y: Screen.height-110
	width: Screen.width-10
	height: 613
	shadowSpread: 0
	shadowColor: "rgba(0,0,0,0.1)"
	borderRadius: 8
	shadowBlur: 20

mask_ConfirmPanel=new Layer
	y: 0
	x: 0
	width: Screen.width
	height: Screen.height
	backgroundColor: "#000"
	opacity: 0


# Group in page page_DetailsAsHost
sketchHostMeetingContent.NavBar.parent=page_DetailsAsHost
subpage_HostMeetingContent.parent=page_DetailsAsHost
mask_ConfirmPanel.parent=page_DetailsAsHost
subpage_ConfirmPanel.parent=page_DetailsAsHost

# pu it befor the cover photo
sketchHostMeetingContent.NavBar.index=3

sketchHostMeetingContent.btnBack.onClick (event, layer) ->
	mask_ConfirmPanel.stateSwitch("Hide")
	subpage_ConfirmPanel.stateSwitch("Hide")
	sketchConfirmPanel.Arow.stateSwitch("Up")
	page_DetailsAsHost.stateCycle("Show","Hide")
	
	
	
#Confirmed之后底部状态条	

subpage_confirmedBar=new Layer
	parent: subpage_HostMeetingContent
	width: Screen.width
	height: 110
	x: Align.center(20)
	y: Align.bottom
	backgroundColor: White
	shadowBlur: 10
	shadowSpread: 1
	shadowColor: "rgba(183,190,213,0.5)"
	visible: false
	ignoreEvents: true

Going=new TextLayer
	parent: subpage_confirmedBar
	text: "Status："
	y: Align.center
	x: Align.left(40)
	color: darkBlue
	fontSize: 34

Yes=new TextLayer
	parent: subpage_confirmedBar
	text: "Going"
	y: Align.center
	x: Align.right(-200)
	color: brightBlue
	fontSize: 34

No=new TextLayer
	parent: subpage_confirmedBar
	text: "Not going"
	y: Align.center
	x: Align.right(-20)
	color: Grey
	fontSize: 34

Yes.onClick (event, layer) ->
	Yes.color=brightBlue
	No.color=Grey
	
No.onClick (event, layer) ->
	Yes.color=Grey
	No.color=Red


#Behaviours of mask_ConfirmPanel
mask_ConfirmPanel.states.Show=
	opacity: 0.5
	ignoreEvents:false
	animationOptions:
		time:0.5
		curve:Bezier.ease

mask_ConfirmPanel.states.Hide=
	opacity: 0
	ignoreEvents:true
	animationOptions:
		time:0.5
		curve:Bezier.ease

mask_ConfirmPanel.stateSwitch("Hide")

mask_ConfirmPanel.onClick (event, layer) ->
	subpage_ConfirmPanel.stateCycle("Show","Hide")
	sketchConfirmPanel.Arow.stateCycle("Down","Up")
	mask_ConfirmPanel.stateCycle("Show","Hide")


#Behaviours of Confirm Panel 
subpage_ConfirmPanel.states.Hide =
		y: Screen.height-110
		animationOptions:
			time:0.5
			curve:Bezier.ease
			
subpage_ConfirmPanel.states.Show =
		y: Align.bottom(-5)
		animationOptions:
			time:0.5
			curve:Bezier.ease

subpage_ConfirmPanel.stateSwitch("Hide")

sketchConfirmPanel.VotePanel.parent=subpage_ConfirmPanel





# View In Cal Button
sketchConfirmPanel.ViewInCal.onClick (event, layer) ->
	ViewInCal_page1(false)



#Hide Button
sketchConfirmPanel.Hide.onClick (event, layer) ->
	sketchConfirmPanel.Arow.stateCycle("Down","Up")
	subpage_ConfirmPanel.stateCycle("Hide","Show")
	mask_ConfirmPanel.stateCycle("Show","Hide")

sketchConfirmPanel.Arow.states.Down=
	rotation: 0
	animationOptions:
			time:0.5
			curve:Bezier.ease

sketchConfirmPanel.Arow.states.Up=
	rotation: 180
	animationOptions:
			time:0.5
			curve:Bezier.ease

sketchConfirmPanel.Arow.stateSwitch("Up")

# Enable Timelsots
selectableConfirm(sketchConfirmPanel.Timeslots_Line1,1)
selectableConfirm(sketchConfirmPanel.Timeslots_Line2,2)
selectableConfirm(sketchConfirmPanel.Timeslots_Line3,3)


# Confirm Action --------------------------------------

# create confirmation page


sub_subpage_ConfirmationPage=new Layer
	width: Screen.width
	height: Screen.height
	backgroundColor: White
	x:Align.center
	
sketchConfirmationPage.ConfirmationPage.parent=sub_subpage_ConfirmationPage

sub_subpage_ConfirmationPage.states.Show=
	y: 0
	options: 
		time: 0.5
		curve: Bezier.ease

sub_subpage_ConfirmationPage.states.Hide=
	y: Screen.height
	options: 
		time: 0.5
		curve: Bezier.ease

sub_subpage_ConfirmationPage.stateSwitch("Hide")


# Behaviours of confirmation page

#重置confirm page，可变内容都设置为隐藏
resetConfirmationPage=()->
	sketchConfirmationPage.ConfirmContent1.visible=false
	sketchConfirmationPage.ConfirmContent2.visible=false
	sketchConfirmationPage.ConfirmContent3.visible=false
	
showConfirmationPageAt=(num)->
	if num==1
		sketchConfirmationPage.ConfirmContent1.visible=true
	else if num==2
		sketchConfirmationPage.ConfirmContent2.visible=true
	else if num==3
		sketchConfirmationPage.ConfirmContent3.visible=true
	
	sub_subpage_ConfirmationPage.stateCycle("Hide","Show")

#关闭页面，不confirm
sketchConfirmationPage.Pin_Left.onClick (event, layer) ->
	sub_subpage_ConfirmationPage.stateCycle("Hide","Show")
	resetConfirmationPage()

# 确认confirm ，Confirm Button final
sketchConfirmationPage.Btn.onTapStart (event, layer) ->
	sketchConfirmationPage.BarPressed.visible=true

sketchConfirmationPage.Btn.onTapEnd (event, layer) ->
	sketchConfirmationPage.BarPressed.visible=false
	# event status
	isHostingEventConfirmed=true
	if currentMeetingStatus==3
		MeetingsStatus4()
	#关闭当前confirm页
	sub_subpage_ConfirmationPage.stateCycle("Hide","Show")
	#回到Meetings首页
	page_DetailsAsHost.stateCycle("Hide","Show")
	#重置confirm page
	resetConfirmationPage()
	#隐藏Confirm Panel
	subpage_ConfirmPanel.visible=false
	subpage_ConfirmPanel.ignoreEvents=true
	mask_ConfirmPanel.visible=false
	mask_ConfirmPanel.ignoreEvents=true
	#显示状态bar
	subpage_confirmedBar.visible=true
	subpage_confirmedBar.ignoreEvents=false
	#修改文字为have confirmed
	sketchHostMeetingContent.ConfirmedNotice.visible=true
	sketchHostMeetingContent.UnconfirmedNotice.visible=false


# Confirm Button
ConfirmButton=new Layer
	parent: subpage_ConfirmPanel
	y: Align.bottom(-30)
	x: Align.center
	width: subpage_ConfirmPanel.width-40
	height: 110
	backgroundColor: "#fff"
	index:100

bg_ConfirmButton = new Layer
	parent: ConfirmButton
	index:101
	width: subpage_ConfirmPanel.width-40
	height: 110
	backgroundColor: paleOrange
	borderRadius: 8
	
textConfirmButton=new TextLayer
	parent: ConfirmButton
	index:101
	x: Align.center
	y: Align.center
	color:"#FFC79A"
	text:"Confirm the final time"
	fontSize: 34
	width: 330
	fontFamily: "-apple-system"
	
ConfirmButton.onTapStart (event, layer) ->
	bg_ConfirmButton.backgroundColor=darkOrange
	textConfirmButton.color="#fff"

ConfirmButton.onTapEnd (event, layer) ->
	showConfirmationPageAt(currentTimeslotId)
	
#Confirm Button Default Status
ConfirmButton.ignoreEvents = true 


#Confirm Panel Visual Stuff
sketchConfirmPanel.VotePanel.width=740
sketchConfirmPanel.VotePanel.height=613
sketchConfirmPanel.VotePanel.borderRadius=8










###--------------------------------------
CONTENT: View In Calendar
------------------------------------------###

page_ViewInCal=new Layer
	width: Screen.width
	height: Screen.height
	backgroundColor: "#fff"
	x: Align.center
	y: 0

sketchViewInCal.TimeslotsInCal.parent=page_ViewInCal

scrollCal=ScrollComponent.wrap(sketchViewInCal.CalendarContent)
scrollCal.scrollHorizontal=false

# texts in the page_ViewInCal
ViewInCalTitle=new TextLayer
	parent: page_ViewInCal
	text:"Title"
	fontSize: 34
	color:"#000"
	fontStyle: "bold"
	x: Align.center
	y:60

textHaveSelected=new TextLayer
	parent: page_ViewInCal
	text:"You have selected #{valueOfSelected} timeslot(s)"
	fontSize: 34
	color:"#fff"
	fontStyle: "bold"
	x: Align.center
	width: 490
	y:135
	
	
# Behavours of page_ViewInCal 

# states of page_ViewInCal
page_ViewInCal.states.Hide =
	x: Screen.width
	y: 0
	animationOptions:
		time:0.8
		curve:Bezier.ease
page_ViewInCal.states.Show =
	x: 0
	animationOptions:
		time:0.8
		curve:Bezier.ease
page_ViewInCal.stateSwitch("Hide")

resetViewInCal=()->
	sketchViewInCal.ArrowL.visible=true
	sketchViewInCal.Page2Host.visible=true
	sketchViewInCal.Page2Invitee.visible=true
	sketchViewInCal.Page2Occupied.visible=true
	
	sketchViewInCal.ArrowR.visible=true
	sketchViewInCal.Page1Host.visible=true
	sketchViewInCal.Page1Invitee.visible=true
	sketchViewInCal.Page1Occupied.visible=true
		
# Back btn
sketchViewInCal.Back.onClick (event, layer) ->
	page_ViewInCal.stateCycle("Hide","Show")
	resetViewInCal()


# Call page_ViewInCal 
ViewInCal_page1=(isInviteePage)->
	#Hide page 2 content
	sketchViewInCal.ArrowL.visible=false
	sketchViewInCal.Page2Host.visible=false
	sketchViewInCal.Page2Invitee.visible=false
	sketchViewInCal.Page2Occupied.visible=false
	
	if isInviteePage
		ViewInCalTitle.text="Yarra River BBQ"
		ViewInCalTitle.x=Align.center
		#View in invitee page
		sketchViewInCal.Page1Host.visible=false
	else
		textHaveSelected.text="You haven't selected the final time"
		textHaveSelected.width=530
		textHaveSelected.x=Align.center
		ViewInCalTitle.text="Telstra Competition ..."
		ViewInCalTitle.x=Align.center
		#View in Host page
		sketchViewInCal.Page1Invitee.visible=false
	
	page_ViewInCal.stateCycle("Hide","Show")


ViewInCal_page2=(isInviteePage)->
	#Hide page 2 content
	sketchViewInCal.ArrowR.visible=false
	sketchViewInCal.Page1Host.visible=false
	sketchViewInCal.Page1Invitee.visible=false
	sketchViewInCal.Page1Occupied.visible=false
	
	if isInviteePage
		ViewInCalTitle.text="Yarra River BBQ"
		ViewInCalTitle.x=Align.center
		#View in invitee page
		sketchViewInCal.Page2Host.visible=false
	else
		ViewInCalTitle.text="Telstra Competition ..."
		ViewInCalTitle.x=Align.center
		#View in Host page
		sketchViewInCal.Page2Invitee.visible=false
	
	page_ViewInCal.stateCycle("Hide","Show")



selectable(sketchViewInCal.Timeslots_Block1)
selectable(sketchViewInCal.Timeslots_Block2)
selectable(sketchViewInCal.Timeslots_Block3)

selectableConfirm(sketchViewInCal.Timeslots_Block11,1)
selectableConfirm(sketchViewInCal.Timeslots_Block21,2)
selectableConfirm(sketchViewInCal.Timeslots_Block31,3)

