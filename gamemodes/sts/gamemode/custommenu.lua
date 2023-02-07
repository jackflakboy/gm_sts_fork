local customMenu

net.Receive("FMenu", function()
    if customMenu == nil then
        customMenu = vgui.Create("DFrame")
        customMenu:SetSize(750, 500)
        customMenu:SetPos(ScrW() / 2 - 325, ScrH() / 2 - 250)
        customMenu:SetTitle("Gamemode Menu")
        customMenu:SetDraggable(false)
        customMenu:ShowCloseButton(true)
        customMenu:SetDeleteOnClose(false)

        customMenu.Paint = function()
            surface.SetDrawColor(60, 60, 60, 255)
            surface.DrawRect(0, 0, customMenu:GetWide(), customMenu:GetTall())
            surface.SetDrawColor(40, 40, 40, 255)
            surface.DrawRect(0, 24, customMenu:GetWide(), 1)
        end
    end

    addButtons(customMenu)

    if net.ReadBit() == 0 then
        customMenu:Hide()
        gui.EnableScreenClicker(false)
    else
        customMenu:Show()
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

    blueButton.DoClick = function()
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

    redButton.DoClick = function()
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

    greenButton.DoClick = function()
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

    yellowButton.DoClick = function()
        LocalPlayer():ConCommand("set_team " .. 4)
    end
end