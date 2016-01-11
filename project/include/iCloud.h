#ifndef ICLOUD_H
#define ICLOUD_H

namespace icloud
{

	double get_double_for_key(const char* key);
	void set_double_for_key(const char* key, double value);
	long long get_longlong_for_key(const char* key);
	void set_longlong_for_key(const char* key, long long value);
	const char* get_string_for_key(const char* key);
	void set_string_for_key(const char* key, const char* value);
	void initialize();
	void synchronize();

}

#endif
