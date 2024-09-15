package com.sploder.util

{

    import com.sploder.asui.ScrollBar;

    import flash.display.Stage;

    import flash.events.MouseEvent;

    import flash.external.ExternalInterface;

    

    public class ScrollHelper

    {

        private static var _instance:ScrollHelper;

        

        public var vScroller:ScrollBar;

        public var hScroller:ScrollBar;

        public var multiplier:Number = 1;

        

        private var _stage:Stage;

        private var _currItem:Object;



        // Add SCROLL_SCRIPT property

        private var SCROLL_SCRIPT:String;



        public function ScrollHelper()

        {

            // Initialize SCROLL_SCRIPT property

            SCROLL_SCRIPT = (<![CDATA[

                function setupScrolling(objectID) {

                    var flashObject = document.getElementsByName(objectID)[0];

                    var eventListenerObject = flashObject;

                    var isWebkit = false;

                    

                    if (navigator && navigator.vendor) {

                        isWebkit = navigator.vendor.match("Apple") || navigator.vendor.match("Google");

                    }

                    

                    if (isWebkit && flashObject.parentNode.tagName.toLowerCase() == "object") {

                        eventListenerObject = flashObject.parentNode;

                    }

                    

                    var scrollHandler = function(event) {

                        var xDelta = 0;

                        var yDelta = 0;

                        

                        if (!event) event = window.event;

                        

                        if (event.wheelDelta) {

                            if (event.wheelDeltaX) {

                                xDelta = event.wheelDeltaX;

                                yDelta = event.wheelDeltaY;

                            } else {

                                yDelta = event.wheelDelta;

                            }

                            xDelta /= 120;

                            yDelta /= 120;

                            

                            if (!navigator.vendor.match("Google")) {

                                xDelta /= 10;

                                yDelta /= 10;                                

                            }

                            

                            if (window.opera) {

                                yDelta = -yDelta;

                            }

                        } else if (event.detail) {

                            yDelta = -event.detail / 1.5;

                            if (event.axis) {

                                if (event.axis == event.HORIZONTAL_AXIS) {

                                    xDelta = yDelta;

                                    yDelta = 0;

                                }

                            }

                        }

                        

                        try {

                            flashObject.scrollEvent(xDelta, yDelta);

                        } catch(e) {}

                        

                        if (event.preventDefault) event.preventDefault();

                        event.returnValue = false;            

                    };

                    

                    if (window.addEventListener) {

                        eventListenerObject.addEventListener('mouseover', function(e) {

                            if (isWebkit) {

                                window.onmousewheel = scrollHandler;

                            } else {

                                window.addEventListener("DOMMouseScroll", scrollHandler, false);

                            }

                        }, false);

                    } else {

                        flashObject.onmouseover = function(e) {

                            document.onmousewheel = scrollHandler;

                        };

                    }

                }

            ]]>).toString();

            

            super();

            setupExternal();

        }

        

        public static function get instance() : ScrollHelper

        {

            if(_instance == null)

            {

                _instance = new ScrollHelper();

            }

            return _instance;

        }

        

        private function setupExternal() : void

        {

            if (ExternalInterface.available) {

                ExternalInterface.addCallback("scrollEvent", this._scrollEvent);

                ExternalInterface.call("eval", SCROLL_SCRIPT);

                ExternalInterface.call("setupScrolling", ExternalInterface.objectID);

            }

        }

        

        public function setup(param1:Stage) : void

        {

            this._stage = param1;

            this._stage.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHander);

        }

        

        private function mouseMoveHander(param1:MouseEvent) : void

        {

            this._currItem = null;

        }

        

        private function _scrollEvent(param1:Number, param2:Number) : void

        {

            param1 *= this.multiplier;

            param2 *= this.multiplier;

            if (this.vScroller) {

                this.vScroller.applyDelta(param2);

            }

            if (this.hScroller) {

                this.hScroller.applyDelta(param1);

            }

        }

    }

}