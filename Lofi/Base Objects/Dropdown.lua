local partsWithId = {}
local awaitRef = {}

local root = {
	ID = 0;
	Type = "TextButton";
	Properties = {
		FontSize = Enum.FontSize.Size14;
		TextColor3 = Color3.new(0,0,0);
		BorderColor3 = Color3.new(58/255,58/255,58/255);
		Text = "";
		AutoButtonColor = false;
		Font = Enum.Font.SourceSans;
		Name = "Dropdown";
		Position = UDim2.new(0,0,0.26666668057442,0);
		Size = UDim2.new(1,0,0,55);
		TextSize = 14;
		BorderSizePixel = 0;
		BackgroundColor3 = Color3.new(7/51,7/51,7/51);
	};
	Children = {
		{
			ID = 1;
			Type = "TextLabel";
			Properties = {
				FontSize = Enum.FontSize.Size14;
				TextColor3 = Color3.new(1,1,1);
				BorderColor3 = Color3.new(58/255,58/255,58/255);
				Text = "Options";
				TextXAlignment = Enum.TextXAlignment.Left;
				BackgroundTransparency = 1;
				Font = Enum.Font.Gotham;
				Name = "Label";
				Position = UDim2.new(0,15,0,5);
				Size = UDim2.new(1,-30,0,15);
				TextSize = 13;
				BorderSizePixel = 0;
				BackgroundColor3 = Color3.new(7/51,7/51,7/51);
			};
			Children = {};
		};
		{
			ID = 2;
			Type = "ImageLabel";
			Properties = {
				ImageColor3 = Color3.new(26/255,26/255,26/255);
				ScaleType = Enum.ScaleType.Slice;
				Name = "Background";
				Image = "rbxassetid://3570695787";
				BackgroundTransparency = 1;
				Position = UDim2.new(0,15,0,25);
				SliceScale = 0.03999999910593;
				Size = UDim2.new(1,-30,0,25);
				BackgroundColor3 = Color3.new(1,1,1);
				SliceCenter = Rect.new(Vector2.new(100,100),Vector2.new(100,100));
			};
			Children = {};
		};
		{
			ID = 3;
			Type = "TextLabel";
			Properties = {
				FontSize = Enum.FontSize.Size14;
				TextColor3 = Color3.new(1,1,1);
				Text = "Selected";
				TextXAlignment = Enum.TextXAlignment.Left;
				Font = Enum.Font.Gotham;
				Name = "Value";
				Position = UDim2.new(0,30,0,25);
				BackgroundTransparency = 1;
				Size = UDim2.new(1,-30,0,25);
				TextSize = 14;
				BackgroundColor3 = Color3.new(1,1,1);
			};
			Children = {};
		};
		{
			ID = 4;
			Type = "Frame";
			Properties = {
				Visible = false;
				ClipsDescendants = true;
				BorderColor3 = Color3.new(58/255,58/255,58/255);
				Name = "Options";
				Position = UDim2.new(0,15,0,50);
				Size = UDim2.new(1,-30,0,0);
				ZIndex = 2;
				BorderSizePixel = 0;
				BackgroundColor3 = Color3.new(26/255,26/255,26/255);
			};
			Children = {
				{
					ID = 5;
					Type = "UIListLayout";
					Properties = {
						SortOrder = Enum.SortOrder.LayoutOrder;
					};
					Children = {};
				};
			};
		};
	};
};

local function Scan(item, parent)
	local obj = Instance.new(item.Type)
	if (item.ID) then
		local awaiting = awaitRef[item.ID]
		if (awaiting) then
			awaiting[1][awaiting[2]] = obj
			awaitRef[item.ID] = nil
		else
			partsWithId[item.ID] = obj
		end
	end
	for p,v in pairs(item.Properties) do
		if (type(v) == "string") then
			local id = tonumber(v:match("^_R:(%w+)_$"))
			if (id) then
				if (partsWithId[id]) then
					v = partsWithId[id]
				else
					awaitRef[id] = {obj, p}
					v = nil
				end
			end
		end
		obj[p] = v
	end
	for _,c in pairs(item.Children) do
		Scan(c, obj)
	end
	obj.Parent = parent
	return obj
end

return function() return Scan(root, nil) end