Josh = Josh or {}
Josh.DB = {}

function Josh.DB.GetIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    local wanted = Josh.Config.IdentifierType .. ':'

    for _, identifier in ipairs(identifiers) do
        if identifier:sub(1, #wanted) == wanted then
            return identifier
        end
    end

    return identifiers[1]
end

function Josh.DB.Decode(value, fallback)
    if not value or value == '' then return fallback end
    local ok, result = pcall(json.decode, value)
    if ok and result ~= nil then return result end
    return fallback
end

function Josh.DB.Encode(value)
    return json.encode(value or {})
end
