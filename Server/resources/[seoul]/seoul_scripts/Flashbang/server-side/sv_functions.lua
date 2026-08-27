if SeoulScriptsServer and not SeoulScriptsServer.Enabled('Flashbang') then return end

function CanDetonateFlashbang(source)
    return SeoulScriptsServer.Passport(source) ~= nil
end

function PunishPlayer(source, reason)
    if SeoulScripts and SeoulScripts.Debug then
        print(('[Seoul Scripts][Flashbang] jogador %s inválido: %s'):format(source, reason or 'sem motivo'))
    end
end
