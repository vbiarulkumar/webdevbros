package webdevbros.utils.metadata
{
	import mx.formatters.Formatter;
	import mx.validators.Validator;
	
	// Metadata used for Flex clients:
	// ### HEADERS ###
	// * Display name (short, long) -> loaded via runtime localization
	// * Description (short, long) -> loaded via runtime localization
	// ### VALUES ###
	// * Format -> when rendering (incl. converters e.g. %, currencies, and other units such as weight, distance, volumes...)  
	// * Validator -> when editing (e.g postal code, phone numbers...)
	//
	// Metadata should :
	// * provide default values and allows local customization
	// * be centralized and be compatible with both dynamic and static objects (mx.Object vs persistent objects)
	// * take into account user preferences (language, preferred currencies, measures and units)
	// * allows customization at application/view level (mxml)
	// 
	// Overall API should:
	// * provide default components such as Grid, List, Form supporting metadata for most common CRUD applications
	// * not take care of customization
	// * take care of only providing metadata support for any dataset
	// 
	// Example of usage:
	// l('label_user_new') or separate per view??? in flex, not so many views
	// OR label('user_new') or labels.user_new using Proxy implementation
	// OR l(field_user_firstname)
	// 
	// type of localization/dictionnary:
	// * labels: 
	//           label_user: User
	//           label_user_new: New User
	//           label_user_plural: Users 
	// * buttons: 
	//           button_save: Save
	//           button_cancel: Cancel
	// * error_.., notice_.., field_.., ...
	//
	// Formatting and Validation should be definitely together what about localization? 
	// If only one language would be nice to use existing data support metadata Attribute by 
	// adding fields like: 
	//
	// and I don't want to force people if they use their own localization!
	//
	// [Field(name="firstName", format="", validators="")]
	// public class User { }
	// 
	// [Field(name="id", format="...")]
	// [Field(name="label", format="...")]
	// [Field(name="custom", format="5*5"]   could use this for simple calculation on other fields 
	// private var languages:Array = [
	// {id: 'fr_FR', label: 'Francais'},
	// {id: 'en_US', label: 'English (US)'},
	// ];
	//
	// Localization will be as follows:
	// l("User.firstName")
	// l("Language.id")
	// 
	// localization: 
	// formatting settings:
	// * default per locale too
	// * DATE, TIME, DATETIME, PERCENTAGE,  ... custom using REGEXP
	// custom impl via format(item:Object, field:String):String lookups metadata database
	// defaults provided for date, bool, string... time, datetime, 
	// custom implementations need to be registered with string for instance registerFormat(type:Class, function:Function):Boolean
	// 
	// same for validators, date time, percentage,...
	// On the ActionScript, I want to use metadata declaration on persistent fields or class, e.g.
	// [Field(name="firstname", format="String", valid="...")]
	// [Field(name="creation_date", format="DateTime", formatString="", valid="...")]
	// [Field(name="address.zipcode", format="", valid="")]
	public class MetaDataSupport
	{
		private static var _singleton:MetaDataSupport = new MetaDataSupport();
		
		function MetaDataSupport() {
			if (_singleton)
				throw new Error("This class is a singleton! call instead .getInstance()");			
		}
		
		public static function getInstance():MetaDataSupport {
			return _singleton;
		}
		
		public function registerFormatter(uid:String, formatter:Formatter):void {
			
		}
		
		public function format(item:Object, field:String):String {
			
			return null;
		}
		
		public function validate(item:Object, field:String):Boolean {
			return false;
		}
		
		public function registerValidator(uid:String, validator:Validator):void {			
		}
	}
}