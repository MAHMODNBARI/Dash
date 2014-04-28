/**
*   Defines utility functions for strings
*/
module utility.string;

import std.array, std.traits;

/// fromStringz
/**
 * Returns new string formed from C-style (null-terminated) string $(D msg). Usefull
 * when interfacing with C libraries. For D-style to C-style convertion use std.string.toStringz.
 *
 * Params:
 *  msg =                 The C string to convert.
 *
 * Authors: NCrashed
 */
string fromStringz(const char* msg) nothrow
{
    scope(failure) return "";
    if( msg is null ) return "";

    auto buff = appender!(char[]);
    uint i = 0;
    while( msg[i] != cast(char)0 )
    {
        buff.put(msg[i++]);
    }

    return buff.data.idup;
}
/// Example
unittest
{
    char[] cstring = "some string".dup ~ cast(char)0;

    assert(cstring.ptr.fromStringz == "some string");
    assert(null.fromStringz == "");
}

/**
 * Replaces each key in replaceMap with it's value.
 *
 * Params:
 *  base =              The string to replace on.
 *  replaceMap =        The map to use to replace things.
 *
 * Returns: The updated string.
 */
T replaceMap( T, TKey, TValue )( T base, TKey[TValue] replaceMap ) if( isSomeString!T && isSomeString!TKey && isSomeString!TValue )
{
    auto result = base;

    foreach( key, value; replaceMap )
    {
        result = result.replace( key, value );
    }

    return result;
}
