package extension.icloud;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

class ICloud
{

	static var initialized = false;

	public static dynamic function onChange(reason:KeyValueStoreChangeReason, keys:Array<String>)
	{

	}

	public static function getFloat(key:String):Float
	{
		#if ios
		return icloud_get_float_for_key(key);
		#else
		return 0.0;
		#end
	}

	public static function setFloat(key:String, value:Float)
	{
		#if ios
		icloud_set_float_for_key(key, value);
		#end
	}

	public static function getInt(key:String):Int
	{
		#if ios
		return icloud_get_int_for_key(key);
		#else
		return 0;
		#end
	}

	public static function setInt(key:String, value:Int)
	{
		#if ios
		icloud_set_int_for_key(key, value);
		#end
	}

	public static function getString(key:String):String
	{
		#if ios
		return icloud_get_string_for_key(key);
		#else
		return null;
		#end
	}

	public static function setString(key:String, value:String)
	{
		#if ios
		icloud_set_string_for_key(key, value);
		#end
	}

	static function initialize()
	{
		if (initialized)
		{
			return;
		}

		initialized = true;

		#if ios
		icloud_set_notification_handle(handleNotification);
		#end
	}

	static function handleNotification(reason:Int, changed:Array<String>)
	{
		onChange(Type.createEnumIndex(KeyValueStoreChangeReason, reason), changed);
	}

	public static function synchronize()
	{
		initialize();

		#if ios
		icloud_synchronize();
		#end
	}

	#if ios
	private static var icloud_get_float_for_key = Lib.load("icloud", "icloud_get_float_for_key", 1);
	private static var icloud_set_float_for_key = Lib.load("icloud", "icloud_set_float_for_key", 2);
	private static var icloud_get_int_for_key = Lib.load("icloud", "icloud_get_int_for_key", 1);
	private static var icloud_set_int_for_key = Lib.load("icloud", "icloud_set_int_for_key", 2);
	private static var icloud_get_string_for_key = Lib.load("icloud", "icloud_get_string_for_key", 1);
	private static var icloud_set_string_for_key = Lib.load("icloud", "icloud_set_string_for_key", 2);
	private static var icloud_synchronize = Lib.load("icloud", "icloud_synchronize", 0);
	private static var icloud_set_notification_handle = Lib.load("icloud", "icloud_set_notification_handle", 1);
	#end

}

enum KeyValueStoreChangeReason
{
	ServerChange;
	InitialSyncChange;
	QuotaViolationChange;
	AccountChange;
}
