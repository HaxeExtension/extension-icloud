#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include <hxcpp.h>
#include "iCloud.h"

using namespace icloud;

AutoGCRoot* icloud_notification_handle = 0;

static value icloud_get_float_for_key(value key)
{
	#ifdef IPHONE
	return alloc_float(get_double_for_key(val_string(key)));
	#endif
	return alloc_float(0.0);
}
DEFINE_PRIM(icloud_get_float_for_key, 1);

static value icloud_set_float_for_key(value key, value number)
{
	#ifdef IPHONE
	set_double_for_key(val_string(key), val_float(number));
	#endif
	return alloc_null();
}
DEFINE_PRIM(icloud_set_float_for_key, 2);

static value icloud_get_int_for_key(value key)
{
	#ifdef IPHONE
	return alloc_int(get_longlong_for_key(val_string(key)));
	#endif
	return alloc_int(0);
}
DEFINE_PRIM(icloud_get_int_for_key, 1);

static value icloud_set_int_for_key(value key, value number)
{
	#ifdef IPHONE
	set_longlong_for_key(val_string(key), val_int(number));
	#endif
	return alloc_null();
}
DEFINE_PRIM(icloud_set_int_for_key, 2);

static value icloud_get_string_for_key(value key)
{
	#ifdef IPHONE
	const char* string = get_string_for_key(val_string(key));

	if (string != NULL)
	{
		return alloc_string(string);
	}
	#endif

	return alloc_null();
}
DEFINE_PRIM(icloud_get_string_for_key, 1);

static value icloud_set_string_for_key(value key, value string)
{
	#ifdef IPHONE
	set_string_for_key(val_string(key), val_string(string));
	#endif
	return alloc_null();
}
DEFINE_PRIM(icloud_set_string_for_key, 2);

static value icloud_delete_key(value key)
{
	#ifdef IPHONE
	delete_key(val_string(key));
	#endif
	return alloc_null();
}
DEFINE_PRIM(icloud_delete_key, 1);

static value icloud_set_notification_handle(value handle)
{
	#ifdef IPHONE
	icloud_notification_handle = new AutoGCRoot(handle);
	initialize();
	#endif
	return alloc_null();
}
DEFINE_PRIM(icloud_set_notification_handle, 1);

static value icloud_synchronize()
{
	#ifdef IPHONE
	synchronize();
	#endif
	return alloc_null();
}
DEFINE_PRIM(icloud_synchronize, 0);

extern "C" void icloud_main ()
{
	val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT(icloud_main);

extern "C" int icloud_register_prims() { return 0; }

extern "C" void send_icloud_notification(int reason, const char** keys, int length)
{
    value array = alloc_array(length);

	for (int index = 0; index < length; index++)
	{
		val_array_set_i(array, index, alloc_string(keys[index]));
	}

    val_call2(icloud_notification_handle->get(), alloc_int(reason), array);
}
