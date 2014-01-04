#!/SOMETHING SOMETHING SOMETHING python
# -*- coding: utf-8 -*- 
import wx

import sys
import time


class RedirectText:
	def __init__(self,aWxTextCtrl):
		self.out=aWxTextCtrl

	def write(self,string):
		wx.CallAfter(self.out.AppendText, string)



import MapFrame as vizFrame


class MapEditorFrame(wx.Frame):

	VizEnable = True
	
	def __init__(self, *args, **kwds):
		kwds["style"] = wx.CAPTION|wx.CLOSE_BOX|wx.MINIMIZE_BOX|wx.MAXIMIZE_BOX|wx.SYSTEM_MENU|wx.RESIZE_BORDER|wx.TAB_TRAVERSAL|wx.CLIP_CHILDREN
		wx.Frame.__init__(self, *args, **kwds)


		self.VizEnable = True

		self.__set_properties()
		self.__do_layout()
		

		
		self.filterTimer = wx.Timer(self)
		self.pollUpdate = wx.Timer(self)
		self.tbUpdate = wx.Timer(self)

		

		self.Bind(wx.EVT_CLOSE, self.quitApp)
		self.Bind(wx.EVT_TIMER, self.updateFilter, self.filterTimer)
		self.Bind(wx.EVT_TIMER, self.updateGUI, self.tbUpdate)



		

	def __set_properties(self):
		self.SetTitle("Map Editor")
		self.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BTNFACE))

		self.SetSize((1600, 1000))
		self.SetMinSize((1300, 1000))

		
	
	def __controlButtonsSizer(self):
		controlButtonsSizer = wx.BoxSizer(wx.HORIZONTAL)

		descText = "Map Editor"
		videoWinHeaderLabel = wx.StaticText(self, -1, descText)
		videoWinHeaderLabel.SetFont(wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "MS Shell Dlg 2"))
		controlButtonsSizer.Add(videoWinHeaderLabel, proportion=0, flag=wx.ALL, border=5)

		controlButtonsSizer.Add([1,1], proportion=1)

		self.somethingButton = wx.ToggleButton(self, -1, "DO THE THING")
		controlButtonsSizer.Add(self.somethingButton, proportion=0, flag=wx.EXPAND, border=5)

		#
		#self.ipTextCtrl.Bind(wx.EVT_TEXT_ENTER, self.evtIpEnter)

		#self.StatusWin = wx.TextCtrl(self, -1, "", style = wx.TE_MULTILINE | wx.TE_READONLY)

		return controlButtonsSizer
	
	
	def __map_button_panel(self):

		mapButtonSizer = wx.FlexGridSizer(cols=2, vgap = 3, hgap = 3)
		mapEditorPanelHeader = wx.StaticText(self, -1, "Room Properties")
		mapEditorPanelHeader.SetFont(wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "MS Shell Dlg 2"))

		mapButtonSizer.Add(mapEditorPanelHeader, proportion=0, border=5, flag=wx.EXPAND)
		mapButtonSizer.Add([5,5], proportion=0, border=5, flag=wx.EXPAND)



		roomNameLabel           = wx.StaticText(self, id=-1, label="Unique Name")
		mapButtonSizer.Add(roomNameLabel, proportion=0, border=5, flag=wx.EXPAND)
		roomNameTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(roomNameTextctrl, proportion=0, border=5, flag=wx.EXPAND)

		roomCallOnEnterLabel    = wx.StaticText(self, id=-1, label="Call on Entry")
		mapButtonSizer.Add(roomCallOnEnterLabel, proportion=0, border=5, flag=wx.EXPAND)
		roomCallEntrTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(roomCallEntrTextctrl, proportion=0, border=5, flag=wx.EXPAND)

		roomShownNameLabel      = wx.StaticText(self, id=-1, label="Shown Name")
		mapButtonSizer.Add(roomShownNameLabel, proportion=0, border=5, flag=wx.EXPAND)
		roomNameInGameTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(roomNameInGameTextctrl, proportion=0, border=5, flag=wx.EXPAND)

		planetEntryLabel      = wx.StaticText(self, id=-1, label="Planet")
		mapButtonSizer.Add(planetEntryLabel, proportion=0, border=5, flag=wx.EXPAND)
		planetNameTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(planetNameTextctrl, proportion=0, border=5, flag=wx.EXPAND)

		systemEntryLabel      = wx.StaticText(self, id=-1, label="System")
		mapButtonSizer.Add(systemEntryLabel, proportion=0, border=5, flag=wx.EXPAND)
		systemNameTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(systemNameTextctrl, proportion=0, border=5, flag=wx.EXPAND)


		roomDescriptionLabel      = wx.StaticText(self, id=-1, label="Room description")
		mapButtonSizer.Add(roomDescriptionLabel, proportion=0, border=5, flag=wx.EXPAND)
		roomDescriptionTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER | wx.TE_MULTILINE, size=[300, 400])
		mapButtonSizer.Add(roomDescriptionTextctrl, proportion=0, border=5, flag=wx.EXPAND)
		
		flagsLabel      = wx.StaticText(self, id=-1, label="Flags")
		mapButtonSizer.Add(flagsLabel, proportion=0, border=5, flag=wx.EXPAND)
		flagsTextCtrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER | wx.TE_MULTILINE, size=[300, 100])
		mapButtonSizer.Add(flagsTextCtrl, proportion=0, border=5, flag=wx.EXPAND)

		connectionsLabel      = wx.StaticText(self, id=-1, label="Room Connections")
		mapButtonSizer.Add(connectionsLabel, proportion=0, border=5, flag=wx.EXPAND)
		mapButtonSizer.Add([5,5], proportion=0, border=5, flag=wx.EXPAND)


		exitNorth      = wx.StaticText(self, id=-1, label="North")
		mapButtonSizer.Add(exitNorth, proportion=0, border=5, flag=wx.EXPAND)
		exitNorthTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(exitNorthTextctrl, proportion=0, border=5, flag=wx.EXPAND)
		exitSouth      = wx.StaticText(self, id=-1, label="South")
		mapButtonSizer.Add(exitSouth, proportion=0, border=5, flag=wx.EXPAND)
		exitSouthTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(exitSouthTextctrl, proportion=0, border=5, flag=wx.EXPAND)
		exitEast      = wx.StaticText(self, id=-1, label="East")
		mapButtonSizer.Add(exitEast, proportion=0, border=5, flag=wx.EXPAND)
		exitEastTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(exitEastTextctrl, proportion=0, border=5, flag=wx.EXPAND)
		exitWest      = wx.StaticText(self, id=-1, label="West")
		mapButtonSizer.Add(exitWest, proportion=0, border=5, flag=wx.EXPAND)
		exitWestTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(exitWestTextctrl, proportion=0, border=5, flag=wx.EXPAND)
		exitIn      = wx.StaticText(self, id=-1, label="In")
		mapButtonSizer.Add(exitIn, proportion=0, border=5, flag=wx.EXPAND)
		exitInTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(exitInTextctrl, proportion=0, border=5, flag=wx.EXPAND)
		exitInLabel      = wx.StaticText(self, id=-1, label="In Label")
		mapButtonSizer.Add(exitInLabel, proportion=0, border=5, flag=wx.EXPAND)
		exitInLabelTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(exitInLabelTextctrl, proportion=0, border=5, flag=wx.EXPAND)
		exitOut      = wx.StaticText(self, id=-1, label="Out")
		mapButtonSizer.Add(exitOut, proportion=0, border=5, flag=wx.EXPAND)
		exitOutTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(exitOutTextctrl, proportion=0, border=5, flag=wx.EXPAND)
		exitOutLabel      = wx.StaticText(self, id=-1, label="Out Label")
		mapButtonSizer.Add(exitOutLabel, proportion=0, border=5, flag=wx.EXPAND)
		exitOutLabelTextctrl = wx.TextCtrl(self, id=-1, value="", style = wx.TE_PROCESS_ENTER, size=[200, -1])
		mapButtonSizer.Add(exitOutLabelTextctrl, proportion=0, border=5, flag=wx.EXPAND)



		self.roomCtrlDict = {
		"roomName"          : roomNameTextctrl,
		"roomCallEntr"      : roomCallEntrTextctrl,
		"roomNameInGame"    : roomNameInGameTextctrl,
		"planetName"        : planetNameTextctrl,
		"systemName"        : systemNameTextctrl,
		"roomDescription"   : roomDescriptionTextctrl,
		"flags"             : flagsTextCtrl,

		"exitNorth"         : exitNorthTextctrl,
		"exitSouth"         : exitSouthTextctrl,
		"exitEast"          : exitEastTextctrl,
		"exitWest"          : exitWestTextctrl,
		"exitIn"            : exitInTextctrl,
		"exitIn"            : exitInLabelTextctrl,
		"exitOut"           : exitOutTextctrl,
		"exitOut"           : exitOutLabelTextctrl

		}


		return mapButtonSizer


	def __map_panel(self):


		mapPanelSizer = wx.BoxSizer(wx.HORIZONTAL)
		self.vizPanel = vizFrame.ReadoutPanel(self, id=-1)
		mapPanelSizer.Add(self.vizPanel, proportion=1, flag=wx.EXPAND, border=0)
		mapPanelSizer.Add([5,5]) # SPACING HACK!
		mapPanelSizer.Add(self.__map_button_panel(), proportion=0,  flag=wx.EXPAND, border = 5)



		return mapPanelSizer

	def __do_layout(self):

		self.mainWindowSizer = wx.BoxSizer(wx.VERTICAL)
		
		self.mainWindowSizer.Add(self.__controlButtonsSizer(), proportion=0, flag=wx.EXPAND, border=0)
		
		self.mainWindowSizer.Add(self.__map_panel(), proportion=1,  flag=wx.EXPAND)

		self.Layout()
		

		self.ClearBackground()
		self.SetSizer(self.mainWindowSizer)
		
		self.Layout()

		#print "Starting Up..."
		

	def setPickedRoom(self, roomObject):
		roomDict = roomObject.toDict()
		for key, value in roomDict.iteritems():
			if key in self.roomCtrlDict:
				#print "Value = ", value
				if value != None:
					self.roomCtrlDict[key].SetValue(value)
				else:
					self.roomCtrlDict[key].SetValue("")
	def quitApp(self, event): 
		print "Exiting"

		time.sleep(.1)

		#print queVars.cnf.datProcThread
		#print queVars.cnf.serThread

		self.vizPanel.Destroy()
		
		wx.Exit()

	def updateFilter(self, event):
		print "filterfired"
		pass



	def updateGUI(self, event):
		pass

# end of class MapEditorFrame


class MyApp(wx.App):
	
	def OnInit(self):
		wx.InitAllImageHandlers()
		MainFrame = MapEditorFrame(None, -1, "")
		self.SetTopWindow(MainFrame)

		#Set up the filter timer, and stop it.
		#It can then be restarted by simply calling filterTimer.Start()
		MainFrame.filterTimer.Start((1000/30), 0)	#30 hz update rate
		MainFrame.filterTimer.Stop()

		
		MainFrame.tbUpdate.Start(25, 0)
		MainFrame.Show()
		return 1

