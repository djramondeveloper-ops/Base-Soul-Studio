-- Callback para criar uma nova playlist de música
BaseCallback("music:createPlaylist", function(source, phoneNumber, playlistName)
    -- Insere a nova playlist no banco de dados
    local playlistId = MySQL.insert.await(
        "INSERT INTO phone_music_playlists (`name`, phone_number) VALUES (?, ?)",
        {
            playlistName,
            phoneNumber
        }
    )
    
    -- Verifica se a inserção foi bem-sucedida
    if not playlistId then
        return false
    end
    
    -- Adiciona a playlist às playlists salvas do usuário (auto-favorita sua própria playlist)
    MySQL.update.await(
        "INSERT INTO phone_music_saved_playlists (playlist_id, phone_number) VALUES (?, ?)",
        {
            playlistId,
            phoneNumber
        }
    )
    
    -- Retorna o ID da playlist criada
    return playlistId
end)
-- Callback para editar uma playlist existente (nome e capa)
BaseCallback("music:editPlaylist", function(source, phoneNumber, playlistId, newName, newCover)
    -- Atualiza o nome e capa da playlist, verificando se pertence ao usuário
    local rowsAffected = MySQL.update.await(
        "UPDATE phone_music_playlists SET `name` = ?, cover = ? WHERE id = ? AND phone_number = ?",
        {
            newName,
            newCover,
            playlistId,
            phoneNumber
        }
    )
    
    -- Retorna true se alguma linha foi afetada (playlist foi atualizada)
    return rowsAffected > 0
end)
-- Callback para obter todas as playlists salvas do usuário com suas músicas
BaseCallback("music:getPlaylists", function(source, phoneNumber)
    -- Consulta complexa que obtém playlists e suas músicas através de JOINs
    return MySQL.query.await([[ SELECT  s.song_id,  p.id,  p.`name`,  p.cover,  p.phone_number FROM  phone_music_playlists p LEFT JOIN  phone_music_saved_playlists p2 ON p2.playlist_id = p.id LEFT JOIN  phone_music_songs s ON s.playlist_id = p.id WHERE  p2.phone_number = ? ORDER BY  p.`name` ASC ]], { phoneNumber })
end)
-- Callback para deletar uma playlist (apenas o proprietário pode deletar)
BaseCallback("music:deletePlaylist", function(source, phoneNumber, playlistId)
    -- Remove a playlist, verificando se pertence ao usuário
    local rowsAffected = MySQL.update.await(
        "DELETE FROM phone_music_playlists WHERE id = ? AND phone_number = ?",
        {
            playlistId,
            phoneNumber
        }
    )
    
    -- Retorna true se alguma linha foi afetada (playlist foi deletada)
    -- Nota: As tabelas relacionadas (saved_playlists, songs) devem ser limpas por CASCADE ou triggers
    return rowsAffected > 0
end)
-- Callback para salvar/favoritar uma playlist (adicionar à biblioteca pessoal)
BaseCallback("music:savePlaylist", function(source, phoneNumber, playlistId)
    -- Adiciona a playlist às playlists salvas do usuário
    -- ON DUPLICATE KEY previne erro se já estiver salva
    local rowsAffected = MySQL.update.await(
        "INSERT INTO phone_music_saved_playlists (playlist_id, phone_number) VALUES (?, ?) ON DUPLICATE KEY UPDATE phone_number = phone_number",
        {
            playlistId,
            phoneNumber
        }
    )
    
    -- Retorna true se alguma linha foi afetada (playlist foi salva)
    return rowsAffected > 0
end)
-- Callback para adicionar uma música a uma playlist
BaseCallback("music:addSong", function(source, phoneNumber, playlistId, songId)
    -- Verifica se a playlist pertence ao usuário antes de adicionar a música
    local ownsPlaylist = MySQL.scalar.await(
        "SELECT 1 FROM phone_music_playlists WHERE id = ? AND phone_number = ?",
        {
            playlistId,
            phoneNumber
        }
    )
    
    -- Se o usuário não é dono da playlist, não pode adicionar músicas
    if not ownsPlaylist then
        return false
    end
    
    -- Adiciona a música à playlist
    -- ON DUPLICATE KEY previne erro se a música já estiver na playlist
    local rowsAffected = MySQL.update.await(
        "INSERT INTO phone_music_songs (playlist_id, song_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE song_id = song_id",
        {
            playlistId,
            songId
        }
    )
    
    -- Retorna true se alguma linha foi afetada (música foi adicionada)
    return rowsAffected > 0
end)
-- Callback para remover uma música de uma playlist
BaseCallback("music:removeSong", function(source, phoneNumber, playlistId, songId)
    -- Verifica se a playlist pertence ao usuário antes de remover a música
    local ownsPlaylist = MySQL.scalar.await(
        "SELECT 1 FROM phone_music_playlists WHERE id = ? AND phone_number = ?",
        {
            playlistId,
            phoneNumber
        }
    )
    
    -- Se o usuário não é dono da playlist, não pode remover músicas
    if not ownsPlaylist then
        return false
    end
    
    -- Remove a música da playlist
    local rowsAffected = MySQL.update.await(
        "DELETE FROM phone_music_songs WHERE playlist_id = ? AND song_id = ?",
        {
            playlistId,
            songId
        }
    )
    
    -- Retorna true se alguma linha foi afetada (música foi removida)
    return rowsAffected > 0
end)
