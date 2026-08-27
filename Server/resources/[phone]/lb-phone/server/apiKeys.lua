-- Configure credenciais próprias da cidade antes de liberar uploads e logs.
-- Credenciais herdadas de outra base foram removidas durante a adaptação.

INSTAPIC_WEBHOOK = false
BIRDY_WEBHOOK = false

LOGS = {
    Default = false,
    Calls = false,
    Messages = false,
    InstaPic = false,
    Birdy = false,
    YellowPages = false,
    Marketplace = false,
    Mail = false,
    Wallet = false,
    DarkChat = false,
    Services = false,
    Crypto = false,
    Trendy = false,
    Uploads = false
}

DISCORD_TOKEN = nil

API_KEYS = {
    Video = "RhVQGIPOuKoJVrUx1ZPDKZfxzYFNY6ra",
    Image = "Utq1gpTIE0BQc882n8fl28bcRXV5bk5C",
    Audio = "9xRQa7egCsacezagg6O1yqr6EwfmB3NH"
}

WEBRTC = {
    TokenID = nil,
    APIToken = nil
}
