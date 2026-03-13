Josh = Josh or {}
Josh.Callbacks = Josh.Callbacks or {}

if IsDuplicityVersion() then
    function Josh.CreateCallback(name, cb)
        Josh.Callbacks[name] = cb
    end
else
    function Josh.TriggerCallback(name, cb, ...)
        lib.callback(name, false, cb, ...)
    end
end
