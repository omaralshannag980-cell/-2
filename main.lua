-- // إعدادات الواجهة القابلة للسحب
local Player = game.Players.LocalPlayer
local RepStorage = game:GetService("ReplicatedStorage")
local ChatEvent = RepStorage:FindFirstChild("DefaultChatSystemChatEvents")
local SayRequest = ChatEvent and ChatEvent:FindFirstChild("SayMessageRequest") or RepStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")

local FakeTime = 120 -- القيمة الافتراضية

-- // إنشاء الواجهة الرئيسية (قابلة للسحب)
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 130)
Frame.Position = UDim2.new(0.5, -150, 0.5, -65)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true  -- خاصية السحب
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

-- العنوان
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⏳ تزييف وقت التشغيل"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- حقل الإدخال
local Input = Instance.new("TextBox", Frame)
Input.Size = UDim2.new(0, 160, 0, 45)
Input.Position = UDim2.new(0, 15, 0, 50)
Input.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.TextScaled = true
Input.PlaceholderText = "اكتب الرقم (مثل 200)"
Input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
Input.Font = Enum.Font.GothamMedium
Input.ClearTextOnFocus = false

-- زر التطبيق
local Apply = Instance.new("TextButton", Frame)
Apply.Size = UDim2.new(0, 100, 0, 45)
Apply.Position = UDim2.new(1, -115, 0, 50)
Apply.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
Apply.TextColor3 = Color3.fromRGB(0, 0, 0)
Apply.Text = "تطبيق"
Apply.TextScaled = true
Apply.Font = Enum.Font.GothamBold

-- زر الإغلاق
local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 5)
Close.BackgroundTransparency = 1
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.TextScaled = true
Close.Font = Enum.Font.GothamBold

ScreenGui.Parent = Player.PlayerGui

-- // دالة عرض الإشعار (يطلع بمنتصف الشاشة)
local function ShowFakeInfo()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "📊 [INFO] وقت السيرفر",
        Text = "🕒 الوقت الحالي: " .. FakeTime .. " ثانية (مزيف للفيديو)",
        Duration = 5  -- يكفي لتصوير 7 ثواني
    })
end

-- // اعتراض أمر ;info في الشات
SayRequest.OnClientEvent:Connect(function(Message, From)
    if From == Player and string.lower(Message) == ";info" then
        ShowFakeInfo()
        return -- نمنع إرسال الأمر للخادم عشان ما يظهر الوقت الحقيقي
    end
end)

-- // وظيفة زر التطبيق
Apply.MouseButton1Click:Connect(function()
    local Num = tonumber(Input.Text)
    if Num then
        FakeTime = Num
        _G.FakeUptime = Num -- للمتغيرات العامة إن وجدت
        Title.Text = "✅ الوقت: " .. Num .. " ثانية"
        ShowFakeInfo()
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ خطأ",
            Text = "أدخل أرقاماً فقط",
            Duration = 2
        })
    end
end)

-- // إغلاق الواجهة
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
