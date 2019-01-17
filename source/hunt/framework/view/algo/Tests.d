/*
 * Hunt - A high-level D Programming Language Web framework that encourages rapid development and clean, pragmatic design.
 *
 * Copyright (C) 2015-2019, HuntLabs
 *
 * Website: https://www.huntlabs.net/
 *
 * Licensed under the Apache-2.0 License.
 *
 */

module hunt.framework.view.algo.Tests;

private
{
    import hunt.framework.view.algo.Wrapper;
    import hunt.framework.view.Uninode;
}


Function[string] globalTests()
{
    return cast(immutable)
        [
            "defined":   wrapper!defined,
            "undefined": wrapper!undefined,
            "number":    wrapper!number,
            "list":      wrapper!list,
            "dict":      wrapper!dict,
        ];
}


bool defined(UniNode value)
{
    return value.kind != UniNode.Kind.nil;
}


bool undefined(UniNode value)
{
    return value.kind == UniNode.Kind.nil;
}


bool number(UniNode value)
{
    return value.isNumericNode;
}


bool list(UniNode value)
{
    return value.kind == UniNode.Kind.array;
}


bool dict(UniNode value)
{
    return value.kind == UniNode.Kind.object;
}
