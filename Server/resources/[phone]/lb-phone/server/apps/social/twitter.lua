-- ================================================================
-- LB Phone - Twitter Server Handler  
-- Manages Twitter/Birdy posts, likes, follows, and social interactions
-- Handles database operations, user authentication, and API callbacks
-- ================================================================

-- Get Twitter account for a player source
-- Returns the logged in Twitter account or false if not logged in
function GetTwitterAccount(playerSource)
    local phoneNumber = GetEquippedPhoneNumber(playerSource)
    if not phoneNumber then
        return false
    end
    
    return GetLoggedInAccount(phoneNumber, "Twitter")
end
-- Register a Twitter/Birdy callback with authentication
-- Wraps callback functions to ensure user is logged into Twitter
function RegisterTwitterCallback(callbackName, handlerFunction, defaultResponse, requiresInteraction)
    RegisterCallback("birdy:" .. callbackName, function(source, ...)
        local phoneNumber = GetEquippedPhoneNumber(source)
        if not phoneNumber then
            return defaultResponse
        end
        
        -- Get logged in Twitter account
        local twitterAccount = GetLoggedInAccount(phoneNumber, "Twitter")
        if not twitterAccount then
            return defaultResponse
        end
        
        -- Call the handler function with authenticated data
        return handlerFunction(source, phoneNumber, twitterAccount, ...)
    end, requiresInteraction)
end
-- Send Twitter notification to all logged in users except the sender
-- Used for mentions, likes, follows, etc.
function SendTwitterNotification(username, notificationData, excludePhoneNumber)
    -- Get all phone numbers logged into this Twitter account
    local phoneNumbers = MySQL.query.await(
        "SELECT phone_number FROM phone_logged_in_accounts WHERE username = ? AND app = 'Twitter' AND `active` = 1",
        {username}
    )
    
    -- Set app for notification
    notificationData.app = "Twitter"
    
    -- Send notification to all phones except the sender
    for i = 1, #phoneNumbers do
        local phoneNumber = phoneNumbers[i].phone_number
        if phoneNumber ~= excludePhoneNumber then
            SendNotification(phoneNumber, notificationData)
        end
    end
end
-- Get Twitter profile information for a username
-- Returns profile data with relationship status if phoneNumber provided
function GetTwitterProfile(username, phoneNumber)
    -- Convert username to lowercase for consistency
    username = username:lower()
    
    -- Get basic profile data from database
    local profileData = MySQL.single.await(
        "SELECT `display_name`, `bio`, `profile_image`, `profile_header`, `verified`, `follower_count`, `following_count`, `date_joined`, private FROM `phone_twitter_accounts` WHERE `username`=?",
        {username}
    )
    
    if not profileData then
        return false
    end
    
    -- Initialize relationship status variables
    local isFollowing = false
    local isFollowingYou = false
    local notificationsEnabled = false
    local hasRequested = false
    local pinnedTweet = nil
    
    -- Get viewer's Twitter account if phone number provided
    local viewerAccount = phoneNumber and GetLoggedInAccount(phoneNumber, "Twitter")
    
    if viewerAccount then
        -- Check if viewer is following this profile
        local followResult = MySQL.scalar.await(
            "SELECT `followed` FROM `phone_twitter_follows` WHERE `follower` = ? AND `followed` = ?",
            {viewerAccount, username}
        )
        isFollowing = followResult ~= nil
        
        -- Check if this profile is following the viewer
        local followingBackResult = MySQL.scalar.await(
            "SELECT `followed` FROM `phone_twitter_follows` WHERE `follower` = ? AND `followed` = ?",
            {username, viewerAccount}
        )
        isFollowingYou = followingBackResult ~= nil
        
        -- Check if notifications are enabled for this follow
        local notificationResult = MySQL.scalar.await(
            "SELECT `notifications` FROM `phone_twitter_follows` WHERE `follower` = ? AND `followed` = ?",
            {viewerAccount, username}
        )
        notificationsEnabled = notificationResult == true
        
        -- Check if viewer has pending follow request
        local requestResult = MySQL.scalar.await(
            "SELECT TRUE FROM phone_twitter_follow_requests WHERE requester = ? AND requestee = ?",
            {viewerAccount, username}
        )
        hasRequested = requestResult ~= nil
        
        -- Get pinned tweet if exists
        local pinnedTweetId = MySQL.scalar.await(
            "SELECT pinned_tweet FROM phone_twitter_accounts WHERE username = ?",
            {username}
        )
        
        if pinnedTweetId then
            pinnedTweet = GetTweet(pinnedTweetId, viewerAccount)
        end
    end
    
    -- Build and return profile object
    return {
        name = profileData.display_name,
        username = username,
        followers = profileData.follower_count,
        following = profileData.following_count,
        date_joined = profileData.date_joined,
        bio = profileData.bio,
        verified = profileData.verified,
        private = profileData.private,
        profile_picture = profileData.profile_image,
        header = profileData.profile_header,
        isFollowing = isFollowing,
        isFollowingYou = isFollowingYou,
        notificationsEnabled = notificationsEnabled,
        pinnedTweet = pinnedTweet,
        requested = hasRequested
    }
end
-- Get all phone numbers and sources for a Twitter username
-- Returns a table mapping phone_number -> source for active sessions
function GetTwitterUserPhones(username)
    local phoneToSource = {}
    
    -- Get all phone numbers logged into this Twitter account
    local phoneNumbers = MySQL.Sync.fetchAll(
        "SELECT phone_number FROM phone_logged_in_accounts WHERE username = ? AND app = 'Twitter' AND `active` = 1",
        {username}
    )
    
    -- Map each phone number to its source
    for i = 1, #phoneNumbers do
        local phoneNumber = phoneNumbers[i].phone_number
        local source = GetSourceFromNumber(phoneNumbers[i].phone_number)
        phoneToSource[phoneNumber] = source
    end
    
    return phoneToSource
end
-- Twitter notification types mapping
local NOTIFICATION_TYPES = {
    like = "BACKEND.TWITTER.LIKE",
    retweet = "BACKEND.TWITTER.RETWEET", 
    reply = "BACKEND.TWITTER.REPLY",
    follow = "BACKEND.TWITTER.FOLLOW",
    tweet = "BACKEND.TWITTER.TWEET"
}
-- Send Twitter notification to user  
-- Handles likes, retweets, follows, replies, and tweets
function SendTwitterUserNotification(toUsername, fromUsername, notificationType, tweetId)
    -- Don't send notifications to yourself
    if toUsername == fromUsername then
        return
    end
    
    -- Get notification title from type mapping
    local notificationTitle = NOTIFICATION_TYPES[notificationType]
    if not notificationTitle then
        return
    end
    
    -- Check for duplicate notifications (likes, retweets, follows only)
    if notificationType == "like" or notificationType == "retweet" or notificationType == "follow" then
        local query = "SELECT TRUE FROM phone_twitter_notifications WHERE username=@username AND `from`=@from AND `type`=@type"
        
        -- Add tweet_id condition for non-follow notifications
        if notificationType ~= "follow" then
            query = query .. " AND tweet_id=@tweet_id"
        end
        
        local duplicate = MySQL.Sync.fetchScalar(query, {
            ["@username"] = toUsername,
            ["@from"] = fromUsername,
            ["@type"] = notificationType,
            ["@tweet_id"] = tweetId
        })
        
        -- Don't send duplicate notifications
        if duplicate then
            return
        end
    end
    
    -- Get sender's profile information
    local senderProfile = MySQL.Sync.fetchAll(
        "SELECT display_name, private FROM phone_twitter_accounts WHERE username=@username",
        {["@username"] = fromUsername}
    )[1]
    
    if senderProfile then
        -- Don't send reply notifications from private accounts
        if senderProfile.private and notificationType == "reply" then
            return
        end
    end
    
    -- Generate localized notification title
    local finalTitle = L(notificationTitle, {
        displayName = senderProfile.display_name,
        username = fromUsername
    })
    
    -- Save notification to database
    MySQL.Async.execute(
        "INSERT INTO phone_twitter_notifications (id, username, `from`, `type`, tweet_id) VALUES (@id, @username, @from, @type, @tweetId)",
        {
            ["@id"] = GenerateId("phone_twitter_notifications", "id"),
            ["@username"] = toUsername,
            ["@from"] = fromUsername,
            ["@type"] = notificationType,
            ["@tweetId"] = tweetId
        }
    )
    
    -- Get tweet content and attachments for non-follow notifications
    local attachments = nil
    local content = nil
    
    if notificationType ~= "follow" then
        local tweetData = MySQL.Sync.fetchAll(
            "SELECT content, attachments FROM phone_twitter_tweets WHERE id=@tweetId",
            {["@tweetId"] = tweetId}
        )
        
        if tweetData then
            content = tweetData[1].content
            local attachmentData = tweetData[1].attachments
            
            if attachmentData then
                attachments = json.decode(attachmentData)
            end
        end
    end
    
    -- Send push notification to all user's phones
    local userPhones = GetTwitterUserPhones(toUsername)
    for phoneNumber, source in pairs(userPhones) do
        SendNotification(phoneNumber, {
            app = "Twitter",
            title = finalTitle,
            content = content,
            thumbnail = attachments and attachments[1]
        })
    end
end
-- Callback: Get Twitter notifications
RegisterLegacyCallback("birdy:getNotifications", function(source, callback, data)
    local twitterAccount = GetTwitterAccount(source)
    if not twitterAccount then
        return callback({
            notifications = {},
            requests = 0
        })
    end
    
    -- Get notifications with tweet and account data
    local notifications = MySQL.Sync.fetchAll([[
        SELECT
            -- notification data
            n.`from`, n.`type`, n.tweet_id,
            -- tweet data
            t.username, t.content, t.attachments, t.reply_to, t.like_count,
            t.reply_count, t.retweet_count, t.`timestamp`,

            (
                SELECT TRUE FROM phone_twitter_likes l
                WHERE l.tweet_id=t.id AND l.username=@username
            ) AS liked,
            (
                SELECT TRUE FROM phone_twitter_retweets r
                WHERE r.tweet_id=t.id AND r.username=@username
            ) AS retweeted,

            -- account data
            a.display_name AS `name`, a.profile_image AS profile_picture, a.verified,
            (
                CASE WHEN t.reply_to IS NULL THEN NULL ELSE (SELECT username FROM phone_twitter_tweets WHERE id=t.reply_to LIMIT 1) END
            ) AS replyToAuthor

        FROM phone_twitter_notifications n

        LEFT JOIN phone_twitter_tweets t
            ON n.tweet_id = t.id

        JOIN phone_twitter_accounts a
            ON a.username = n.from

        WHERE n.username=@username

        ORDER BY n.`timestamp` DESC

        LIMIT @page, @perPage
    ]], {
        ["@page"] = data * 15,
        ["@perPage"] = 15,
        ["@username"] = twitterAccount
    })
    
    -- For subsequent pages, only return notifications
    if data > 0 then
        return callback({
            notifications = notifications
        })
    end
    
    -- For first page, also get follow request count
    local requestCount = MySQL.Sync.fetchScalar(
        "SELECT COUNT(1) FROM phone_twitter_follow_requests WHERE requestee=@username",
        {["@username"] = twitterAccount}
    )
    
    callback({
        notifications = notifications,
        requests = requestCount
    })
end)
-- Callback: Create Twitter account
RegisterLegacyCallback("birdy:createAccount", function(source, callback, displayName, username, password)
    local phoneNumber = GetEquippedPhoneNumber(source)
    if not phoneNumber then
        return callback(false)
    end
    
    -- Normalize username to lowercase
    username = username:lower()
    
    -- Validate username format
    if not IsUsernameValid(username) then
        return callback({
            success = false,
            error = "USERNAME_NOT_ALLOWED"
        })
    end
    
    -- Check if username is already taken
    local existingUser = MySQL.Sync.fetchScalar(
        "SELECT TRUE FROM phone_twitter_accounts WHERE username=@username",
        {["@username"] = username}
    )
    
    if existingUser then
        return callback({
            success = false,
            error = "USERNAME_TAKEN"
        })
    end
    
    -- Create new Twitter account
    MySQL.Sync.execute(
        "INSERT INTO phone_twitter_accounts (display_name, username, `password`, phone_number) VALUES (@displayName, @username, @password, @phonenumber)",
        {
            ["@displayName"] = displayName,
            ["@username"] = username,
            ["@password"] = GetPasswordHash(password),
            ["@phonenumber"] = phoneNumber
        }
    )
    
    -- Log user into the new account
    AddLoggedInAccount(phoneNumber, "Twitter", username)
    
    -- Return success
    callback({
        success = true
    })
    
    -- Handle auto-follow if enabled
    if Config.AutoFollow.Enabled and Config.AutoFollow.Birdy.Enabled then
        local autoFollowAccounts = Config.AutoFollow.Birdy.Accounts
        
        for i = 1, #autoFollowAccounts do
            MySQL.update.await(
                "INSERT INTO phone_twitter_follows (followed, follower) VALUES (?, ?)",
                {autoFollowAccounts[i], username}
            )
        end
    end
end, {
    preventSpam = true,
    rateLimit = 4
})
-- Callback: Change Twitter password
RegisterTwitterCallback("changePassword", function(source, phoneNumber, twitterAccount, oldPassword, newPassword)
    -- Check if password change is enabled
    if not Config.ChangePassword.Birdy then
        infoprint("warning", string.format("%s tried to change password on Birdy, but it's not enabled in the config.", source))
        return false
    end
    
    -- Validate new password
    if oldPassword == newPassword or #newPassword < 3 then
        debugprint("same password / too short")
        return false
    end
    
    -- Verify current password
    local currentPasswordHash = MySQL.scalar.await(
        "SELECT password FROM phone_twitter_accounts WHERE username = ?",
        {twitterAccount}
    )
    
    if not currentPasswordHash or not VerifyPasswordHash(oldPassword, currentPasswordHash) then
        return false
    end
    
    -- Update password in database
    local success = MySQL.update.await(
        "UPDATE phone_twitter_accounts SET password = ? WHERE username = ?",
        {GetPasswordHash(newPassword), twitterAccount}
    ) > 0
    
    if not success then
        return false
    end
    
    -- Send logout notification to other sessions
    SendTwitterNotification(twitterAccount, {
        title = L("BACKEND.MISC.LOGGED_OUT_PASSWORD.TITLE"),
        content = L("BACKEND.MISC.LOGGED_OUT_PASSWORD.DESCRIPTION")
    }, phoneNumber)
    
    -- Logout from all other devices
    MySQL.update.await(
        "DELETE FROM phone_logged_in_accounts WHERE username = ? AND app = 'Twitter' AND phone_number != ?",
        {twitterAccount, phoneNumber}
    )
    
    -- Clear cache for other accounts
    ClearActiveAccountsCache("Twitter", twitterAccount, phoneNumber)
    
    -- Log the password change
    Log("Birdy", source, "info", 
        L("BACKEND.LOGS.CHANGED_PASSWORD.TITLE"),
        L("BACKEND.LOGS.CHANGED_PASSWORD.DESCRIPTION", {
            number = phoneNumber,
            username = twitterAccount,
            app = "Birdy"
        })
    )
    
    -- Trigger logout event for clients
    TriggerClientEvent("phone:logoutFromApp", -1, {
        username = twitterAccount,
        app = "twitter",
        reason = "password",
        number = phoneNumber
    })
    
    return true
end, false)

-- Callback: Delete Twitter account
RegisterTwitterCallback("deleteAccount", function(source, phoneNumber, twitterAccount, password)
    -- Check if account deletion is enabled
    if not Config.DeleteAccount.Birdy then
        infoprint("warning", string.format("%s tried to delete their account on Birdy, but it's not enabled in the config.", source))
        return false
    end
    
    -- Verify password before deletion
    local currentPasswordHash = MySQL.scalar.await(
        "SELECT password FROM phone_twitter_accounts WHERE username = ?",
        {twitterAccount}
    )
    
    if not currentPasswordHash or not VerifyPasswordHash(password, currentPasswordHash) then
        return false
    end
    
    -- Delete the Twitter account
    local success = MySQL.update.await(
        "DELETE FROM phone_twitter_accounts WHERE username = ?",
        {twitterAccount}
    ) > 0
    
    if not success then
        return false
    end
    
    -- Send deletion notification to user
    SendTwitterNotification(twitterAccount, {
        title = L("BACKEND.MISC.DELETED_NOTIFICATION.TITLE"),
        content = L("BACKEND.MISC.DELETED_NOTIFICATION.DESCRIPTION")
    })
    
    -- Logout from all sessions
    MySQL.update.await(
        "DELETE FROM phone_logged_in_accounts WHERE username = ? AND app = 'Twitter'",
        {twitterAccount}
    )
    
    -- Clear cache
    ClearActiveAccountsCache("Twitter", twitterAccount)
    
    -- Log the account deletion
    Log("Birdy", source, "info", 
        L("BACKEND.LOGS.DELETED_ACCOUNT.TITLE"),
        L("BACKEND.LOGS.DELETED_ACCOUNT.DESCRIPTION", {
            number = phoneNumber,
            username = twitterAccount,
            app = "Birdy"
        })
    )
    
    -- Trigger logout event for all clients
    TriggerClientEvent("phone:logoutFromApp", -1, {
        username = twitterAccount,
        app = "twitter",
        reason = "deleted"
    })
    
    return true
end, false)

-- Callback: Login to Twitter account
RegisterCallback("birdy:login", function(source, callback, username, password)
    -- Normalize username to lowercase
    username = username:lower()
    
    -- Get stored password hash
    local storedPasswordHash = MySQL.scalar.await(
        "SELECT `password` FROM phone_twitter_accounts WHERE username = ?",
        {username}
    )
    
    if not storedPasswordHash then
        return {
            success = false,
            error = "INVALID_ACCOUNT"
        }
    end
    
    -- Verify password
    if not VerifyPasswordHash(password, storedPasswordHash) then
        return {
            success = false,
            error = "INVALID_PASSWORD"
        }
    end
    
    -- Get phone number for the source
    local phoneNumber = GetEquippedPhoneNumber(source)
    if not phoneNumber then
        return {
            success = false,
            error = "NO_PHONE"
        }
    end
    
    -- Add logged in account
    AddLoggedInAccount(phoneNumber, "Twitter", username)
    
    -- Get profile data
    local profileData = GetTwitterProfile(username)
    if not profileData then
        return {
            success = false,
            error = "INVALID_ACCOUNT"
        }
    end
    
    return {
        success = true,
        data = profileData
    }
end)

-- Callback: Check if user is logged into Twitter
RegisterTwitterCallback("isLoggedIn", function(source, phoneNumber, twitterAccount)
    return GetTwitterProfile(twitterAccount)
end, false)

-- Callback: Get Twitter profile by username
RegisterTwitterCallback("getProfile", function(source, phoneNumber, twitterAccount, targetUsername)
    return GetTwitterProfile(targetUsername, phoneNumber)
end, false)

-- Callback: Pin/unpin a tweet
RegisterLegacyCallback("birdy:pinPost", function(source, callback, tweetId)
    local twitterAccount = GetTwitterAccount(source)
    if not twitterAccount then
        return callback(false)
    end
    
    -- If pinning a tweet, verify ownership
    if tweetId then
        local isOwner = MySQL.scalar.await(
            "SELECT TRUE FROM phone_twitter_tweets WHERE id = ? AND username = ?",
            {tweetId, twitterAccount}
        )
        
        if not isOwner then
            infoprint("warning", string.format("%s (%s) tried to pin a post on birdy that they didn't make.", twitterAccount, source))
            return callback(false)
        end
    end
    
    -- Update pinned tweet (null if unpinning)
    MySQL.Async.execute(
        "UPDATE phone_twitter_accounts SET pinned_tweet=@tweetId WHERE username=@username",
        {
            ["@tweetId"] = tweetId or nil,
            ["@username"] = twitterAccount
        },
        function()
            callback(true)
        end
    )
end)

-- Callback: Sign out from Twitter
RegisterLegacyCallback("birdy:signOut", function(source, callback)
    local phoneNumber = GetEquippedPhoneNumber(source)
    if not phoneNumber then
        return callback(false)
    end
    
    local twitterAccount = GetLoggedInAccount(phoneNumber, "Twitter")
    if not twitterAccount then
        return callback(false)
    end
    
    -- Remove logged in account
    RemoveLoggedInAccount(phoneNumber, "Twitter", twitterAccount)
    
    callback(true)
end)

-- Callback: Update Twitter profile
RegisterLegacyCallback("birdy:updateProfile", function(source, callback, profileData)
    local twitterAccount = GetTwitterAccount(source)
    if not twitterAccount then
        return callback(false)
    end
    
    -- Extract profile data
    local displayName = profileData.name
    local bio = profileData.bio
    local profilePicture = profileData.profile_picture
    local header = profileData.header
    local private = profileData.private
    
    -- Update profile in database
    MySQL.Async.execute(
        "UPDATE phone_twitter_accounts SET display_name=@displayName, bio=@bio, profile_image=@profilePicture, profile_header=@header, private=@private WHERE username=@username",
        {
            ["@username"] = twitterAccount,
            ["@displayName"] = displayName,
            ["@bio"] = bio,
            ["@profilePicture"] = profilePicture,
            ["@header"] = header,
            ["@private"] = private
        },
        function()
            callback(true)
        end
    )
end)

-- Log new Twitter post for audit purposes
function LogTweetPost(tweetId, username, content, attachments, source)
    local attachmentCount = attachments and #attachments or 0
    
    -- Build log message
    local logMessage = "**Username**: " .. username .. "\n\n**Content**: " .. (content or "")
    
    -- Add attachments info if present
    if attachments then
        logMessage = logMessage .. "\n\n**Attachments**:"
        for i = 1, attachmentCount do
            logMessage = logMessage .. "\n\n[Attachment " .. i .. "](" .. attachments[i] .. ")"
        end
    end
    
    -- Add tweet ID
    logMessage = logMessage .. "\n\n**ID**: " .. tweetId
    
    -- Log the post
    Log("Birdy", source, "info", "New post", logMessage)
end

-- Send Twitter post to webhook (Discord integration)
function SendTweetWebhook(tweetId, username, content, isRetweet)
    -- Check if webhook posting is enabled and not a retweet
    if not (Config.Post.Birdy and not isRetweet and BIRDY_WEBHOOK) then
        return
    end
    
    -- Validate webhook URL format
    if BIRDY_WEBHOOK:sub(-14) ~= "/api/webhooks/" then
        return
    end
    
    -- Get user avatar from database
    local userAvatarUrl = MySQL.scalar.await(
        "SELECT profile_image FROM phone_twitter_accounts WHERE username = ?",
        {username}
    )
    userAvatarUrl = userAvatarUrl or "https://cdn.discordapp.com/embed/avatars/5.png"
  
    -- Send webhook to Discord
    PerformHttpRequest(BIRDY_WEBHOOK, function()
        -- Empty callback function for webhook response
    end, "POST", json.encode({
        username = Config.Post and Config.Post.Accounts and Config.Post.Accounts.Birdy and Config.Post.Accounts.Birdy.Username or "Birdy",
        avatar_url = Config.Post and Config.Post.Accounts and Config.Post.Accounts.Birdy and Config.Post.Accounts.Birdy.Avatar or "https://loaf-scripts.com/fivem/lb-phone/icons/Birdy.png",
        embeds = {{
            title = L("APPS.TWITTER.NEW_POST"),
            description = (content and #content > 0) and content or nil,
            color = 1942002,
            timestamp = GetTimestampISO(),
            author = {
                name = "@" .. username,
                icon_url = userAvatarUrl
            },
            footer = {
                text = "LB Phone",
                icon_url = "https://docs.lbscripts.com/images/icons/icon.png"
            }
        }}
    }), {
        ["Content-Type"] = "application/json"
    })
end
function PostBirdy(username, content, attachments, replyTo, timestamp, tweetId)
  -- Default empty content if not provided
  if not content then
    content = ""
  end
  
  -- Validate username parameter
  assert(type(username) == "string", "PostBirdy: Expected string for argument 1 (username), got " .. type(username))
  -- Validate content parameter
  assert(type(content) == "string", "PostBirdy: Expected string/nil for argument 2 (content), got " .. type(content))
  
  -- Generate unique tweet ID
  tweetId = GenerateId("phone_twitter_tweets", "id")
  
  -- Prepare parameter values for database insertion
  local parameters = {tweetId, username, content}
  local insertQuery = "INSERT INTO phone_twitter_tweets (id, username, content"
  
  -- Handle attachments parameter
  if attachments then
    if type(attachments) == "table" then
      if table.type and table.type(attachments) == "array" then
        if #attachments > 0 then
          insertQuery = insertQuery .. ", attachments"
          parameters[#parameters + 1] = json.encode(attachments)
        end
      end
    else
      error("PostBirdy: Expected table/nil for argument 3 (attachments), got " .. type(attachments))
    end
  else
    -- Validate that there's either content or attachments
    local trimmedContent = content:gsub(" ", "")
    if #trimmedContent == 0 then
      debugprint("PostBirdy: No content & no attachments")
      return false
    end
  end
  -- Handle reply_to parameter
  if replyTo then
    if type(replyTo) == "string" then
      insertQuery = insertQuery .. ", reply_to"
      parameters[#parameters + 1] = replyTo
    else
      error("PostBirdy: Expected string/nil for argument 4 (replyTo), got " .. type(replyTo))
    end
  end
  
  -- Complete the INSERT query with VALUES clause
  local placeholders = ("?, "):rep(#parameters):sub(1, -3)
  insertQuery = insertQuery .. ") VALUES (" .. placeholders .. ")"
  
  -- Execute the INSERT query
  local insertedRows = MySQL.update.await(insertQuery, parameters)
  if insertedRows == 0 then
    return false
  end
  -- Get user profile information
  local userProfile = MySQL.single.await("SELECT display_name, profile_image, verified, private FROM phone_twitter_accounts WHERE username = ?", {username})
  if not userProfile then
    userProfile = {
      display_name = username
    }
  end
  -- Handle reply notifications if this is a reply to another tweet
  if replyTo then
    -- Update reply count for the original tweet
    MySQL.update("UPDATE phone_twitter_tweets SET reply_count = reply_count + 1 WHERE id = ?", {replyTo})
    
    -- Trigger client event to update tweet data
    TriggerClientEvent("phone:twitter:updateTweetData", -1, replyTo, "replies", true)
    
    -- Notify the original tweet author about the reply
    MySQL.scalar("SELECT username FROM phone_twitter_tweets WHERE id = ?", {replyTo}, function(originalAuthor)
      if originalAuthor then
        SendTwitterUserNotification(originalAuthor, username, "reply", tweetId)
      end
    end)
  end
  -- Notify followers about the new tweet
  MySQL.query("SELECT follower FROM phone_twitter_follows WHERE followed = ? AND notifications=1", {username}, function(followers)
    for i = 1, #followers do
      SendTwitterUserNotification(followers[i].follower, username, "tweet", tweetId)
    end
  end)
  
  -- Track social media post for statistics
  TrackSocialMediaPost("birdy", attachments)
  
  -- Handle public tweets (send notifications and webhooks)
  if not userProfile.private then
    SendTweetWebhook(tweetId, username, content, false)
    -- Send global notifications if enabled in config
    if Config.BirdyNotifications then
      local notifyType = (Config.BirdyNotifications == "all") and "all" or "online"
      NotifyEveryone(notifyType, {
        app = "Twitter",
        title = L("BACKEND.TWITTER.TWEET", {username = username}),
        content = content,
        thumbnail = attachments and attachments[1] or nil
      })
    end
    -- Handle hashtag trending if enabled
    if Config.BirdyTrending and Config.BirdyTrending.Enabled then
      if type(hashtags) == "table" and table.type(hashtags) == "array" and #hashtags > 0 then
        local hashtagQuery = "INSERT INTO phone_twitter_hashtags (hashtag, amount) VALUES " ..
                            ("(?, 1), "):rep(#hashtags):sub(1, -3) ..
                            " ON DUPLICATE KEY UPDATE amount = amount + 1"
        MySQL.update(hashtagQuery, hashtags)
      end
    end
    -- Prepare tweet data object for client response
    local tweetData = {
      id = tweetId,
      username = username,
      content = content,
      attachments = attachments,
      like_count = 0,
      reply_count = 0,
      retweet_count = 0,
      reply_to = replyTo,
      timestamp = os.time() * 1000,
      liked = false,
      retweeted = false,
      display_name = userProfile.display_name,
      profile_image = userProfile.profile_image,
      verified = userProfile.verified
    }
    
    -- Get reply author if this is a reply
    if replyTo then
      local replyAuthor = MySQL.scalar.await("SELECT username FROM phone_twitter_tweets WHERE id = ?", {replyTo})
      tweetData.replyToAuthor = replyAuthor
    end
    
    -- Trigger client event for new tweet
    TriggerClientEvent("phone:twitter:newtweet", -1, tweetData)
    
    -- Trigger server event for new post
    TriggerEvent("lb-phone:birdy:newPost", tweetData)
  end
  
  return true, tweetId
end

exports("PostBirdy", PostBirdy)

RegisterTwitterCallback("sendPost", function(playerId, timestamp, username, content, attachments, replyTo, hashtags)
  -- Check for blacklisted words in content
  if ContainsBlacklistedWord(playerId, "Birdy", content) then
    return false
  end
  
  -- Call PostBirdy function with the provided parameters (correct order)
  return PostBirdy(username, content, attachments, replyTo, timestamp, nil)
end, false)
RegisterCallback("birdy:getRecentHashtags", function(playerId)
  -- Return trending hashtags if trending is enabled
  if Config.BirdyTrending and Config.BirdyTrending.Enabled then
    return MySQL.query.await("SELECT hashtag, amount AS uses FROM phone_twitter_hashtags ORDER BY amount DESC LIMIT 5")
  end
  return {}
end)
RegisterLegacyCallback("birdy:deletePost", function(playerId, callback, tweetId)
  -- Get the user's Twitter username
  local username = GetTwitterAccount(playerId)
  if not username then
    return callback(false)
  end
  
  -- Get the tweet's reply information before deletion
  local replyTo = MySQL.Sync.fetchScalar("SELECT reply_to FROM phone_twitter_tweets WHERE id=@id", {["@id"] = tweetId})
  
  -- Check if user is admin or owns the tweet
  local canDelete = IsAdmin(playerId)
  if not canDelete then
    canDelete = MySQL.Sync.fetchScalar("SELECT TRUE FROM phone_twitter_tweets WHERE id=@id AND username=@username", {
      ["@id"] = tweetId,
      ["@username"] = username
    })
  end
  
  if not canDelete then
    return callback(false)
  end
  -- Delete all related data for the tweet
  local deleteParams = {["@id"] = tweetId}
  
  -- Delete likes
  MySQL.Sync.execute("DELETE FROM phone_twitter_likes WHERE tweet_id=@id", deleteParams)
  
  -- Delete retweets
  MySQL.Sync.execute("DELETE FROM phone_twitter_retweets WHERE tweet_id=@id", deleteParams)
  
  -- Delete notifications
  MySQL.Sync.execute("DELETE FROM phone_twitter_notifications WHERE tweet_id=@id", deleteParams)
  
  -- Delete the tweet itself
  local deletedRows = MySQL.Sync.execute("DELETE FROM phone_twitter_tweets WHERE id=@id", deleteParams)
  local success = deletedRows > 0
  
  callback(success)
  
  if not success then
    return
  end
  
  -- Update reply count if this was a reply to another tweet
  if replyTo then
    local currentReplyCount = MySQL.Sync.fetchScalar("SELECT COUNT(id) FROM phone_twitter_tweets WHERE reply_to=@replyTo", {
      ["@replyTo"] = replyTo
    })
    
    MySQL.Sync.execute("UPDATE phone_twitter_tweets SET reply_count=@count WHERE id=@replyTo", {
      ["@replyTo"] = replyTo,
      ["@count"] = currentReplyCount
    })
    
    -- Trigger client event to update tweet data
    TriggerClientEvent("phone:twitter:updateTweetData", -1, replyTo, "replies", false)
  end
  
  -- Log the deletion
  Log("Birdy", playerId, "info", "Post deleted", "**ID**: " .. tweetId)
end)

RegisterLegacyCallback("birdy:getRandomPromoted", function(playerId, callback)
  -- Check if user has a Twitter account
  local username = GetTwitterAccount(playerId)
  if not username then
    return callback(false)
  end
  
  -- Get a random promoted tweet
  local promotedTweetId = MySQL.Sync.fetchScalar("SELECT tweet_id FROM phone_twitter_promoted WHERE promotions > 0 ORDER BY RAND() LIMIT 1")
  if not promotedTweetId then
    return callback(false)
  end
  
  -- Decrease promotion count and increase views
  MySQL.Async.execute("UPDATE phone_twitter_promoted SET promotions = promotions - 1, views = views + 1 WHERE tweet_id = @tweetId", {
    ["@tweetId"] = promotedTweetId
  })
  
  -- Return the promoted tweet data
  callback(GetTweet(promotedTweetId))
end)

RegisterLegacyCallback("birdy:promotePost", function(playerId, callback, tweetId)
  -- Check if promotion is enabled and RemoveMoney function exists
  if not (Config.PromoteBirdy and Config.PromoteBirdy.Enabled and RemoveMoney) then
    return callback(false)
  end
  
  -- Try to remove the promotion cost from player
  local success = RemoveMoney(playerId, Config.PromoteBirdy.Cost)
  if not success then
    return callback(false)
  end
  
  -- Add promotion to database
  MySQL.Async.execute([[
    INSERT INTO phone_twitter_promoted (tweet_id, promotions, views) VALUES (@tweetId, @promotions, 0)
        ON DUPLICATE KEY UPDATE promotions = promotions + @promotions
  ]], {
    ["@tweetId"] = tweetId,
    ["@promotions"] = Config.PromoteBirdy.Views
  })
  
  callback(true)
end)

RegisterLegacyCallback("birdy:searchAccounts", function(playerId, callback, searchTerm)
  MySQL.Async.fetchAll([[
    SELECT display_name, username, profile_image, verified, private
    FROM phone_twitter_accounts
    WHERE
        username LIKE CONCAT(@search, "%")
        OR
        display_name LIKE CONCAT("%", @search, "%")
  ]], {
    ["@search"] = searchTerm
  }, callback)
end)

RegisterLegacyCallback("birdy:searchTweets", function(playerId, callback, searchTerm, page)
  -- Get user's Twitter username
  local username = GetTwitterAccount(playerId)
  if not username then
    return callback(false)
  end
  
  MySQL.Async.fetchAll([[
    SELECT
        DISTINCT t.id, t.username, t.content, t.attachments,
        t.like_count, t.reply_count, t.retweet_count, t.reply_to,
        t.`timestamp`,

        (
            CASE WHEN t.reply_to IS NULL THEN NULL ELSE (SELECT username FROM phone_twitter_tweets WHERE id=t.reply_to LIMIT 1) END
        ) AS replyToAuthor,

        a.display_name, a.username, a.profile_image, a.verified,

        (
            SELECT TRUE FROM phone_twitter_likes l
            WHERE l.tweet_id=t.id AND l.username=@loggedInAs
        ) AS liked,
        (
            SELECT TRUE FROM phone_twitter_retweets r
            WHERE r.tweet_id=t.id AND r.username=@loggedInAs
        ) AS retweeted

    FROM phone_twitter_tweets t
        LEFT JOIN phone_twitter_accounts a ON a.username=t.username
    WHERE
        t.content LIKE CONCAT("%", @search, "%")

    ORDER BY t.`timestamp` DESC

    LIMIT
        @page, @perPage
  ]], {
    ["@search"] = searchTerm,
    ["@loggedInAs"] = username,
    ["@page"] = page * 10,
    ["@perPage"] = 10
  }, callback)
end)

RegisterLegacyCallback("birdy:getData", function(playerId, callback, dataType, whereValue, page)
  -- Get user's Twitter username
  local username = GetTwitterAccount(playerId)
  if not username then
    return callback(false)
  end
  
  -- Determine table and column names based on data type
  local tableName = "phone_twitter_likes"
  local whereColumn = "tweet_id"
  local selectColumn = "username"
  
  if dataType == "following" or dataType == "followers" then
    tableName = "phone_twitter_follows"
    if dataType == "following" then
      whereColumn = "follower"
      selectColumn = "followed"
    else
      whereColumn = "followed"
      selectColumn = "follower"
    end
  elseif dataType == "retweeters" then
    tableName = "phone_twitter_retweets"
    whereColumn = "tweet_id"
    selectColumn = "username"
  end
  -- Build and execute the query
  local query = string.format([[
    SELECT
        a.display_name AS `name`,
        a.username,
        a.profile_image AS profile_picture,
        a.bio,
        a.verified,

    (
        SELECT CASE WHEN f.followed IS NULL THEN FALSE ELSE TRUE END
            FROM phone_twitter_follows f
            WHERE f.follower=@loggedInAs AND a.username=f.followed
    ) AS isFollowing,

    (
        SELECT CASE WHEN f.follower IS NULL THEN FALSE ELSE TRUE END
            FROM phone_twitter_follows f
            WHERE f.follower=a.username AND f.followed=@loggedInAs
    ) AS isFollowingYou

    FROM
        %s w
    JOIN
        phone_twitter_accounts a ON a.username=w.%s
    WHERE
        w.%s=@whereValue

    ORDER BY
        a.username DESC

    LIMIT
        @page, @perPage
  ]], tableName, selectColumn, whereColumn)

  MySQL.Async.fetchAll(query, {
    ["@loggedInAs"] = username,
    ["@whereValue"] = whereValue,
    ["@page"] = page * 20,
    ["@perPage"] = 20
  }, callback)
end)

function GetTweet(tweetId, loggedInUsername)
  if not tweetId then
    return
  end
  
  local result = MySQL.Sync.fetchAll([[
    SELECT
        DISTINCT t.id, t.username, t.content, t.attachments,
        t.like_count, t.reply_count, t.retweet_count, t.reply_to,
        t.`timestamp`,

        (
            CASE WHEN t.reply_to IS NULL THEN NULL ELSE (SELECT username FROM phone_twitter_tweets WHERE id=t.reply_to LIMIT 1) END
        ) AS replyToAuthor,

        a.display_name, a.username, a.profile_image, a.verified,

        (
            SELECT TRUE FROM phone_twitter_likes l
            WHERE l.tweet_id=t.id AND l.username=@loggedInAs
        ) AS liked,
        (
            SELECT TRUE FROM phone_twitter_retweets r
            WHERE r.tweet_id=t.id AND r.username=@loggedInAs
        ) AS retweeted

    FROM phone_twitter_tweets t

    INNER JOIN phone_twitter_accounts a
        ON a.username=t.username

    WHERE t.id=@tweetId AND (a.private=0 OR a.username=@loggedInAs OR (
        SELECT TRUE FROM phone_twitter_follows f
        WHERE f.follower=@loggedInAs AND f.followed=a.username
    ))
  ]], {
    ["@tweetId"] = tweetId,
    ["@loggedInAs"] = loggedInUsername
  })
  
  return result and result[1] or nil
end
exports("GetTweet", function(tweetId, callback)
  assert(type(tweetId) == "string", "Expected string for argument 1, got " .. type(tweetId))
  
  infoprint("warning", "GetTweet is deprecated, use GetBirdyPost instead")
  
  MySQL.Async.fetchAll([[
    SELECT
        DISTINCT t.id, t.username, t.content, t.attachments,
        t.like_count, t.reply_count, t.retweet_count, t.reply_to,
        t.`timestamp`,
        a.display_name, a.username, a.profile_image, a.verified
    FROM (phone_twitter_tweets t, phone_twitter_accounts a)
    WHERE t.id=@tweetId AND t.username=a.username
  ]], {
    ["@tweetId"] = tweetId
  }, callback)
end)

exports("GetBirdyPost", function(tweetId)
  local result = MySQL.single.await([[
    SELECT
        t.id,
        t.username,
        t.content,
        t.attachments,
        t.like_count AS likes,
        t.reply_count AS replies,
        t.retweet_count AS reposts,
        t.reply_to AS replyTo,
        t.`timestamp`,
        a.display_name AS displayName,
        a.profile_image AS avatar,
        a.verified
    FROM
        phone_twitter_tweets t
        LEFT JOIN phone_twitter_accounts a ON a.username = t.username
    WHERE
        t.id = ?
  ]], {tweetId})
  
  if result then
    -- Decode attachments if present
    result.attachments = result.attachments and json.decode(result.attachments) or nil
  end
  
  return result
end)

RegisterLegacyCallback("birdy:getPost", function(playerId, callback, tweetId)
  -- Get user's Twitter username
  local username = GetTwitterAccount(playerId)
  if not username then
    return callback(false)
  end
  
  callback(GetTweet(tweetId, username))
end)
RegisterLegacyCallback("birdy:getPosts", function(playerId, callback, filter, page)
  -- Get user's Twitter username
  local username = GetTwitterAccount(playerId)
  if not username then
    return callback({})
  end
  
  -- Initialize query components
  local whereClause = ""
  local joinClause = ""
  local orderClause = "`timestamp` DESC"
  local includeRetweets = false
  local retweetJoin = ""
  local retweetFollowJoin = ""
  
  -- Build query based on filter type
  if not filter then
    -- Default: Get all non-reply tweets
    whereClause = "t.reply_to IS NULL"
    includeRetweets = true
  else
    if filter.type == "following" then
      -- Following feed: tweets from users we follow
      whereClause = "t.reply_to IS NULL AND f.follower=@loggedInAs AND f.followed=t.username"
      joinClause = "JOIN phone_twitter_follows f"
      retweetFollowJoin = "JOIN phone_twitter_follows f ON f.follower=@loggedInAs AND r.username=f.followed"
      includeRetweets = true
    elseif filter.type == "replyTo" then
      -- Replies to a specific tweet
      whereClause = "t.reply_to=@replyTo"
      orderClause = "t.like_count DESC, t.timestamp DESC"
    elseif filter.type == "user" then
      -- User's own tweets (non-replies)
      whereClause = "t.username=@username AND t.reply_to IS NULL"
      retweetJoin = " AND r.username=@username"
      includeRetweets = true
    elseif filter.type == "media" then
      -- User's tweets with attachments
      whereClause = "t.username=@username AND t.attachments IS NOT NULL"
    elseif filter.type == "replies" then
      -- User's replies
      whereClause = "t.username=@username AND t.reply_to IS NOT NULL"
    elseif filter.type == "liked" then
      -- Tweets liked by user
      whereClause = "l.username=@username AND t.id=l.tweet_id"
      joinClause = "JOIN phone_twitter_likes l"
      orderClause = "l.timestamp DESC"
    end
  end
  
  -- Build the main query
  local mainQuery = string.format([[
    SELECT
        (
            CASE WHEN t.reply_to IS NULL THEN NULL ELSE (SELECT username FROM phone_twitter_tweets WHERE id=t.reply_to LIMIT 1) END
        ) AS replyToAuthor,

        t.id, t.username, t.content, t.attachments,
        t.like_count, t.reply_count, t.retweet_count, t.reply_to,
        t.`timestamp`,

        a.display_name, a.profile_image, a.verified, a.private,

        (
            SELECT TRUE FROM phone_twitter_likes l2
            WHERE l2.tweet_id=t.id AND l2.username=@loggedInAs
        ) AS liked,
        (
            SELECT TRUE FROM phone_twitter_retweets r2
            WHERE r2.tweet_id=t.id AND r2.username=@loggedInAs
        ) AS retweeted,

        NULL AS tweet_timestamp, NULL AS retweeted_by_display_name, NULL AS retweeted_by_username
    FROM phone_twitter_tweets t

    INNER JOIN phone_twitter_accounts a
        ON a.username=t.username

    %s
    WHERE (a.private=0 OR a.username=@loggedInAs OR (
        SELECT TRUE FROM phone_twitter_follows f
        WHERE f.follower=@loggedInAs AND f.followed=a.username
    )) AND %s
  ]], joinClause, whereClause)
  -- Add retweets union if needed
  if includeRetweets then
    local retweetQuery = string.format([[
        UNION ALL
        SELECT
            (
                CASE WHEN t.reply_to IS NULL THEN NULL ELSE (SELECT username FROM phone_twitter_tweets WHERE id=t.reply_to LIMIT 1) END
            ) AS replyToAuthor,

            t.id, t.username, t.content, t.attachments,
            t.like_count, t.reply_count, t.retweet_count, t.reply_to,
            r.timestamp,

            a.display_name, a.profile_image, a.verified, a.private,

            (
                SELECT TRUE FROM phone_twitter_likes l2
                WHERE l2.tweet_id=t.id AND l2.username=@loggedInAs
            ) AS liked,
            (
                SELECT TRUE FROM phone_twitter_retweets r2
                WHERE r2.tweet_id=t.id AND r2.username=@loggedInAs
            ) AS retweeted,

            t.`timestamp` AS tweet_timestamp,
            (
                SELECT display_name FROM phone_twitter_accounts a2
                WHERE r.username=a2.username
            ) AS retweeted_by_display_name,
            r.username AS retweeted_by_username

        FROM phone_twitter_tweets t

        INNER JOIN phone_twitter_accounts a
            ON a.username=t.username

        JOIN phone_twitter_retweets r ON r.tweet_id=t.id
        %s
        WHERE (a.private=0 OR a.username=@loggedInAs OR (
            SELECT TRUE FROM phone_twitter_follows f
            WHERE f.follower=@loggedInAs AND f.followed=a.username
        )) %s
    ]], retweetFollowJoin, retweetJoin)
    
    mainQuery = mainQuery .. retweetQuery
  end
  -- Complete the query with ORDER BY and LIMIT
  local fullQuery = mainQuery .. string.format("\nORDER BY %s\nLIMIT @page, @perPage", orderClause)
  
  -- Execute the query
  MySQL.Async.fetchAll(fullQuery, {
    ["@page"] = page * 10,
    ["@perPage"] = 10,
    ["@username"] = filter and filter.username or nil,
    ["@replyTo"] = filter and filter.tweet_id or nil,
    ["@loggedInAs"] = username
  }, callback)
end)

-- Interaction configuration for likes and retweets
local interactions = {
  like = {
    table = "phone_twitter_likes",
    column1 = "username",
    column2 = "tweet_id"
  },
  retweet = {
    table = "phone_twitter_retweets",
    column1 = "username",
    column2 = "tweet_id"
  }
}
RegisterLegacyCallback("birdy:toggleInteraction", function(playerId, callback, interactionType, tweetId, shouldAdd)
  -- Validate interaction type
  if interactionType ~= "like" and interactionType ~= "retweet" then
    return
  end
  
  -- Get user's Twitter username
  local username = GetTwitterAccount(playerId)
  if not username then
    return callback(not shouldAdd)  -- Return opposite of intended action if no account
  end
  
  -- Callback function to handle the database operation result
  local function handleResult(affectedRows)
    if affectedRows == 0 then
      return callback(not shouldAdd)  -- Return opposite if operation failed
    else
      callback(shouldAdd)  -- Return the intended state if successful
    end
    
    -- Trigger client event to update tweet data
    local updateType = (interactionType == "like") and "likes" or "retweets"
    TriggerClientEvent("phone:twitter:updateTweetData", -1, tweetId, updateType, shouldAdd == true)
    
    -- Send notification if adding interaction
    if shouldAdd then
      local tweetAuthor = MySQL.Sync.fetchScalar("SELECT username FROM phone_twitter_tweets WHERE id=@tweetId", {
        ["@tweetId"] = tweetId
      })
      SendTwitterUserNotification(tweetAuthor, username, interactionType, tweetId)
    end
  end
  
  -- Get interaction configuration
  local config = interactions[interactionType]
  local tableName = config.table
  local column1 = config.column1
  local column2 = config.column2
  
  -- Execute the appropriate database operation
  if shouldAdd then
    -- Add interaction (like or retweet)
    local insertQuery = string.format("INSERT IGNORE INTO %s (%s, %s) VALUES (@loggedInAs, @tweetId)", tableName, column1, column2)
    MySQL.Async.execute(insertQuery, {
      ["@loggedInAs"] = username,
      ["@tweetId"] = tweetId
    }, handleResult)
  else
    -- Remove interaction (unlike or unretweet)
    local deleteQuery = string.format("DELETE FROM %s WHERE %s=@loggedInAs AND %s=@tweetId", tableName, column1, column2)
    MySQL.Async.execute(deleteQuery, {
      ["@loggedInAs"] = username,
      ["@tweetId"] = tweetId
    }, handleResult)
  end
end, {
  preventSpam = true,
  rateLimit = 30
})

RegisterLegacyCallback("birdy:toggleNotifications", function(playerId, callback, targetUsername, enabled)
  -- Get user's Twitter username
  local username = GetTwitterAccount(playerId)
  if not username then
    return callback(not enabled)
  end
  
  -- Update notification settings for the follow relationship
  MySQL.Async.execute("UPDATE phone_twitter_follows SET notifications=@enabled WHERE follower=@loggedInAs AND followed=@username", {
    ["@enabled"] = enabled,
    ["@loggedInAs"] = username,
    ["@username"] = targetUsername
  }, function(affectedRows)
    if affectedRows > 0 then
      callback(enabled)
    else
      callback(not enabled)
    end
  end)
end)

RegisterLegacyCallback("birdy:toggleFollow", function(playerId, callback, targetUsername, shouldFollow)
  -- Get user's Twitter username
  local username = GetTwitterAccount(playerId)
  if not username or targetUsername == username then
    return callback(not shouldFollow)  -- Can't follow yourself or if no account
  end
  
  -- Prepare database parameters
  local params = {
    ["@loggedInAs"] = username,
    ["@username"] = targetUsername
  }
  
  -- Check if target account is private
  local isPrivate = MySQL.Sync.fetchScalar("SELECT private FROM phone_twitter_accounts WHERE username=@username", params)
  
  -- Handle private accounts with follow requests
  if isPrivate then
    if shouldFollow then
      -- Send follow request to private account
      MySQL.Async.execute("INSERT IGNORE INTO phone_twitter_follow_requests (requester, requestee) VALUES (@loggedInAs, @username)", params, function(affectedRows)
        callback(shouldFollow)
        
        if affectedRows == 0 then
          return  -- Request already exists
        end
        
        -- Notify target user about follow request
        local targetPlayers = GetPlayersByUsername(targetUsername)
        for playerId, _ in pairs(targetPlayers) do
          SendNotification(playerId, {
            app = "Twitter",
            content = L("BACKEND.TWITTER.NEW_FOLLOW_REQUEST", {username = username})
          })
        end
      end)
      return
    else
      -- Remove follow request
      MySQL.Async.execute("DELETE FROM phone_twitter_follow_requests WHERE requester=@loggedInAs AND requestee=@username", params)
    end
  end
  
  -- Handle public accounts (direct follow/unfollow)
  local followQuery = shouldFollow and 
    "INSERT IGNORE INTO phone_twitter_follows (followed, follower) VALUES (@username, @loggedInAs)" or
    "DELETE FROM phone_twitter_follows WHERE followed=@username AND follower=@loggedInAs"
  
  MySQL.Async.execute(followQuery, params, function(affectedRows)
    if affectedRows == 0 then
      return callback(not shouldFollow)  -- Operation failed
    end
    
    -- Update client data for both users
    TriggerClientEvent("phone:twitter:updateProfileData", -1, targetUsername, "followers", shouldFollow == true)
    TriggerClientEvent("phone:twitter:updateProfileData", -1, username, "following", shouldFollow == true)
    
    -- Send notification if following
    if shouldFollow then
      SendTwitterUserNotification(targetUsername, username, "follow")
    end
    
    callback(shouldFollow)
  end)
end)

RegisterLegacyCallback("birdy:getFollowRequests", function(playerId, callback, page)
  -- Get user's Twitter username
  local username = GetTwitterAccount(playerId)
  if not username then
    return callback({})
  end
  
  MySQL.Async.fetchAll([[
    SELECT a.username, a.display_name AS `name`, a.profile_image AS profile_picture, a.verified,
        (
            SELECT CASE WHEN f.follower IS NULL THEN FALSE ELSE TRUE END
                FROM phone_twitter_follows f
                WHERE f.follower=a.username AND f.followed=@loggedInAs
        ) AS isFollowingYou

    FROM phone_twitter_follow_requests r

    INNER JOIN phone_twitter_accounts a
        ON a.username=r.requester

    WHERE r.requestee=@loggedInAs

    ORDER BY r.`timestamp` DESC

    LIMIT @page, @perPage
  ]], {
    ["@loggedInAs"] = username,
    ["@page"] = (page or 0) * 15,
    ["@perPage"] = 15
  }, callback)
end)

RegisterLegacyCallback("birdy:handleFollowRequest", function(playerId, callback, requesterUsername, accepted)
  -- Get user's Twitter username
  local username = GetTwitterAccount(playerId)
  if not username then
    return callback(false)
  end
  
  -- Prepare database parameters
  local params = {
    ["@loggedInAs"] = username,
    ["@username"] = requesterUsername
  }
  
  -- Remove the follow request
  local deletedRows = MySQL.Sync.execute("DELETE FROM phone_twitter_follow_requests WHERE requestee=@loggedInAs AND requester=@username", params)
  if deletedRows == 0 then
    return callback(false)  -- Request didn't exist
  end
  
  -- If request was declined, just return success
  if not accepted then
    return callback(true)
  end
  -- Accept the follow request - create the follow relationship
  MySQL.Sync.execute("INSERT IGNORE INTO phone_twitter_follows (follower, followed) VALUES (@username, @loggedInAs)", params)
  
  -- Update client data for both users
  TriggerClientEvent("phone:twitter:updateProfileData", -1, username, "followers", true)
  TriggerClientEvent("phone:twitter:updateProfileData", -1, requesterUsername, "following", true)
  
  -- Send follow notification
  SendTwitterUserNotification(username, requesterUsername, "follow")
  
  -- Notify requester that their request was accepted
  local requesterPlayers = GetPlayersByUsername(requesterUsername)
  for playerId, _ in pairs(requesterPlayers) do
    SendNotification(playerId, {
      app = "Twitter",
      content = L("BACKEND.TWITTER.FOLLOW_REQUEST_ACCEPTED_DESCRIPTION", {username = username})
    })
  end
  
  callback(true)
end)

RegisterTwitterCallback("sendMessage", function(playerId, timestamp, senderUsername, recipientUsername, content, attachments)
  -- Check for blacklisted words in message content
  if ContainsBlacklistedWord(playerId, "Birdy", content) then
    return false
  end
  
  -- Insert the message into database
  local insertedRows = MySQL.update.await([[
    INSERT INTO phone_twitter_messages (id, sender, recipient, content, attachments)
    VALUES (@id, @sender, @recipient, @content, @attachments)
  ]], {
    ["@id"] = GenerateId("phone_twitter_messages", "id"),
    ["@sender"] = senderUsername,
    ["@recipient"] = recipientUsername,
    ["@content"] = content,
    ["@attachments"] = attachments and json.encode(attachments) or nil
  })
  
  if insertedRows == 0 then
    return false
  end
  
  -- Notify all connected users of the recipient
  local recipientUsers = GetTwitterAccount(recipientUsername)
  for userId, userSource in pairs(recipientUsers) do
    if userSource then
      TriggerClientEvent("phone:twitter:newMessage", userSource, {
        sender = senderUsername,
        recipient = recipientUsername,
        content = content,
        attachments = attachments,
        timestamp = os.time() * 1000
      })
    end
  end
  
  -- Send notification to sender
  local senderProfile = GetTwitterProfile(senderUsername)
  if not senderProfile then
    return true
  end
  
  -- Send notification to all sender's connections
  for userId, userSource in pairs(recipientUsers) do
    SendNotification(userId, {
      source = userSource,
      app = "Twitter",
      title = senderProfile.name,
      content = content,
      thumbnail = attachments and attachments[1] or nil,
      avatar = senderProfile.profile_picture,
      showAvatar = true
    })
  end
  
  return true
end, nil, {
  preventSpam = true,
  rateLimit = 15
})

RegisterLegacyCallback("birdy:getMessages", function(source, cb, username, page)
  local account = GetTwitterAccount(source)
  if not account then
    return cb({})
  end
  
  local query = [[
        SELECT
            sender, recipient, content, attachments, `timestamp`
        FROM phone_twitter_messages
        WHERE (sender=@loggedInAs AND recipient=@username) OR (sender=@username AND recipient=@loggedInAs)
        ORDER BY `timestamp` DESC
        LIMIT @page, @perPage
    ]]
  
  local params = {
    ["@loggedInAs"] = account,
    ["@username"] = username,
    ["@page"] = page * 25,
    ["@perPage"] = 25
  }
  
  MySQL.Async.fetchAll(query, params, cb)
end)

RegisterLegacyCallback("birdy:getRecentMessages", function(source, cb, page)
  local account = GetTwitterAccount(source)
  if not account then
    return cb({})
  end
  
  local query = [[
        SELECT
            m.content, m.attachments, m.sender, f_m.username, m.`timestamp`,
            a.display_name AS `name`, a.profile_image AS profile_picture, a.verified
        FROM phone_twitter_messages m
        JOIN ((
            SELECT (
                CASE WHEN recipient!=@loggedInAs THEN recipient ELSE sender END
            ) AS username, MAX(`timestamp`) AS `timestamp`
            FROM phone_twitter_messages
            WHERE sender=@loggedInAs OR recipient=@loggedInAs
            GROUP BY username
        ) f_m)
        ON m.`timestamp`=f_m.`timestamp`
        INNER JOIN phone_twitter_accounts a
            ON a.username=f_m.username
        WHERE m.sender=@loggedInAs OR m.recipient=@loggedInAs
        GROUP BY f_m.username
        ORDER BY m.`timestamp` DESC
        LIMIT @page, @perPage
    ]]
  
  local params = {
    ["@loggedInAs"] = account,
    ["@page"] = (page or 0) * 15,
    ["@perPage"] = 15
  }
  
  MySQL.Async.fetchAll(query, params, cb)
end)

CreateThread(function()
  if not Config.BirdyTrending.Enabled then
    return
  end
  
  -- Wait for database checker to finish
  while true do
    if DatabaseCheckerFinished then
      break
    end
    Wait(500)
  end
  
  -- Main trending hashtags cleanup loop
  while true do
    local resetInterval = Config.BirdyTrending.Reset or 24
    local deleteQuery = string.format(
      "DELETE FROM phone_twitter_hashtags WHERE last_used < DATE_SUB(NOW(), INTERVAL %s HOUR)", 
      tostring(resetInterval)
    )
    
    MySQL.Async.execute(deleteQuery, {})
    
    -- Wait 1 hour before next cleanup
    Wait(3600000)
  end
end)
