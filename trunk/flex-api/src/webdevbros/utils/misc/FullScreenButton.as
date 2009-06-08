package webdevbros.utils.misc
{
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.core.Container;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	[Exclude(name="label", kind="property")]
	[Exclude(name="includeInLayout", kind="property")]
	[Exclude(name="visible", kind="property")]
	[Event(name="normal", type="flash.events.Event")]
	[Event(name="fullscreen", type="flash.events.Event")]
	public class FullScreenButton extends Button {
		
		public function FullScreenButton() {
			super();
			
			this.label = "FULLSCREEN";
			this.visible = false;
			this.includeInLayout = false;
			this.addEventListener(FlexEvent.INITIALIZE, onInitialize);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			this.setStyle("paddingLeft", 0);
			this.setStyle("paddingRight", 0);
			this.setStyle("paddingTop", 0);
			this.setStyle("paddingBottom", 0);
		}
		
		private var _target:Container;
		public function get target():Container {
			return _target;
		}
		public function set target(value:Container):void {
			if (value && value != _target) {
				if (_target) {
					_target.removeEventListener(ResizeEvent.RESIZE, onTargetResized);
					_target.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
					_target.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOver);
					
					this.visible = false;	
				}
				
				_target = value;
				
				_target.addEventListener(ResizeEvent.RESIZE, onTargetResized);
				_target.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				_target.addEventListener(MouseEvent.MOUSE_OUT, onMouseOver);
			}
		}
		
		private var _fullscreen:Boolean = false;
		private function get fullscreen():Boolean {
			return _fullscreen;
		}
		private function set fullscreen(value:Boolean):void {
			if (value != _fullscreen) {
				try {
            		systemManager.stage.displayState = value ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
            		_fullscreen = value;
           		} catch (err:SecurityError) {
                	// ignore
                	trace(err);
            	}
			}
		}
		
		private function onInitialize(event:Event):void {
            systemManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
//            systemManager.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        }
        
        private function onCreationComplete(event:Event):void {
        	if (target) target.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
        }
        
        private function onClick(event:Event):void {
        	toggleFullScreen();
        }
        
        private function onMouseOver(event:MouseEvent):void {
        	if (!fullscreen) this.visible = true;
        }
        
        private function onMouseOut(event:MouseEvent):void {
        	this.visible = false;
        }
        
        private function onTargetResized(event:ResizeEvent):void {
        	this.x = target.width - width - 5;
        	this.y = 5;
        }
        
        private function onFullScreen(evt:FullScreenEvent):void {
            dispatchEvent(new Event(evt.fullScreen ? "fullscreen" : "normal"));
        }
		
		private function toggleFullScreen():void {
            fullscreen = !fullscreen;
        }
	}
}