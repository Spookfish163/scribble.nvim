local M = {}

function M.str_to_pos(str)
	if str == "center" then
		return 11
	elseif str == "N" then
		return 10
	elseif str == "NW" then
		return 00
	elseif str == "NE" then
		return 20
	elseif str == "S" then
		return 12
	elseif str == "SW" then
		return 02
	elseif str == "SE" then
		return 22
	elseif str == "W" then
		return 01
	elseif str == "E" then
		return 21
	else
		return nil
	end
end

function M.pos_to_str(pos)
	if pos == 11 then
		return "center"
	elseif pos == 10 then
		return "N"
	elseif pos == 00 then
		return "NW"
	elseif pos == 20 then
		return "NE"
	elseif pos == 12 then
		return "S"
	elseif pos == 02 then
		return "SW"
	elseif pos == 22 then
		return "SE"
	elseif pos == 01 then
		return "W"
	elseif pos == 21 then
		return "E"
	else
		return nil
	end
end

return M
