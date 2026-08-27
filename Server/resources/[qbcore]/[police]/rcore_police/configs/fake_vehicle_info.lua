-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



RandomNames = {
    "John Diaz",
    "Mike Falcone",
    "Victor Rizzo",
    "Lana Moreno",
    "Tony Moretti",
    "Jake DeLuca",
    "Mia Santoro",
    "Vince Marino",
    "Sal Romano",
    "Carmen Russo",
    "Rico Martinez",
    "Bella Vega",
    "Tommy Rossi",
    "Alana Garcia",
    "Danny Sanchez",
    "Gia Ferraro",
    "Leo Gallo",
    "Sofia Morales",
    "Marco Varela",
    "Elena Cortez",
    "Jimmy Valenti",
    "Ava Torres",
    "Dominic Bianchi",
    "Roxie Navarro",
    "Luca Esposito",
    "Frankie Lombardi",
    "Nina Rivera",
    "Eddie Palumbo",
    "Johnny Castello",
    "Maria Ferrari",
    "Angelo Serrano",
    "Lola Marino",
    "Max Lombardi",
    "Carmen Alvarez",
    "Ray Castellano",
    "Olivia Rios",
    "Diego Montoya",
    "Alex Cruz",
    "Victor Morales",
    "Bella Sanchez",
    "Tony Leone",
    "Jake Mendoza",
    "Sofia Castillo",
    "Tommy Delgado",
    "Rico Gomez",
    "Vince Romano",
    "Marco Ortiz",
    "Elena Lopez",
    "Lana Torres",
    "Danny Fernandez",
    "Salvatore Silva",
    "Mia Sanchez",
    "Luca Serrano",
    "Roxie Montoya",
    "Angelo Russo",
    "Nico Ventura",
    "Leo Romero",
    "Nina Vance",
    "Johnny Caruso",
    "Bella Vargas",
    "Eddie Morales",
    "Maria Navarro",
    "Jake DeMarco",
    "Tommy Salazar",
    "Alex Cruz",
    "Frankie Diaz",
    "Ava Lopez",
    "Dominic Ferrari",
    "Elena Marino",
    "Tony Roselli",
    "Lola Martinez",
    "Danny Capello",
    "Victor Marino",
    "Mia Alvarez",
    "Nico Morales",
    "Johnny Varela",
    "Olivia Russo",
    "Vince Gallo",
    "Jake Garcia",
    "Rico DeLuca",
    "Marco Rivera",
    "Sofia Perez",
    "Carmen Navarro",
    "Leo Romero",
    "Jimmy Valdez",
    "Bella Sanchez",
    "Tommy Ortiz",
    "Elena Bianchi",
    "Lana Rodriguez",
    "Frankie Salazar",
    "Maria Mendoza",
    "Victor Esposito",
    "Jake Romero",
    "Mia Russo",
    "Eddie Morales",
    "Luca Valenti",
    "Ava Gonzalez",
    "Dominic Vega",
    "Rico Castillo",
    "Lana Garcia",
    "Tony DeMarco",
    "Sofia Martinez",
    "Johnny Serrano"
}
function generateFakeIdentifier()
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    local identifier = ''
    for i = 1, 11 do
        local randomIndex = math.random(1, #chars)
        identifier = identifier .. chars:sub(randomIndex, randomIndex)
    end
    return identifier
end
function generateFakePhoneNumber()
    local digits = '0123456789'
    local phoneNumber = ''
    for i = 1, 9 do
        local randomIndex = math.random(1, #digits)
        phoneNumber = phoneNumber .. digits:sub(randomIndex, randomIndex)
    end
    return phoneNumber
end
