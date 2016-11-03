#include <Foundation/Foundation.h>

extern "C" void send_icloud_notification(int reason, const char** keys, int length);

namespace icloud
{

	static int initialized = 0;

	double get_double_for_key(const char* key)
	{
		NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];

		return [store doubleForKey:[NSString stringWithUTF8String:key]];
	}

	void set_double_for_key(const char* key, double value)
	{
		NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];

		[store setDouble:value forKey:[NSString stringWithUTF8String:key]];
	}

	long long get_longlong_for_key(const char* key)
	{
		NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];

		return [store longLongForKey:[NSString stringWithUTF8String:key]];
	}

	void set_longlong_for_key(const char* key, long long value)
	{
		NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];

		[store setLongLong:value forKey:[NSString stringWithUTF8String:key]];
	}

	const char* get_string_for_key(const char* key)
	{
		NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
		NSString *value = [store stringForKey:[NSString stringWithUTF8String:key]];

		if (value == nil)
		{
			return nil;
		}
		else
		{
			return [value UTF8String];
		}
	}

	void set_string_for_key(const char* key, const char* value)
	{
		NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];

		[store setString:[NSString stringWithUTF8String:value] forKey:[NSString stringWithUTF8String:key]];
	}

	void delete_key(const char* key)
	{
		NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];

		[store removeObjectForKey:[NSString stringWithUTF8String:key]];
	}

	void initialize()
	{
		if (initialized == 1)
		{
			return;
		}

		[[NSNotificationCenter defaultCenter]
			addObserverForName: @"NSUbiquitousKeyValueStoreDidChangeExternallyNotification"
			object: nil
			queue: [NSOperationQueue mainQueue]
			usingBlock: ^(NSNotification* notification)
			{
				NSNumber* reason = [notification.userInfo objectForKey:@"NSUbiquitousKeyValueStoreServerChange"];
				NSArray* changed = [notification.userInfo objectForKey:@"NSUbiquitousKeyValueStoreChangedKeysKey"];

				int count = [changed count];
				const char** keys = (const char**)malloc(sizeof(const char*) * count);

				for (int index = 0; index < count; index++)
				{
					keys[index] = [[changed objectAtIndex:index] UTF8String];
				}

				send_icloud_notification([reason intValue], keys, count);

				free(keys);
			}];
	}

	void synchronize()
	{
		[[NSUbiquitousKeyValueStore defaultStore] synchronize];
	}

}
