﻿package classes.UIComponents.MiniMap
{
	import flash.display.ColorCorrectionSupport;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import classes.UIComponents.UIStyleSettings;
	import classes.kGAMECLASS;
	import classes.RoomClass;
	import classes.GLOBAL;
	
	/**
	 * ...
	 * @author Gedan
	 */
	public class MiniMap extends Sprite
	{
		public static const DISPLAY_MODE_SMALL = 0;
		public static const DISPLAY_MODE_LARGE = 1;
		public static const DISPLAY_MODE_HYBRID = 2;
		private static const MAX_DISPLAY_MODES = 2;
		
		public static const SCALE_MODE_FIXED = 0;
		public static const SCALE_MODE_NUMBER = 1;
		public static const SCALE_MODE_SIZE = 2;
		private static const MAX_SCALE_MODES = 2;
		
		public static const ICON_SHIP = 0;
		public static const ICON_QUEST = 1;
		public static const ICON_OBJECTIVE = 2;
		public static const ICON_NPC = 3;
		public static const ICON_MEDICAL = 4;
		public static const ICON_DOWN = 5;
		public static const ICON_UP = 6;
		public static const ICON_COMMERCE = 7;
		public static const ICON_BAR = 8;
		public static const ICONS_MAX = 9;
		
		// I've spied rumblings of a way to search through an SWF class definitions to build a list like this completely dynamically... but the code I found to do it looks a) awful b) is russian... maybe later? maybe.
		// Basically, this is the list of linkage class names for the icons symbols in the FLA's library, which we're going to use to build icons in the correct order -- you might notice that they're in the same order as the integer flags up ^ there... the integer flags are used as array indexes to find the proper classname.
		public static const ICON_NAMES:Array = new Array("Map_Ship", "Map_Quest", "Map_Objective", "Map_NPC", "Map_Medical", "Map_Down", "Map_Up", "Map_Commerce", "Map_Bar");
		
		
		/* Each room only deals with the links it has to neighbours in the East + South direction (Right + Down)
		 * Ergo, we need to work out which directionality a one way link is; target to neighbour or vice versa, hence the 2 flags for directionality.
		 */
		public static const LINK_PASSAGE = 0; // 2 way connection
		public static const LINK_TARGET2NEIGHBOUR = 1; // 1 Way connection from current room to other
		public static const LINK_NEIGHBOUR2TARGET = 2; // 1 Way connection from other to current room
		public static const LINK_LOCKED = 3; // A "locked" type of link -- no engine support, but the map is configured for it... technically speaking.
		public static const LINKS_MAX = 4;
		
		public static const LINK_NAMES:Array = new Array("Map_Passage", "Map_Oneway", "Map_Oneway_Invert", "Map_Lock");
		public static const LINK_ROTATE:Array = new Array(true, true, true, false);
		
		// Display & Child object settings
		private var _childSizeX:int 	= 20; 	// Size in pixels of Map Tiles
		private var _childSizeY:int 	= 20;	// Size in pixels of Map Tiles
		private var _childNumX:int 		= 5;	// Desired number of children across the map
		private var _childNumY:int 		= 5;	// Desired number of children down the map
		private var _childSpacing:int 	= 5;	// Desired spacing between each child tile
		private var _padding:int 		= 0;
		private var _paddingLeft:int 	= 0;	// Padding to maintain around the display container and it's parent
		private var _paddingTop:int		= 0;	// Probably move this shit to some kinda CSS styled system at some point
		private var _paddingRight:int 	= 0;
		private var _paddingBottom:int  = 0;
		private var _margin:int 		= 3;	// Margin to maintain around the inner edge of the container and it's children
		private var _displayMode:int	= 0;	// Provisional method of setting up different display settings for the map
		private var _scaleMode:int		= 0;	// Scaling to use for child map elements
		
		// Positioning & Sizing settings
		private var _targetHeight:int   = 0;
		private var _targetWidth:int 	= 0;
		private var _targetX:int		= 0;
		private var _targetY:int		= 0;
		
		private var _hasMapRender:Boolean = false;
		
		private var _trackerBool:Boolean;
		private var _trackerData:*;
		private var _trackerRooms:Object;
		
		// Access/Mutator shit so I can do funky observer-pattern bollocks later on
		public function get childSizeX():int 	                          { return _childSizeX;    }
		public function get childSizeY():int 	                          { return _childSizeY;    }
		public function get childNumX():int 	                          { return _childNumX; 	   }
		public function get childNumY():int 	                          { return _childNumY; 	   }
		public function get childSpacing():int 	                          { return _childSpacing;  }
		public function get padding():int		                          { return _padding;	   }
		public function get paddingLeft():int	                          { return _paddingLeft;   }
		public function get paddingRight():int	                          { return _paddingRight;  }
		public function get paddingBottom():int	                          { return _paddingBottom; }
		public function get paddingTop():int	                          { return _paddingTop;	   }
		public function get margin():int 		                          { return _margin; 	   }
		public function get displayMode():int	                          { return _displayMode;   }
		public function get scaleMode():int		                          { return _scaleMode;	   }
		public function get childContainer():Sprite                       { return _childContainer;}
		public function get childElements():Vector.<Vector.<MinimapRoom>> { return _childElements; }
		public function get childLinksX():Vector.<Vector.<MinimapLink>>   { return _childLinksX;   }
		public function get childLinksY():Vector.<Vector.<MinimapLink>>   { return _childLinksY;   }
		
		public function get targetHeight():int	                          { return _targetHeight;  }
		public function get targetWidth():int 	                          { return _targetWidth;   }
		public function get targetX():int		                          { return _targetX;	   }
		public function get targetY():int		                          { return _targetY;	   }
		
		public function get hasMapRender():Boolean { return _hasMapRender; }
		
		public function set childSizeX(value:int):void 		{ _childSizeX = value; 		}
		public function set childSizeY(value:int):void 		{ _childSizeY = value; 		}
		public function set childNumX(value:int):void 		{ _childNumX = value; 		}
		public function set childNumY(value:int):void 		{ _childNumY = value; 		}
		public function set childSpacing(value:int):void 	{ _childSpacing = value; 	}
		public function set padding(value:int):void 		{ _paddingLeft = value; _paddingRight = value; _paddingTop = value; _paddingBottom = value;	}
		public function set paddingLeft(value:int):void		{ _paddingLeft = value;		}
		public function set paddingRight(value:int):void	{ _paddingRight = value;	}
		public function set paddingTop(value:int):void		{ _paddingTop = value;		}
		public function set paddingBottom(value:int):void	{ _paddingBottom = value; 	}
		public function set margin(value:int):void 			{ _margin = value; 			}
		public function set displayMode(value:int):void		{ _displayMode = value;		} // TODO: Add checking to the incoming value
		public function set scaleMode(value:int):void		{ _scaleMode = value;		} // TODO: Add checking to the incoming value
		
		public function set targetHeight(value:int):void	{ _targetHeight = value;	}
		public function set targetWidth(value:int):void		{ _targetWidth = value;		}
		public function set targetX(value:int):void			{ _targetX = value;			}
		public function set targetY(value:int):void			{ _targetY = value;			}
		
		
		
		// What I wouldn't give for C# style get/set declaration right now...
		
		// Easier access to child elements to avoid constant calls to this.getChildByName() etc
		private var _mapBackground:Sprite;
		private var _childContainer:Sprite;
		private var _childMask:Sprite;
		private var _childElements:Vector.<Vector.<MinimapRoom>>;
		private var _childLinksX:Vector.<Vector.<MinimapLink>>;
		private var _childLinksY:Vector.<Vector.<MinimapLink>>;
		
		/**
		 * Contructor
		 * Configure the object to listen for its addition to the display list, so we can query parent container info.
		 */
		public function MiniMap() 
		{			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Init
		 * Break out calls to the primary construction mechanics of the object.
		 */
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Figure out what the parents settings our, if targets haven't been set -- this should let the container map itself
			// autosize to whatever contains it, so you don't have to fuck about with the internals of the class -- create a display
			// object to stick it in and it'll make itself fit (hurr). This should also allow it to fill in singular directions with a fixed
			// other dimension.
			if (this.targetHeight == 0) this.targetHeight = this.parent.height;
			if (this.targetWidth == 0) this.targetWidth = this.parent.width;
			
			this.BuildContainer();
			this.BuildChildren();
			
			trace("MiniMap constructed!");
		}
		
		/**
		 * Primary method of building the actual graphical elements and positioning everything appropriately.
		 */
		private function BuildContainer():void
		{
			// We're going to position the container within a parent element, possibly the Left Side Bar, but this will work with
			// ANY type of parent container object.
			
			// Calculate the required padding
			var padValue:int = Math.floor(_padding / 2);
			
			// And position the element accordingly
			this.x = _targetX + this.paddingLeft;
			this.y = _targetY + this.paddingTop;
			
			// Build a graphical element to use as a "background" for the map
			_mapBackground = new Sprite();
			_mapBackground.name = "mapbackground";
			_mapBackground.graphics.beginFill(UIStyleSettings.gBackgroundColour, 1);
			_mapBackground.graphics.drawRect(0, 0, this.targetWidth - this.paddingRight, this.targetHeight - this.paddingBottom);
			_mapBackground.graphics.endFill();
			this.addChild(_mapBackground);
			
			// We're seperating the container used for the background from the container used for most child elements so that we can hide parts of children without fucking with the background
			_childContainer = new Sprite();
			_childContainer.name = "mapchildren";
			_childContainer.x = this.width / 2;
			_childContainer.y = this.height / 2;
			this.addChild(_childContainer);
			
			// Create the mask for the child container
			_childMask = new Sprite();
			_childMask.name = "mapchildrenmask";
			_childMask.graphics.beginFill(0xFFFFFF);
			_childMask.graphics.drawRect(0, 0, this.targetWidth - this.paddingRight, this.targetHeight - this.paddingBottom);
			_childMask.graphics.endFill();
			this.addChild(_childMask);
			
			// Apply the mask
			_childContainer.mask = _childMask;
			
			// Now if we add things to childContainer that fall outside of the bounds of our background, they'll be partially/completely hidden
			// Done it seperately so I can later support having a padding/margin around the edge of the background easily - shrink the mask, gain a border.
		}
		
		/**
		 * Build the child elements we're going to use for map display
		 */
		private function BuildChildren():void
		{
			// Determine the type of child scaling we want to use			
			
			// Don't adapt the children to the size of the container -- our other settings are considered gospel
			if (this.scaleMode == MiniMap.SCALE_MODE_FIXED)
			{
				this.BuildChildrenNoScale();
			}
			// Adapt the number of children we're going to build to fill the available area, but don't change their size
			else if (this.scaleMode == MiniMap.SCALE_MODE_NUMBER)
			{
				this.BuildChildrenScaleNumber();
			}
			// Adapt the size of the children we're going to build to fill the available area, but don't change the number
			else if (this.scaleMode == MiniMap.SCALE_MODE_SIZE)
			{
				this.BuildChildrenScaleSize();
			}
		}
		
		/**
		 * Build the child elements exactly how the object has been configured
		 */
		private function BuildChildrenNoScale():void
		{
			var startXPos:int = 0;
			var startYPos:int = 0;
			var numX:int;
			var numY:int;
			
			// Figure out our centre position
			// Remove the size of half of our child elements + associated spacing
			startXPos -= (childSizeX * (childNumX / 2));
			startXPos -= (childSpacing * ((childNumX - 1 )/ 2));
			startYPos -= (childSizeY * (childNumY / 2));
			startYPos -= (childSpacing * ((childNumY - 1)/ 2));
			
			// Init the primary container
			_childElements = new Vector.<Vector.<MinimapRoom>>(childNumX);

			var childXPos:int = startXPos;
			
			// For all rows...
			for (numX = 0; numX < childNumX; numX++)
			{
				var childYPos:int = startYPos;
				
				// ... init the secondary container
				_childElements[numX] = new Vector.<MinimapRoom>(childNumY);
				
				// For all columns...
				for (numY = 0; numY < childNumY; numY++)
				{
					// ... Build the sprite
					var childSprite = new MinimapRoom(childSizeX, childSizeY);
					childSprite.name = String(numX) + "." + String(numY);
					
					_childElements[numX][numY] = childSprite;
					_childContainer.addChild(childSprite)
					
					childSprite.x = childXPos;
					childSprite.y = childYPos;
					
					childYPos += (childSizeY + childSpacing);
				}
				childXPos += (childSizeX + childSpacing);
			}
			
			// Build the associated Links container (linkages between rooms) -- These are going to be offset from the primary room display...
			// The links are kept seperate from the main room display objects for math simplicity; positioning them within the same parent as the room makes
			// it messier to calculate the proper centre positions and such (its still possible, its not even hard really), but it'll be the subject of later refactoring. Make it work, then make it nice to look at.
			
			// X links should be a 6x7 grid
			_childLinksX = new Vector.<Vector.<MinimapLink>>(childNumX - 1);
			
			for (numX = 0; numX < (childNumX - 1); numX++)
			{
				_childLinksX[numX] = new Vector.<MinimapLink>(childNumY);
				
				for (numY = 0; numY < childNumY; numY++)
				{
					var linkObjX = new MinimapLink(false);
					_childContainer.addChild(linkObjX);
					
					linkObjX.x = _childElements[numX][numY].x + (childSizeX + (childSpacing / 2));
					linkObjX.y = _childElements[numX][numY].y + (childSizeY / 2);
					
					_childLinksX[numX][numY] = linkObjX;
				}
			}
			
			// Y links should be a 7x6 grid
			_childLinksY = new Vector.<Vector.<MinimapLink>>(childNumX);
			
			for (numX = 0; numX < childNumX; numX++)
			{
				_childLinksY[numX] = new Vector.<MinimapLink>(childNumY - 1);
				
				for (numY = 0; numY < (childNumY - 1); numY++)
				{
					var linkObjY = new MinimapLink(true);
					_childContainer.addChild(linkObjY);
					
					linkObjY.x = _childElements[numX][numY].x + (childSizeX / 2);
					linkObjY.y = _childElements[numX][numY].y + (childSizeY + (childSpacing / 2));
					
					_childLinksY[numX][numY] = linkObjY;
				}
			}
		}
		
		private function BuildChildrenScaleNumber():void
		{
			throw new Error("Not yet implemented");
		}
		
		private function BuildChildrenScaleSize():void
		{
			throw new Error("Not yet implemented");
		}
		
		/**
		 * Spam some debug output and force-set the map to be visible
		 */
		public function debug():void
		{
			this.visible = true;
			trace("Located at (x,y):(" + this.x + "," + this.y + ")");
			trace("Dimensions (x,y):(" + this.width + "," + this.height + ")");
			trace("Target Dimensions (x,y):(" + this.targetWidth + "," + this.targetHeight + ")");
			trace("Parent Dimensions (x,y):(" + this.parent.width + "," + this.parent.height + ")");
		}
		
		private function roomConnection(sourceExit:String, targetExit:String):int
		{
			if(sourceExit && targetExit) return LINK_PASSAGE;
			if(sourceExit && !targetExit) return LINK_TARGET2NEIGHBOUR;
			if(!sourceExit && targetExit) return LINK_NEIGHBOUR2TARGET;
			if(!sourceExit && !targetExit) return -1;
			
			throw new Error("Couldn't determine room linkage!");
		}
		
		public function map(room:RoomClass):void
		{
			this._hasMapRender = true;
			resetChildren();
			mapRoom(room, _childNumX / 2, _childNumY / 2, kGAMECLASS.rooms);
			
			if(_trackerData != null) 
			{
				if(_trackerData == kGAMECLASS.rooms[kGAMECLASS.currentLocation])
				{
					_trackerData = null;
					return;
				}
				var path:Array = track(kGAMECLASS.rooms[kGAMECLASS.currentLocation], _trackerData);
				lightUpPath(path, UIStyleSettings.gMinimapTrackerColorTransform, _trackerBool);
			}
		}
		
		private function mapRoom(room:RoomClass, xPos:int, yPos:int, roomsObj:*, completeRooms:Array = null):void
		{
			if(completeRooms == null) completeRooms = new Array();
			if(room == null) return;
			if(completeRooms.indexOf(room) != -1) return;
			if(xPos < 0 || yPos < 0 || xPos >= _childNumX || yPos >= _childNumY) return;
			
			completeRooms.push(room);
			var tarSprite:MinimapRoom = _childElements[xPos][(_childNumY - 1) - yPos];
			tarSprite.visible = true;
			
			if(room == roomsObj[kGAMECLASS.currentLocation]) tarSprite.setColour(UIStyleSettings.gMapPCLocationRoomColourTransform);
			else if(room.hasFlag(GLOBAL.INDOOR))             tarSprite.setColour(UIStyleSettings.gMapIndoorRoomFlagColourTransform);
			else if(room.hasFlag(GLOBAL.OUTDOOR))            tarSprite.setColour(UIStyleSettings.gMapOutdoorRoomFlagColourTransform);
			else                                             tarSprite.setColour(UIStyleSettings.gMapFallbackColourTransform);
			
			if(room.inExit)                          tarSprite.setIcon(ICON_UP);
			else if(room.outExit)                    tarSprite.setIcon(ICON_DOWN);
			else if(room.hasFlag(GLOBAL.SHIPHANGAR)) tarSprite.setIcon(ICON_SHIP);
			else if(room.hasFlag(GLOBAL.NPC))        tarSprite.setIcon(ICON_NPC);
			else if(room.hasFlag(GLOBAL.MEDICAL))    tarSprite.setIcon(ICON_MEDICAL);
			else if(room.hasFlag(GLOBAL.COMMERCE))   tarSprite.setIcon(ICON_COMMERCE);
			else if(room.hasFlag(GLOBAL.BAR))        tarSprite.setIcon(ICON_BAR);
			else if(room.hasFlag(GLOBAL.OBJECTIVE))  tarSprite.setIcon(ICON_OBJECTIVE);
			else if(room.hasFlag(GLOBAL.QUEST))      tarSprite.setIcon(ICON_QUEST);
			else                                     tarSprite.setIcon(-1);
			
			if(room.hasFlag(GLOBAL.HAZARD)) tarSprite.showHazard();
			else                            tarSprite.hideHazard();
			
			if(room.northExit) mapRoom(roomsObj[room.northExit], xPos, yPos + 1, roomsObj, completeRooms);
			if(room.southExit) mapRoom(roomsObj[room.southExit], xPos, yPos - 1, roomsObj, completeRooms);
			if(room.westExit)  mapRoom(roomsObj[room.westExit], xPos - 1, yPos, roomsObj, completeRooms);
			if(room.eastExit)  mapRoom(roomsObj[room.eastExit], xPos + 1, yPos, roomsObj, completeRooms);
			
			if(xPos >= _childNumX - 2 || yPos <= 0) return;
			
			if(room.southExit) _childLinksY[xPos][(_childNumY - 1) - yPos].setLink(roomConnection(room.southExit, roomsObj[room.southExit].northExit));			
			if(room.eastExit)  _childLinksX[xPos][(_childNumY - 1) - yPos].setLink(roomConnection(room.eastExit, roomsObj[room.eastExit].westExit));
		}
		
		public function resetChildren():void
		{
			for each(var vec:Vector.<MinimapRoom> in _childElements)
			{
				for each(var mRoom:MinimapRoom in vec)
				{
					mRoom.visible = false;
				}
			}
			for each(var xArr:Vector.<MinimapLink> in _childLinksX)
			{
				for each(var xLink:MinimapLink in xArr)
				{
					xLink.setLink(-1);
				}
			}
			for each(var yArr:Vector.<MinimapLink> in _childLinksY)
			{
				for each(var yLink:MinimapLink in yArr)
				{
					yLink.setLink(-1);
				}
			}
		}
		
		public function track(roomFrom:*, roomTo:*):Array
		{
			if(roomFrom == roomTo) return null;
			this._trackerRooms = new Object();
			pathFind(roomFrom, roomTo, 0);
			//If the room is unreachable, end
			if(!_trackerRooms[roomTo]) return null;
			var path:Array = findPath(roomFrom, roomTo, new Array());
			path.splice(0, 0, roomFrom);
			return path;
		}
		
		//Finds all paths
		private function pathFind(roomFrom:*, roomTo:*, num:int):void
		{
			_trackerRooms[roomFrom] = num;
			if(roomFrom == roomTo) return;
			for each(var room:* in roomFrom.exits)
			{
				if(_trackerRooms[room] === undefined) pathFind(room, roomTo, num + 1);
				else if(_trackerRooms[room] > num + 1) pathFind(room, roomTo, num + 1);
			}
		}
		
		//Finds shortest path
		private function findPath(roomFrom:*, roomTo:*, path:Array):Array
		{
			path.push(roomTo);
			var nearestRoom:*;
			var distance:int = -1;
			for each(var room:* in roomTo.exits)
			{
				if(_trackerRooms[room] !== undefined && (distance == -1 || _trackerRooms[room] < distance))
				{					
					nearestRoom = room;
					distance = _trackerRooms[room];
				}
			}
			
			if(nearestRoom == roomFrom) return path.reverse();
			return findPath(roomFrom, nearestRoom, path);
		}
		
		//Doesn't work for starting locations other than current location, sorry!
		//Also, no clue why I need this extraBool, but I'll figure it out later
		public function lightUpPath(path:Array, color:ColorTransform = null, extraBool:Boolean = false):void
		{
			this._trackerData = path[path.length - 1];
			this._trackerBool = extraBool;
			
			if(color == null) color = UIStyleSettings.gMinimapTrackerColorTransform;
			var j:int = 1;
			if(!path[0].isCurrentLocation)
			{
				for(var i:int = 0; i < path.length; i++)
				{
					if(path[i].isCurrentLocation)
					{
						j = i + 1;
						break;
					}
				}
			}
			
			var coordX:int = this._childNumX / 2;
			var coordY:int = this._childNumY / 2;
			if(extraBool) coordY--;
			
			for(; j < path.length; j++)
			{
				var nextRoom:* = path[j];
				if(nextRoom == kGAMECLASS.rooms[path[j - 1].northExit])
				{
					lightUpVerticalLink(coordX, coordY - 1, UIStyleSettings.gMinimapTrackerColorTransform);
					coordY--;
				}
				if(nextRoom == kGAMECLASS.rooms[path[j - 1].southExit])
				{
					lightUpVerticalLink(coordX, coordY, UIStyleSettings.gMinimapTrackerColorTransform);
					coordY++;
				}
				if(nextRoom == kGAMECLASS.rooms[path[j - 1].eastExit])
				{
					lightUpHorizontalLink(coordX, coordY, UIStyleSettings.gMinimapTrackerColorTransform);
					coordX++;
				}
				if(nextRoom == kGAMECLASS.rooms[path[j - 1].westExit])
				{
					lightUpHorizontalLink(coordX - 1, coordY, UIStyleSettings.gMinimapTrackerColorTransform);
					coordX--;
				}
			}
			
			if(nextRoom == path[path.length - 1])
			{
				if(coordX >= 0 && coordX < this._childNumX && coordY >= 0 && coordY < this._childNumY) _childElements[coordX][coordY].setGhostColour(UIStyleSettings.gMinimapTrackerColorTransform);
			}
		}
		
		public function lightUpHorizontalLink(coordX:int, coordY:int, color:ColorTransform):void
		{
			if(coordX < 0 || coordX >= childLinksX.length || coordY < 0 || coordY >= childLinksX[0].length) return;
			lightUpLink(_childLinksX[coordX][coordY], color);
		}
		
		public function lightUpVerticalLink(coordX:int, coordY:int, color:ColorTransform):void
		{
			if(coordX < 0 || coordX >= childLinksY.length || coordY < 0 || coordY >= childLinksY[0].length) return;
			lightUpLink(_childLinksY[coordX][coordY], color);
		}
		
		public function lightUpLink(link:MinimapLink, color:ColorTransform):void
		{
			link.setGhostColour(color);
		}
		
		public function lightUpRoom(room:MinimapRoom, color:ColorTransform):void
		{
			room.setGhostColour(color);
		}
	}
}