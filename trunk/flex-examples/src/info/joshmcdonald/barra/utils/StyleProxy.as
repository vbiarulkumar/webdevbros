package info.joshmcdonald.barra.utils
{
    import flash.debugger.enterDebugger;
    import flash.events.IEventDispatcher;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    import mx.core.Application;
    import mx.core.IMXMLObject;
    import mx.core.UIComponent;
    import mx.events.PropertyChangeEvent;

    [Bindable(event="propertyChange")]
    public dynamic class StyleProxy extends Proxy implements IEventDispatcher, IMXMLObject
    {
        //--------------------------------------------------------------------------
        //
        //  Simply implements IEventDispatcher, as we can't extend EventDispatcher
        //
        //--------------------------------------------------------------------------

        include "../include/basicEventDispatcher.as.inc";

        //--------------------------------------------------------------------------
        //
        //  IMXMLObject - just to make usage easier
        //
        //--------------------------------------------------------------------------

        public function initialized(document : Object, id : String) : void
        {
            if ("getStyle" in document && !component)
                component = document;
        }

        //--------------------------------------------------------------------------
        //
        //  Impl
        //
        //--------------------------------------------------------------------------

        //The actual component we're interested in
        private var _component : Object;

        //The list of things we've been asked for
        private var interestingStyles : Object = {};

        function StyleProxy(component : UIComponent = null)
        {
            this.component = component;
        }

        public function get component() : Object
        {
            return _component;
        }

        public function set component(value : Object) : void
        {
            if (_component && _component != value)
            {
                interestingStyles = {};
            }

            _component = value;
            handleStyleChange(null); //Update all bindings
        }

        public function handleStyleChange(styleProp : String) : void
        {
            if (styleProp == null)
            {
                //"All" styles reset. Notify for everything we're interested in
                for (var prop : String in interestingStyles)
                {
                    interestingStyleChanged(prop);
                }
            }
            else if (styleProp in interestingStyles)
            {
                interestingStyleChanged(styleProp);
            }
        }

        /**
        * Returns the current value, and marks the requested value as "interesting" so change events will be dispatched from now on.
        */
        override flash_proxy function getProperty(name : *) : *
        {
            return currentValueFor(String(name));
        }

        /**
        * Returns the current style value for "name" to the best of our ability
        */
        private function currentValueFor(name : String) : Object
        {
            var value : Object = component ? component.getStyle(name) : Application.application.getStyle(name);
            interestingStyles[name] = value;
            return value;
        }

        /**
        * Hands out notifications
        */
        private function interestingStyleChanged(styleName : String) : void
        {
            var oldVal : Object = interestingStyles[styleName];
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, styleName, oldVal, currentValueFor(styleName)));
        }
    }
}