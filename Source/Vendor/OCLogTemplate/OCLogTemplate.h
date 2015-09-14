/**
 * For Objective-C code, this library adds flexible, non-intrusive logging capabilities
 * that can be efficiently enabled or disabled via compile switches.
 *
 * There are four levels of logging: Trace, Info, Error and Debug, and each can be enabled
 * independently via the LOGGING_LEVEL_TRACE, LOGGING_LEVEL_INFO, LOGGING_LEVEL_ERROR and
 * LOGGING_LEVEL_DEBUG switches, respectively.
 *
 * In addition, ALL logging can be enabled or disabled via the LOGGING_ENABLED switch.
 *
 * Logging functions are implemented here via macros. Disabling logging, either entirely, or
 * at a specific level, completely removes the corresponding log invocations from the compiled
 * code, thus eliminating both the memory and CPU overhead that the logging calls would add.
 * You might choose, for example, to completely remove all logging from production release code,
 * by setting LOGGING_ENABLED off in your production builds settings. Or, as another example,
 * you might choose to include Error logging in your production builds by turning only
 * LOGGING_ENABLED and LOGGING_LEVEL_ERROR on, and turning the others off.
 *
 * To perform logging, use any of the following function calls in your code:
 *
 *		LogTrace(fmt, ...)	- recommended for detailed tracing of program flow
 *							- will print if LOGGING_LEVEL_TRACE is set on.
 *
 *		LogInfo(fmt, ...)	- recommended for general, infrequent, information messages
 *							- will print if LOGGING_LEVEL_INFO is set on.
 *
 *		LogError(fmt, ...)	- recommended for use only when there is an error to be logged
 *							- will print if LOGGING_LEVEL_ERROR is set on.
 *
 *		LogDebug(fmt, ...)	- recommended for temporary use during debugging
 *							- will print if LOGGING_LEVEL_DEBUG is set on.
 *
 * In each case, the functions follow the general NSLog/printf template, where the first argument
 * "fmt" is an NSString that optionally includes embedded Format Specifiers, and subsequent optional
 * arguments indicate data to be formatted and inserted into the string. As with NSLog, the number
 * of optional arguments must match the number of embedded Format Specifiers. For more info, see the
 * core documentation for NSLog and String Format Specifiers.
 *
 * You can choose to have each logging entry automatically include class, method and line information
 * by enabling the LOGGING_INCLUDE_CODE_LOCATION switch.
 *
 * Although you can directly edit this file to turn on or off the switches below, the preferred
 * technique is to set these switches via the compiler build setting GCC_PREPROCESSOR_DEFINITIONS
 * in your build configuration.
 */

/**
 * Set this switch to  enable or disable logging capabilities.
 * This can be set either here or via the compiler build setting GCC_PREPROCESSOR_DEFINITIONS
 * in your build configuration. Using the compiler build setting is preferred for this to
 * ensure that logging is not accidentally left enabled by accident in release builds.
 */
#ifndef LOGGING_ENABLED
#	define LOGGING_ENABLED		1
#endif

/**
 * Set any or all of these switches to enable or disable logging at specific levels.
 * These can be set either here or as a compiler build settings.
 * For these settings to be effective, LOGGING_ENABLED must also be defined and non-zero.
 */
#ifndef LOGGING_LEVEL_TRACE
#	define LOGGING_LEVEL_TRACE		0
#endif
#ifndef LOGGING_LEVEL_INFO
#	define LOGGING_LEVEL_INFO		1
#endif
#ifndef LOGGING_LEVEL_ERROR
#	define LOGGING_LEVEL_ERROR		1
#endif
#ifndef LOGGING_LEVEL_DEBUG
#	define LOGGING_LEVEL_DEBUG		1
#endif

/**
 * Set this switch to indicate whether or not to include class, method and line information
 * in the log entries. This can be set either here or as a compiler build setting.
 */
#ifndef LOGGING_INCLUDE_CODE_LOCATION
#define LOGGING_INCLUDE_CODE_LOCATION	1
#endif

// *********** END OF USER SETTINGS  - Do not change anything below this line ***********


#if !(defined(LOGGING_ENABLED) && LOGGING_ENABLED)
#undef LOGGING_LEVEL_TRACE
#undef LOGGING_LEVEL_INFO
#undef LOGGING_LEVEL_ERROR
#undef LOGGING_LEVEL_DEBUG
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-zero-variadic-macro-arguments"

// Logging format
#define LOG_FORMAT_NO_LOCATION(fmt, lvl, ...) NSLog((@"[%@] " fmt), lvl, ##__VA_ARGS__)
#define LOG_FORMAT_WITH_LOCATION(fmt, lvl, ...) NSLog((@"%s[Line %d] [%@] " fmt), __PRETTY_FUNCTION__, __LINE__, lvl, ##__VA_ARGS__)

#if defined(LOGGING_INCLUDE_CODE_LOCATION) && LOGGING_INCLUDE_CODE_LOCATION
#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_WITH_LOCATION(fmt, lvl, ##__VA_ARGS__)
#else
#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_NO_LOCATION(fmt, lvl, ##__VA_ARGS__)
#endif

// Trace logging - for detailed tracing
#if defined(LOGGING_LEVEL_TRACE) && LOGGING_LEVEL_TRACE
#define LogTrace(fmt, ...) LOG_FORMAT(fmt, @"trace", ##__VA_ARGS__)
#else
#define LogTrace(...)
#endif

// Info logging - for general, non-performance affecting information messages
#if defined(LOGGING_LEVEL_INFO) && LOGGING_LEVEL_INFO
#define LogInfo(fmt, ...) LOG_FORMAT(fmt, @"info", ##__VA_ARGS__)
#else
#define LogInfo(...)
#endif

// Error logging - only when there is an error to be logged
#if defined(LOGGING_LEVEL_ERROR) && LOGGING_LEVEL_ERROR
#define LogError(fmt, ...) LOG_FORMAT(fmt, @"***ERROR***", ##__VA_ARGS__)
#else
#define LogError(...)
#endif

// Debug logging - use only temporarily for highlighting and tracking down problems
#if defined(LOGGING_LEVEL_DEBUG) && LOGGING_LEVEL_DEBUG
#define LogDebug(fmt, ...) LOG_FORMAT(fmt, @"DEBUG", ##__VA_ARGS__)
#else
#define LogDebug(...)
#endif

#pragma clang diagnostic pop
