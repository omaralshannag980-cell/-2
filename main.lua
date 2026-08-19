-- سكربت الخادم (المشغل)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Chat = game:GetService("Chat")

local FakeLeave = ReplicatedStorage:FindFirstChild("FakeLeaveEvent")
if not FakeLeave then return end

-- دالة البحث عن اللاعب بأول 3 أحرف (أو أكثر)
local function GetPlayerByPartial(partial)
    partial = partial:lower()
    local matches = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.sub(plr.Name:lower(), 1, #partial) == partial then
            table.insert(matches, plr)
        end
    end
    return matches
end

-- ===== الدالة الأساسية =====
local function FakeLeavePlayer(partialName)
    local matches = GetPlayerByPartial(partialName)
    
    if #matches == 0 then
        warn("❌ ما فيه لاعب يبدأ بـ: " .. partialName)
        return
    end
    
    if #matches > 1 then
        print("⚠️ فيه أكثر من لاعب يطابق:")
        for i, p in ipairs(matches) do
            print(i .. ". " .. p.Name)
        end
        return
    end
    
    local target = matches[1]
    
    -- 1. رسالة شات مزيفة (تظهر للكل)
    Chat:Chat(workspace, target.Name .. " left the game.")
    
    -- 2. نرسل حدث لكل اللاعبين عشان يعدلون الـ GUI الخاص بنا
    FakeLeave:FireAllClients(target.Name)
    
    print("✅ تم إيهام الكل بأن " .. target.Name .. " طلع من القائمة والشات!")
end

-- ===== طريقة التشغيل (اكتبها في Console الخادم) =====
-- مثال: اكتب أول 3 حروف من اسم اللاعب
FakeLeavePlayer("أحم")
-- FakeLeavePlayer("سا")
