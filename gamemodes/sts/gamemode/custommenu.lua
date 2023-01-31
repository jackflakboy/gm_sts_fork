local Menu

net.Receive("FMenu", function()
    if Menu == nil then
        Menu = vgui.Create("DFrame")
        Menu:SetSize(750, 500)
        Menu:SetPos(ScrW() / 2 - 325, ScrH() / 2 - 250)
        Menu:SetTitle("Gamemode Menu")
        Menu:SetDraggable(false)
        Menu:ShowCloseButton(true)
        Menu:SetDeleteOnClose(false)

        Menu.Paint = function()
            surface.SetDrawColor(60, 60, 60, 255)
            surface.DrawRect(0, 0, Menu:GetWide(), Menu:GetTall())
            surface.SetDrawColor(40, 40, 40, 255)
            surface.DrawRect(0, 24, Menu:GetWide(), 1)
        end
    end

    addButtons(Menu)

    if net.ReadBit() == 0 then
        Menu:Hide()
        gui.EnableScreenClicker(false)
    else
        Menu:Show()
        gui.EnableScreenClicker(true)
    end
end)

function addButtons(Menu)
    local blueButton = vgui.Create("DButton")
    blueButton:SetParent(Menu)
    blueButton:SetText("")
    blueButton:SetSize(Menu:GetWide(), 50)
    blueButton:SetPos(0, 25)

    blueButton.Paint = function()
        surface.SetDrawColor(30, 30, 255, 255)
        surface.DrawRect(0, 0, blueButton:GetWide(), blueButton:GetTall())
        draw.DrawText("Blue", "DermaDefaultBold", blueButton:GetWide() / 2, 17, Color(255, 255, 255, 255), 1)
    end

    blueButton.DoClick = function(blueButton)
        LocalPlayer():ConCommand("set_team " .. 1)
    end

    local redButton = vgui.Create("DButton")
    redButton:SetParent(Menu)
    redButton:SetText("")
    redButton:SetSize(Menu:GetWide(), 50)
    redButton:SetPos(0, 100)

    redButton.Paint = function()
        surface.SetDrawColor(255, 30, 30, 255)
        surface.DrawRect(0, 0, redButton:GetWide(), redButton:GetTall())
        draw.DrawText("Red", "DermaDefaultBold", redButton:GetWide() / 2, 17, Color(255, 255, 255, 255), 1)
    end

    redButton.DoClick = function(redButton)
        LocalPlayer():ConCommand("set_team " .. 2)
    end

    local greenButton = vgui.Create("DButton")
    greenButton:SetParent(Menu)
    greenButton:SetText("")
    greenButton:SetSize(Menu:GetWide(), 50)
    greenButton:SetPos(0, 175)

    greenButton.Paint = function()
        surface.SetDrawColor(0, 255, 0, 255)
        surface.DrawRect(0, 0, greenButton:GetWide(), greenButton:GetTall())
        draw.DrawText("Green", "DermaDefaultBold", greenButton:GetWide() / 2, 17, Color(255, 255, 255, 255), 1)
    end

    greenButton.DoClick = function(greenButton)
        LocalPlayer():ConCommand("set_team " .. 3)
    end

    local yellowButton = vgui.Create("DButton")
    yellowButton:SetParent(Menu)
    yellowButton:SetText("")
    yellowButton:SetSize(Menu:GetWide(), 50)
    yellowButton:SetPos(0, 250)

    yellowButton.Paint = function()
        surface.SetDrawColor(255, 255, 0, 255)
        surface.DrawRect(0, 0, yellowButton:GetWide(), yellowButton:GetTall())
        draw.DrawText("Yellow", "DermaDefaultBold", yellowButton:GetWide() / 2, 17, Color(0, 0, 0, 255), 1)
    end

    yellowButton.DoClick = function(yellowButton)
        LocalPlayer():ConCommand("set_team " .. 4)
    end
end