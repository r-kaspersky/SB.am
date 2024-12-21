SB_AM = SB_AM or {}
SB_AM.Commands = SB_AM.Commands or {}

SB_AM.Commands.goto = {
    Description = "Телепортироваться к игроку",
    ShowPlayerList = true,
    Callback = function(ply, args)
        if not IsValid(ply) then
            SB_AM.Log("Серьезно? Консоль телепортируется к игроку? Ну ты и рофлан.", "error", ply)
            return
        end

        if not SB_AM.Ranks.HasPermission(ply, "goto") then
            SB_AM.Log("У вас нет прав на использование этой команды", "error", ply)
            return
        end

        if not args[1] then
            SB_AM.Log("Укажите игрока", "error", ply)
            return
        end

        local target = nil
        if string.match(args[1], "STEAM_%d:%d:%d+") then
            for _, player in ipairs(player.GetAll()) do
                if player:SteamID() == args[1] then
                    target = player
                    break
                end
            end
        end
        
        if not target then
            for _, player in ipairs(player.GetAll()) do
                if string.find(string.lower(player:Nick()), string.lower(args[1])) then
                    target = player
                    break
                end
            end
        end

        if not target then
            SB_AM.Log("Игрок не найден", "error", ply)
            return
        end

        if target == ply then
            SB_AM.Log("Вы не можете телепортироваться к самому себе", "error", ply)
            return
        end

        local targetPos = target:GetPos()
        local targetAngles = target:EyeAngles()

        hook.Run("PrePlayerTeleport", ply)

        local offset = targetAngles:Forward() * -100
        local teleportPos = targetPos + offset
        
        -- Телепортация
        ply:SetPos(teleportPos)
        ply:SetEyeAngles(targetAngles)
        
        ply:EmitSound("ambient/machines/teleport" .. math.random(1, 4) .. ".wav")
        
        SB_AM.Log(ply:Nick() .. " телепортировался к " .. target:Nick() .. " ( " .. target:SteamID() .. ")", "info")
    end
}

return SB_AM.Commands.goto
