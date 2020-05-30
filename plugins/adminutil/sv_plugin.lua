PLUGIN.origReceive = PLUGIN.origReceive or net.Receive
PLUGIN.exploits = {
    ["npctool_relman_up"] = true, 
    ["npctool_spawner_clearundo"] = false, 
    ["sv_npctool_spawner_ppoint"] = false 
    --["wire_expression2_request_file"] = false, 
    --["wire_adv_upload"] = false, 
    --["wire_expression2_request_list"] = false, 
    --["wire_adv_unwire"] = false, 
    --["wire_expression2_client_request_set_extension_status"] = false
}

ix.log.AddType("exploit", function(client, netmsgname)
    return Format("[EXPLOIT DETECTED] %s (%s) (%s) (%s)", client:Name(), client:SteamID(), client:IPAddress(), netmsgname)
end)

function PLUGIN:WarnExploits(ply, exploitName)
    if not exploitName or not isstring(exploitName) then exploitName = "" end

    ply.nextExploitNotify = ply.nextExploitNotify or 0
    if ply.nextExploitNotify > CurTime() then
        return
    end

    ply.nextExploitNotify = CurTime() + 2
    
    for _, p in ipairs(player.GetAll()) do
        if p:IsAdmin() then
            p:Notify(ply:Name() .. " (" .. ply:SteamID() .. 
            (
                v and ") may be attempting to crash the server!"
                or ") may be attempting to run exploits!"
            ))
        end
    end

    ix.log.Add(ply, "exploit", exploitName)
end

for k, v in pairs(PLUGIN.exploits) do
    net.Receive(k, function(len, ply)
        PLUGIN:WarnExploits(ply, k)
    end)
end

hook.Remove("Think", "ThrowingGrenade")