﻿package com.nodemenu {		import flash.display.Sprite;	import flash.display.Graphics;	import flash.geom.Point;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.net.URLRequest;	import flash.net.URLLoader;		import fl.transitions.Tween;	import fl.transitions.TweenEvent;	import fl.transitions.easing.*;		import com.greensock.*; 	import com.greensock.easing.*;		import com.nodemenu.NodeButton;	import com.nodemenu.ConfigureNode;		import com.afcomponents.tooltip.ContentType;		public class NodeMenu extends Sprite {				public var menuActive:Boolean;				private var _mainBtn:NodeButton;		private var _buttons:Array;		private var _hitArea:Sprite;		private var _origin:Point;				private var _buttonsTween:Array;		private var _currentTweenButton:NodeButton;		private var _currentTweenIndex:uint;		private var _tweenDelay:Timer;				private var xmlLoader:URLLoader = new URLLoader();		private var xmlData:XML = new XML();		private var xmlLoaded:Boolean = false;				private var _nodeCount:uint;		private var _nodeOffset:Number;		private var _nodeInitialDiameter:Number;		private var _nodeFinalDiameter:Number;		private var _myTooltip = new TooltipComponent();						/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::		INITIALIZATION		::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/		private function init():void {			_buttons = [];			mouseEnabled = false;						_myTooltip.type = ContentType.TEXT;			_myTooltip.content = "NeatoAFC";			_myTooltip.contentStyle.textColor = 0x000000;						addEventListener(MouseEvent.ROLL_OVER,showTooltip);						//_myTooltip.setChildIndex(numChildren-1);		}				private function LoadXml():void {			xmlLoader.addEventListener(Event.COMPLETE, onXmlLoaded);			xmlLoader.load(new URLRequest("config.xml"));		}				private function onXmlLoaded(e:Event):void {			xmlLoader.removeEventListener(Event.COMPLETE, onXmlLoaded);			xmlData = new XML(e.target.data);			xmlLoaded = true;			dispatchEvent(new NodeEvent(NodeEvent.XML_LOADED));		}				public function ParseXml(e:NodeEvent):void  {			removeEventListener(NodeEvent.XML_LOADED,ParseXml);						_nodeCount = xmlData.nodeButtons.nodeButton.length();			if(xmlData.nodeButtons.hasOwnProperty("nodeOffset")) {				_nodeOffset = xmlData.nodeButtons.nodeOffset;			}			if(xmlData.nodeButtons.hasOwnProperty("initialDiameter")) {				_nodeInitialDiameter = xmlData.nodeButtons.initialDiameter;			}			if(xmlData.nodeButtons.hasOwnProperty("finalDiameter")) {				_nodeFinalDiameter = xmlData.nodeButtons.finalDiameter;			}						constructMenu();		}				/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::		CONSTRUCTOR		::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/		public function NodeMenu() {			init();			addEventListener(NodeEvent.XML_LOADED,ParseXml);			LoadXml();			addEventListener(Event.ENTER_FRAME,enterFrame_handler);					}				private function enterFrame_handler(e:Event):void {			if(xmlLoaded) {				switch(_mainBtn.buttonActive) {					case true:						activateMenu();						break;										case false:						disableMenu();						break;				}			}		}				private function constructMenu():void {			createMainButton(xmlData.mainBtn);			createNodeButtons();						displayButtons();						_origin = new Point(_mainBtn.x,_mainBtn.y);			createHitArea();		}				private function createNodeButtons():void {			var nodeButtonList:XMLList = xmlData.nodeButtons.nodeButton;			for each (var node:XML in nodeButtonList) {				createNodeButton(node);			}		}				public function createMainButton(node) {			var nodeConf:ConfigureNode = new ConfigureNode();			if(node.hasOwnProperty("nodeName")) {				nodeConf.nodeName = node.nodeName;			}			if(node.hasOwnProperty("initialDiameter")) {				nodeConf.initialDiameter = node.initialDiameter;			}			if(node.hasOwnProperty("finalDiameter")) {				nodeConf.finalDiameter = node.finalDiameter;			}			if(node.hasOwnProperty("fillColor")) {				nodeConf.fillColor = node.fillColor;			}			if(node.hasOwnProperty("fillAlpha")) {				nodeConf.fillAlpha = node.fillAlpha;			}			if(node.hasOwnProperty("borderColor")) {				nodeConf.borderColor = node.borderColor;			}			if(node.hasOwnProperty("borderThickness")) {				nodeConf.borderThickness = node.borderThickness;			}			if(node.hasOwnProperty("borderAlpha")) {				nodeConf.borderAlpha = node.borderAlpha;			}			if(node.hasOwnProperty("initialAlpha")) {				nodeConf.initialAlpha = node.initialAlpha;			}			if(node.hasOwnProperty("finalAlpha")) {				nodeConf.finalAlpha = node.finalAlpha;			}						if(node.hasOwnProperty("contentIsImage")) {				if(node.contentIsImage == "true") {					nodeConf.contentIsImage = true;				} else {					nodeConf.contentIsImage = false;				}			}			if(node.hasOwnProperty("nodeContent")) {				nodeConf.nodeContent = node.nodeContent;			}			if(node.hasOwnProperty("nodeContentSize")) {				nodeConf.nodeContentSize = node.nodeContentSize;			}			if(node.hasOwnProperty("nodeContentFont")) {				nodeConf.nodeContentFont = node.nodeContentFont;			}			if(node.hasOwnProperty("nodeContentColor")) {				nodeConf.nodeContentColor = node.nodeContentColor;			}			if(node.hasOwnProperty("nodeContentAlign")) {				nodeConf.nodeContentAlign = node.nodeContentAlign;			}			if(node.hasOwnProperty("nodeContentAlpha")) {				nodeConf.nodeContentAlpha = node.nodeContentAlpha;			}			//nodeConf.xPos = this.x;			//nodeConf.yPos = this.y;						_mainBtn = new NodeButton(nodeConf);			addChild(_mainBtn);		}				public function createNodeButton(node):void {			var nodeConf:ConfigureNode = new ConfigureNode();			if(node.hasOwnProperty("nodeName")) {				nodeConf.nodeName = node.nodeName;			}			nodeConf.initialDiameter = _nodeInitialDiameter;			nodeConf.finalDiameter = _nodeFinalDiameter;			if(node.hasOwnProperty("fillColor")) {				nodeConf.fillColor = node.fillColor;			}			if(node.hasOwnProperty("fillAlpha")) {				nodeConf.fillAlpha = node.fillAlpha;			}			if(node.hasOwnProperty("borderColor")) {				nodeConf.borderColor = node.borderColor;			}			if(node.hasOwnProperty("borderThickness")) {				nodeConf.borderThickness = node.borderThickness;			}			if(node.hasOwnProperty("borderAlpha")) {				nodeConf.borderAlpha = node.borderAlpha;			}			if(node.hasOwnProperty("initialAlpha")) {				nodeConf.initialAlpha = node.initialAlpha;			}			if(node.hasOwnProperty("finalAlpha")) {				nodeConf.finalAlpha = node.finalAlpha;			}						if(node.hasOwnProperty("contentIsImage")) {				if(node.contentIsImage == "true") {					nodeConf.contentIsImage = true;				} else {					nodeConf.contentIsImage = false;				}			}			if(node.hasOwnProperty("nodeContent")) {				nodeConf.nodeContent = node.nodeContent;			}			if(node.hasOwnProperty("nodeContentSize")) {				nodeConf.nodeContentSize = node.nodeContentSize;			}			if(node.hasOwnProperty("nodeContentFont")) {				nodeConf.nodeContentFont = node.nodeContentFont;			}			if(node.hasOwnProperty("nodeContentColor")) {				nodeConf.nodeContentColor = node.nodeContentColor;			}			if(node.hasOwnProperty("nodeContentAlign")) {				nodeConf.nodeContentAlign = node.nodeContentAlign;			}			if(node.hasOwnProperty("nodeContentAlpha")) {				nodeConf.nodeContentAlpha = node.nodeContentAlpha;			}						addButton(nodeConf);		}				public function addButton(config):void {						var nodeBtn:NodeButton = new NodeButton(config);			var coords:Point = position(_buttons.length,config.initialDiameter);			nodeBtn.x = coords.x;			nodeBtn.y = coords.y;			nodeBtn.name = config.nodeName;						_buttons.push(nodeBtn);		}				private function position(currentCount:uint,nodeDiameter:Number):Point {			var angle:Number = (_buttons.length*(360/_nodeCount));			var radians:Number = angle*(Math.PI/180);			var radius:Number = _nodeOffset;//-nodeDiameter/2;			var position = Point.polar(radius,radians);						return position;		}						private function displayButtons():void {			for each(var button:NodeButton in _buttons) {				button.width = 0;				button.height = 0;				addChild(button);			}		}				private function createHitArea():void {			_hitArea = new Sprite();			_hitArea.graphics.beginFill(0xff0000,0);			_hitArea.graphics.drawCircle(_origin.x,_origin.y,_nodeOffset+(_nodeFinalDiameter/2));			_hitArea.graphics.endFill();			_hitArea.visible = false;			addChildAt(_hitArea,0);			hitArea = _hitArea;		}				private function buttonTweenInit():NodeButton {			//_tweenDelay = new Timer(1000,1);			//_tweenDelay.addEventListener(TimerEvent.TIMER_COMPLETE,onTweenDelay_complete);			//_tweenDelay.start();			var button:NodeButton = _buttonsTween.shift();			_currentTweenButton = button;			//_currentTweenIndex = i;			button.width = 0;			button.height = 0;			//_tweenDelay.start();			return button;		}				private function activateMenu():void {			if(!stage.hasEventListener(MouseEvent.MOUSE_MOVE)) {				stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove_handler);				_buttonsTween = createNewButtonsArray(_buttons);								_mainBtn.buttonMode = false;				displayButtons();			}			if(_buttonsTween.length>0) {				var button:NodeButton = buttonTweenInit();				button.filters = null;				//button.addEventListener(MouseEvent.ROLL_OVER,showTooltip);				//stage.addChild(_myTooltip);								TweenLite.to(button, 2, {autoAlpha:button.initialAlpha,setActualSize:{width:button.initialDiameter, height:button.initialDiameter}, ease:Elastic.easeOut});				//bubbleOut(button,button.initialDiameter,button.initialDiameter);				_mainBtn.removeMouseOut();			}						dispatchEvent(new NodeEvent(NodeEvent.MENU_OPEN));			menuActive = true;						_mainBtn.removeMouseOut();					}				private function disableMenu():void {			if(stage.hasEventListener(MouseEvent.MOUSE_MOVE)) {				stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove_handler);				_buttonsTween = createNewButtonsArray(_buttons);				_mainBtn.buttonMode = true;			}			if(menuActive) {				var i:uint = 0;				for each(var button:NodeButton in _buttons) {					//TweenLite.to(button, .3, {autoAlpha:0,blurFilter:{blurX:20, blurY:20, quality:1, remove:true}, setActualSize:{width:0, height:0}, ease:Quint.easeIn});					TweenLite.to(button, .5, {autoAlpha:0,blurFilter:{blurX:100, blurY:100, quality:2, remove:true}, setActualSize:{width:0, height:0}, ease:Quint.easeIn});				}				menuActive = false;			}						//mouseEnabled = false;			dispatchEvent(new NodeEvent(NodeEvent.MENU_CLOSED));			_mainBtn.addMouseOut();		}				private function onTweenDelay_complete(e:TimerEvent):void {			_tweenDelay.removeEventListener(TimerEvent.TIMER_COMPLETE,onTweenDelay_complete);			var button:NodeButton = buttonTweenInit();			TweenLite.to(button, 1.5, {autoAlpha:button.initialAlpha,setActualSize:{width:button.initialDiameter, height:button.initialDiameter}, ease:Elastic.easeOut});		}				private function bubbleOut(target:NodeButton,finalWidth:Number,finalHeight:Number):void{			var xspeed:Number=0;			var yspeed:Number=0;			var damp:Number=.95;			var acc:Number=.05;						var xd:Number=(finalWidth-target.width)*acc;			var yd:Number=(finalHeight-target.height)*acc;			xspeed=(xspeed+xd)*damp;			yspeed=(yspeed+yd)*damp;			target.width +=xspeed;			target.height +=yspeed;		}				private function createNewButtonsArray(sourceArr:Array):Array {			var targetArr:Array = new Array(_nodeCount);			for(var i:uint=0;i<_nodeCount;i++) {				targetArr[i] = sourceArr[i];			}			return targetArr;		}				private function mouseMove_handler(e:MouseEvent):void {			var mouseLoc:Point = localToGlobal(new Point(mouseX,mouseY));						if(!hitTestPoint(mouseLoc.x,mouseLoc.y,true)) {				_mainBtn.closeNode();			}					}				private function showTooltip(e:MouseEvent):void {			if(_currentTweenButton!=null) {				_currentTweenButton.removeEventListener(MouseEvent.ROLL_OVER,showTooltip);				_currentTweenButton.addEventListener(MouseEvent.ROLL_OUT,hideTooltip);			}			_myTooltip.show();		}				private function hideTooltip(e:MouseEvent):void {			if(_currentTweenButton!=null) {				_currentTweenButton.removeEventListener(MouseEvent.ROLL_OUT,hideTooltip);				_currentTweenButton.addEventListener(MouseEvent.ROLL_OVER,showTooltip);			}			_myTooltip.hide();		}			}	}