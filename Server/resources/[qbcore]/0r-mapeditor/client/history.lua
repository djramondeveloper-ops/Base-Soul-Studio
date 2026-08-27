local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1
L0_1 = {}
History = L0_1
L0_1 = {}
Cmd = L0_1
L0_1 = {}
L1_1 = {}
L2_1 = false
L3_1 = 100
L4_1 = 600
L5_1 = History
function L6_1()
  local L0_2, L1_2
  L0_2 = L2_1
  return L0_2
end
L5_1.IsApplying = L6_1
function L5_1(A0_2)
  local L1_2, L2_2
  L1_2 = Objects
  L1_2 = L1_2.IdByUid
  L2_2 = A0_2
  return L1_2(L2_2)
end
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L5_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    return
  end
  if A1_2 then
    L3_2 = Objects
    L3_2 = L3_2.Get
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L4_2 = L3_2.dbId
      if L4_2 then
        L4_2 = #A1_2
        L4_2 = L4_2 + 1
        L5_2 = L3_2.dbId
        A1_2[L4_2] = L5_2
      end
    end
    L4_2 = Objects
    L4_2 = L4_2.Remove
    L5_2 = L2_2
    L6_2 = true
    L4_2(L5_2, L6_2)
  else
    L3_2 = Objects
    L3_2 = L3_2.Remove
    L4_2 = L2_2
    L3_2(L4_2)
  end
end
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = A0_2.kind
  if "add" == L3_2 then
    if "undo" == A1_2 then
      L3_2 = L6_1
      L4_2 = A0_2.snapshot
      L4_2 = L4_2.uid
      L5_2 = A2_2
      L3_2(L4_2, L5_2)
    else
      L3_2 = Objects
      L3_2 = L3_2.Recreate
      L4_2 = A0_2.snapshot
      L3_2(L4_2)
    end
  else
    L3_2 = A0_2.kind
    if "delete" == L3_2 then
      if "undo" == A1_2 then
        L3_2 = Objects
        L3_2 = L3_2.Recreate
        L4_2 = A0_2.snapshot
        L3_2(L4_2)
      else
        L3_2 = L6_1
        L4_2 = A0_2.snapshot
        L4_2 = L4_2.uid
        L5_2 = A2_2
        L3_2(L4_2, L5_2)
      end
    else
      L3_2 = A0_2.kind
      if "transform" == L3_2 then
        L3_2 = L5_1
        L4_2 = A0_2.uid
        L3_2 = L3_2(L4_2)
        if not L3_2 then
          return
        end
        if "undo" == A1_2 then
          L4_2 = A0_2.before
          if L4_2 then
            goto lbl_48
          end
        end
        L4_2 = A0_2.after
        ::lbl_48::
        L5_2 = Objects
        L5_2 = L5_2.Update
        L6_2 = L3_2
        L7_2 = vector3
        L8_2 = L4_2.coords
        L8_2 = L8_2.x
        L9_2 = L4_2.coords
        L9_2 = L9_2.y
        L10_2 = L4_2.coords
        L10_2 = L10_2.z
        L7_2 = L7_2(L8_2, L9_2, L10_2)
        L8_2 = vector3
        L9_2 = L4_2.rot
        L9_2 = L9_2.x
        L10_2 = L4_2.rot
        L10_2 = L10_2.y
        L11_2 = L4_2.rot
        L11_2 = L11_2.z
        L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2, L10_2, L11_2)
        L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
        L5_2 = MEAutoSave
        if L5_2 then
          L5_2 = MEAutoSave
          L6_2 = L3_2
          L5_2(L6_2)
        end
      else
        L3_2 = A0_2.kind
        if "props" == L3_2 then
          L3_2 = L5_1
          L4_2 = A0_2.uid
          L3_2 = L3_2(L4_2)
          if not L3_2 then
            return
          end
          if "undo" == A1_2 then
            L4_2 = A0_2.before
            if L4_2 then
              goto lbl_90
            end
          end
          L4_2 = A0_2.after
          ::lbl_90::
          L5_2 = L4_2.props
          if L5_2 then
            L5_2 = Objects
            L5_2 = L5_2.SetProps
            L6_2 = L3_2
            L7_2 = L4_2.props
            L5_2(L6_2, L7_2)
          end
          L5_2 = L4_2.blip
          if L5_2 then
            L5_2 = Objects
            L5_2 = L5_2.SetBlip
            L6_2 = L3_2
            L7_2 = L4_2.blip
            L7_2 = L7_2.name
            L8_2 = L4_2.blip
            L8_2 = L8_2.color
            L9_2 = L4_2.blip
            L9_2 = L9_2.on
            L5_2(L6_2, L7_2, L8_2, L9_2)
          end
          L5_2 = L4_2.layer
          if L5_2 then
            L5_2 = Objects
            L5_2 = L5_2.SetObjectLayer
            L6_2 = L3_2
            L7_2 = L4_2.layer
            L5_2(L6_2, L7_2)
          end
          L5_2 = MEAutoSave
          if L5_2 then
            L5_2 = MEAutoSave
            L6_2 = L3_2
            L5_2(L6_2)
          end
        else
          L3_2 = A0_2.kind
          if "replace" == L3_2 then
            L3_2 = L5_1
            L4_2 = A0_2.uid
            L3_2 = L3_2(L4_2)
            if not L3_2 then
              return
            end
            L4_2 = Objects
            L4_2 = L4_2.Replace
            L5_2 = L3_2
            if "undo" == A1_2 then
              L6_2 = A0_2.before
              if L6_2 then
                goto lbl_144
              end
            end
            L6_2 = A0_2.after
            ::lbl_144::
            L4_2(L5_2, L6_2)
            L4_2 = MEAutoSave
            if L4_2 then
              L4_2 = MEAutoSave
              L5_2 = L3_2
              L4_2(L5_2)
            end
          else
            L3_2 = A0_2.kind
            if "worldhide" == L3_2 then
              if "undo" == A1_2 then
                L3_2 = WorldProps
                if L3_2 then
                  L3_2 = WorldProps
                  L3_2 = L3_2.RestoreEntry
                  if L3_2 then
                    L3_2 = WorldProps
                    L3_2 = L3_2.RestoreEntry
                    L4_2 = A0_2.entry
                    L3_2(L4_2)
                  end
                end
              else
                L3_2 = WorldProps
                if L3_2 then
                  L3_2 = WorldProps
                  L3_2 = L3_2.HideEntry
                  if L3_2 then
                    L3_2 = WorldProps
                    L3_2 = L3_2.HideEntry
                    L4_2 = A0_2.entry
                    L3_2(L4_2)
                  end
                end
              end
            else
              L3_2 = A0_2.kind
              if "light_add" == L3_2 then
                if "undo" == A1_2 then
                  L3_2 = Lights
                  if L3_2 then
                    L3_2 = Lights
                    L3_2 = L3_2.RemoveById
                    if L3_2 then
                      L3_2 = Lights
                      L3_2 = L3_2.RemoveById
                      L4_2 = A0_2.id
                      L3_2(L4_2)
                    end
                  end
                else
                  L3_2 = Lights
                  if L3_2 then
                    L3_2 = Lights
                    L3_2 = L3_2.Restore
                    if L3_2 then
                      L3_2 = Lights
                      L3_2 = L3_2.Restore
                      L4_2 = A0_2.id
                      L5_2 = A0_2.data
                      L3_2(L4_2, L5_2)
                    end
                  end
                end
              else
                L3_2 = A0_2.kind
                if "light_del" == L3_2 then
                  if "undo" == A1_2 then
                    L3_2 = Lights
                    if L3_2 then
                      L3_2 = Lights
                      L3_2 = L3_2.Restore
                      if L3_2 then
                        L3_2 = Lights
                        L3_2 = L3_2.Restore
                        L4_2 = A0_2.id
                        L5_2 = A0_2.data
                        L3_2(L4_2, L5_2)
                      end
                    end
                  else
                    L3_2 = Lights
                    if L3_2 then
                      L3_2 = Lights
                      L3_2 = L3_2.RemoveById
                      if L3_2 then
                        L3_2 = Lights
                        L3_2 = L3_2.RemoveById
                        L4_2 = A0_2.id
                        L3_2(L4_2)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = A0_2.kind
  if "batch" == L2_2 then
    L2_2 = A0_2.items
    L3_2 = {}
    if "undo" == A1_2 then
      L4_2 = #L2_2
      L5_2 = 1
      L6_2 = -1
      for L7_2 = L4_2, L5_2, L6_2 do
        L8_2 = L7_1
        L9_2 = L2_2[L7_2]
        L10_2 = "undo"
        L11_2 = L3_2
        L8_2(L9_2, L10_2, L11_2)
      end
    else
      L4_2 = 1
      L5_2 = #L2_2
      L6_2 = 1
      for L7_2 = L4_2, L5_2, L6_2 do
        L8_2 = L7_1
        L9_2 = L2_2[L7_2]
        L10_2 = "redo"
        L11_2 = L3_2
        L8_2(L9_2, L10_2, L11_2)
      end
    end
    L4_2 = #L3_2
    if L4_2 > 0 then
      L4_2 = TriggerServerEvent
      L5_2 = "0r-mapeditor:deleteObjects"
      L6_2 = {}
      L6_2.dbIds = L3_2
      L4_2(L5_2, L6_2)
    end
  else
    L2_2 = L7_1
    L3_2 = A0_2
    L4_2 = A1_2
    L5_2 = nil
    L2_2(L3_2, L4_2, L5_2)
  end
end
L9_1 = History
function L10_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L0_1
  L1_2 = #L0_2
  L0_2 = L0_1
  L0_2 = L0_2[L1_2]
  L1_2 = L1_1
  L2_2 = #L1_2
  L1_2 = L1_1
  L1_2 = L1_2[L2_2]
  L2_2 = {}
  L3_2 = L0_1
  L3_2 = #L3_2
  L3_2 = L3_2 > 0
  L2_2.canUndo = L3_2
  L3_2 = L1_1
  L3_2 = #L3_2
  L3_2 = L3_2 > 0
  L2_2.canRedo = L3_2
  if L0_2 then
    L3_2 = L0_2.label
    if L3_2 then
      goto lbl_31
    end
  end
  L3_2 = ""
  ::lbl_31::
  L2_2.undoLabel = L3_2
  if L1_2 then
    L3_2 = L1_2.label
    if L3_2 then
      goto lbl_38
    end
  end
  L3_2 = ""
  ::lbl_38::
  L2_2.redoLabel = L3_2
  return L2_2
end
L9_1.State = L10_1
function L9_1()
  local L0_2, L1_2, L2_2
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "history"
  L2_2 = History
  L2_2 = L2_2.State
  L2_2 = L2_2()
  L1_2.data = L2_2
  L0_2(L1_2)
end
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2.after
  if L1_2 then
    L2_2 = L1_2.props
    if L2_2 then
      L2_2 = "props"
      return L2_2
    end
  end
  if L1_2 then
    L2_2 = L1_2.blip
    if L2_2 then
      L2_2 = "blip"
      return L2_2
    end
  end
  if L1_2 then
    L2_2 = L1_2.layer
    if L2_2 then
      L2_2 = "layer"
      return L2_2
    end
  end
  L2_2 = "?"
  return L2_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L0_1
  L2_2 = #L1_2
  L1_2 = L0_1
  L1_2 = L1_2[L2_2]
  if L1_2 then
    L2_2 = L1_2.kind
    L3_2 = A0_2.kind
    if L2_2 == L3_2 then
      L2_2 = L1_2.uid
      L3_2 = A0_2.uid
      if L2_2 == L3_2 then
        goto lbl_17
      end
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_17::
  L2_2 = A0_2.t
  L3_2 = L1_2.t
  if not L3_2 then
    L3_2 = 0
  end
  L2_2 = L2_2 - L3_2
  L3_2 = L4_1
  if L2_2 > L3_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = A0_2.kind
  if "transform" == L2_2 then
    L2_2 = A0_2.after
    L1_2.after = L2_2
    L2_2 = A0_2.t
    L1_2.t = L2_2
    L2_2 = true
    return L2_2
  else
    L2_2 = A0_2.kind
    if "props" == L2_2 then
      L2_2 = L10_1
      L3_2 = L1_2
      L2_2 = L2_2(L3_2)
      L3_2 = L10_1
      L4_2 = A0_2
      L3_2 = L3_2(L4_2)
      if L2_2 == L3_2 then
        L2_2 = A0_2.after
        L1_2.after = L2_2
        L2_2 = A0_2.t
        L1_2.t = L2_2
        L2_2 = true
        return L2_2
      end
    end
  end
  L2_2 = false
  return L2_2
end
L12_1 = History
function L13_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L2_1
  if L1_2 or not A0_2 then
    return
  end
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  A0_2.t = L1_2
  L1_2 = L11_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = L0_1
    L1_2 = #L1_2
    L2_2 = L1_2 + 1
    L1_2 = L0_1
    L1_2[L2_2] = A0_2
    L1_2 = L0_1
    L1_2 = #L1_2
    L2_2 = L3_1
    if L1_2 > L2_2 then
      L1_2 = table
      L1_2 = L1_2.remove
      L2_2 = L0_1
      L3_2 = 1
      L1_2(L2_2, L3_2)
    end
  end
  L1_2 = {}
  L1_1 = L1_2
  L1_2 = L9_1
  L1_2()
end
L12_1.Push = L13_1
L12_1 = History
function L13_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L0_1
  L1_2 = #L0_2
  L0_2 = L0_1
  L0_2 = L0_2[L1_2]
  if not L0_2 then
    return
  end
  L1_2 = L0_1
  L2_2 = #L1_2
  L1_2 = L0_1
  L1_2[L2_2] = nil
  L1_2 = true
  L2_1 = L1_2
  L1_2 = L8_1
  L2_2 = L0_2
  L3_2 = "undo"
  L1_2(L2_2, L3_2)
  L1_2 = false
  L2_1 = L1_2
  L1_2 = L1_1
  L1_2 = #L1_2
  L2_2 = L1_2 + 1
  L1_2 = L1_1
  L1_2[L2_2] = L0_2
  L1_2 = L9_1
  L1_2()
  L1_2 = L0_2.label
  return L1_2
end
L12_1.Undo = L13_1
L12_1 = History
function L13_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L1_1
  L1_2 = #L0_2
  L0_2 = L1_1
  L0_2 = L0_2[L1_2]
  if not L0_2 then
    return
  end
  L1_2 = L1_1
  L2_2 = #L1_2
  L1_2 = L1_1
  L1_2[L2_2] = nil
  L1_2 = true
  L2_1 = L1_2
  L1_2 = L8_1
  L2_2 = L0_2
  L3_2 = "redo"
  L1_2(L2_2, L3_2)
  L1_2 = false
  L2_1 = L1_2
  L1_2 = L0_1
  L1_2 = #L1_2
  L2_2 = L1_2 + 1
  L1_2 = L0_1
  L1_2[L2_2] = L0_2
  L1_2 = L9_1
  L1_2()
  L1_2 = L0_2.label
  return L1_2
end
L12_1.Redo = L13_1
L12_1 = History
function L13_1()
  local L0_2, L1_2
  L0_2 = {}
  L1_2 = {}
  L1_1 = L1_2
  L0_1 = L0_2
  L0_2 = false
  L2_1 = L0_2
  L0_2 = L9_1
  L0_2()
end
L12_1.Clear = L13_1
L12_1 = History
function L13_1()
  local L0_2, L1_2
  L0_2 = L9_1
  L0_2()
end
L12_1.Sync = L13_1
L12_1 = History
function L13_1(A0_2)
  local L1_2, L2_2, L3_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L1_3 = #A0_3
    L2_3 = 1
    L3_3 = -1
    for L4_3 = L1_3, L2_3, L3_3 do
      L5_3 = A0_3[L4_3]
      L5_3 = L5_3.kind
      if "worldhide" == L5_3 then
        L5_3 = A0_3[L4_3]
        L5_3 = L5_3.entry
        L6_3 = A0_2
        if L5_3 == L6_3 then
          L5_3 = table
          L5_3 = L5_3.remove
          L6_3 = A0_3
          L7_3 = L4_3
          L5_3(L6_3, L7_3)
        end
      end
    end
  end
  L2_2 = L1_2
  L3_2 = L0_1
  L2_2(L3_2)
  L2_2 = L1_2
  L3_2 = L1_1
  L2_2(L3_2)
  L2_2 = L9_1
  L2_2()
end
L12_1.DropWorldHide = L13_1
L12_1 = Cmd
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = A0_2 or nil
  if A0_2 then
    L1_2 = Objects
    L1_2 = L1_2.IdByUid
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
  end
  if L1_2 then
    L2_2 = {}
    L2_2.kind = "add"
    L3_2 = Objects
    L3_2 = L3_2.Snapshot
    L4_2 = L1_2
    L3_2 = L3_2(L4_2)
    L2_2.snapshot = L3_2
    L3_2 = locale
    L4_2 = "hist.place"
    L3_2 = L3_2(L4_2)
    L2_2.label = L3_2
    if L2_2 then
      goto lbl_24
    end
  end
  L2_2 = nil
  ::lbl_24::
  return L2_2
end
L12_1.Add = L13_1
L12_1 = Cmd
function L13_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L1_2.kind = "delete"
  L1_2.snapshot = A0_2
  L2_2 = locale
  L3_2 = "hist.delete"
  L2_2 = L2_2(L3_2)
  L1_2.label = L2_2
  return L1_2
end
L12_1.Delete = L13_1
L12_1 = Cmd
function L13_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = {}
  L3_2.kind = "transform"
  L3_2.uid = A0_2
  L3_2.before = A1_2
  L3_2.after = A2_2
  L4_2 = locale
  L5_2 = "hist.move"
  L4_2 = L4_2(L5_2)
  L3_2.label = L4_2
  return L3_2
end
L12_1.Transform = L13_1
L12_1 = Cmd
function L13_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = {}
  L3_2.kind = "props"
  L3_2.uid = A0_2
  L3_2.before = A1_2
  L3_2.after = A2_2
  L4_2 = locale
  L5_2 = "hist.properties"
  L4_2 = L4_2(L5_2)
  L3_2.label = L4_2
  return L3_2
end
L12_1.Props = L13_1
L12_1 = Cmd
function L13_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = {}
  L3_2.kind = "replace"
  L3_2.uid = A0_2
  L3_2.before = A1_2
  L3_2.after = A2_2
  L4_2 = locale
  L5_2 = "hist.replace"
  L4_2 = L4_2(L5_2)
  L3_2.label = L4_2
  return L3_2
end
L12_1.Replace = L13_1
L12_1 = Cmd
function L13_1(A0_2, A1_2)
  local L2_2
  L2_2 = {}
  L2_2.kind = "batch"
  L2_2.items = A1_2
  L2_2.label = A0_2
  return L2_2
end
L12_1.Batch = L13_1
L12_1 = Cmd
function L13_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L1_2.kind = "worldhide"
  L1_2.entry = A0_2
  L2_2 = locale
  L3_2 = "hist.erase_prop"
  L2_2 = L2_2(L3_2)
  L1_2.label = L2_2
  return L1_2
end
L12_1.WorldHide = L13_1
L12_1 = Cmd
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = {}
  L2_2.kind = "light_add"
  L2_2.id = A0_2
  L2_2.data = A1_2
  L3_2 = locale
  L4_2 = "hist.light_add"
  L3_2 = L3_2(L4_2)
  L2_2.label = L3_2
  return L2_2
end
L12_1.LightAdd = L13_1
L12_1 = Cmd
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = {}
  L2_2.kind = "light_del"
  L2_2.id = A0_2
  L2_2.data = A1_2
  L3_2 = locale
  L4_2 = "hist.light_del"
  L3_2 = L3_2(L4_2)
  L2_2.label = L3_2
  return L2_2
end
L12_1.LightDel = L13_1
