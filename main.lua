local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Chat = game:GetService("Chat")

local FakeLeave = ReplicatedStorage:FindFirstChild("FakeLeaveEvent")

-- دالة البحث عن اللاعب بأول 3 أحرف
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

-- ===== الدالة الأساسية (تغيير قراءة اللعبة) =====
local function FakeLeavePlayer(partialName)
    local matches = GetPlayerByPartial(partialName)
    
    if #matches == 0 then
        warn("❌ ما فيه لاعب يبدأ بـ: " .. partialName)
        return
    end
    
    if #matches > 1 then
        print("⚠️ فيه أكثر من لاعب: " .. table.concat(matches, ", "))
        return
    end
    
    local target = matches[1]
    
    -- 1. نرسل رسالة في الشات العام (زي خروج حقيقي)
    local fakeMessage = target.Name .. " left the game."
    Chat:Chat(workspace, fakeMessage) -- تظهر لجميع اللاعبين
    
    -- 2. نرسل حدث لكل اللاعبين عشان يعدلون واجهاتهم (يخفون اسمه)
    FakeLeave:FireAllClients(target.Name)
    
    print("✅ تم إيهام الجميع بأن " .. target.Name .. " طلع من الشات والقوائم، وهو باقي!")
end

-- ===== طريقة التشغيل (اكتبها في Console) =====
-- مثال: اكتب أول 3 حروف
FakeLeavePlayer("أحم")
-- FakeLeavePlayer("سا")
