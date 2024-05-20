--Shamelessly borrowing from Eldritch Horror Complete
self.createButton({click_function='drawAll',
                  function_owner=self,
                  label='FindAll',
                  position={0,0.5,0},
                  width=400,
                  height=150})

deck_object_all = nil

function onCollisionEnter(collision_info)
  if collision_info.collision_object.getQuantity() > 1 then
    deck_object_all = collision_info.collision_object
  end
end

function onCollisionExit(collision_info)
  if collision_info.collision_object.getQuantity() > 1 then
    deck_object_all = nil
  end
end

function drawAll()
  if self.getName() ~= '' and deck_object_all ~= nil and deck_object_all.getObjects() ~= nil then
        -- Do the matching
        local pos = {self.getPosition().x,self.getPosition().y+2,self.getPosition().z}

        name = self.getName()
        print("Name: " .. name)
        matchFn = function(v) return string.find(string.lower(v.nickname),string.lower(name)) end
        matchGmFn = function(v) return string.find(string.lower(v.gm_notes),string.lower(name)) end

        res=takeFromCollection(deck_object_all, matchGmFn, pos)
        if (res == nil) then
          res=takeFromCollection(deck_object_all, matchFn, pos)
        end
  end
end

function takeFromCollection(collection, matchFn, matchPosition)
    if collection ~= nil and collection.getObjects() ~= nil then
        matchObj = nil
        matchesAll = true

        for k,v in pairs(collection.getObjects()) do
            if not( matchFn(v) ) then
                matchesAll = false
                break
            end
        end

        if matchesAll then
            -- Take whole deck
            collection.setPosition(matchPosition)
            matchObj = collection
        else
            -- Take only matches out of the deck, and form new deck
            params = {top=false, position = matchPosition}

            for k,v in pairs(collection.getObjects()) do
                if ( matchFn(v) ) then
                    params.guid = v.guid
                    params.callback_function = function(obj) if (matchObj == nil) then matchObj = newObj else matchObj.putObject(newObj) end end
                    newObj = collection.takeObject(params)
                end
            end
        end

        return matchObj
    else
        return nil
    end
end
