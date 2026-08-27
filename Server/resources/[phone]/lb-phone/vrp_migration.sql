-- Execute somente se utilizou a adaptação antiga 'pandora:'
UPDATE phone_phones SET owner_id = REPLACE(owner_id, 'pandora:', 'vrp:') WHERE owner_id LIKE 'pandora:%';
