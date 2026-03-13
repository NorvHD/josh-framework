Josh = Josh or {}
Josh.Utils = {}

function Josh.Utils.Debug(...)
    if not Josh.Config.Debug then return end
    print(('^3[%s DEBUG]^7 %s'):format(Josh.Config.FrameworkName or 'JOSH', table.concat({...}, ' ')))
end

function Josh.Utils.DeepCopy(tbl)
    if type(tbl) ~= 'table' then return tbl end
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = Josh.Utils.DeepCopy(v)
    end
    return copy
end

function Josh.Utils.TableMerge(base, extra)
    local out = Josh.Utils.DeepCopy(base)
    for k, v in pairs(extra or {}) do
        if type(v) == 'table' and type(out[k]) == 'table' then
            out[k] = Josh.Utils.TableMerge(out[k], v)
        else
            out[k] = v
        end
    end
    return out
end

function Josh.Utils.Notify(src, data)
    if IsDuplicityVersion() then
        TriggerClientEvent('josh:client:notify', src, data)
        return
    end

    lib.notify(data)
end
