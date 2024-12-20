local clipboardGroup = vim.api.nvim_create_augroup("clipboardGroup", { clear = true })
local is_server = true
local port = 2000

local uv = vim.loop
if is_server == true then
	local server = uv.new_tcp()
	local host = "127.0.0.1"

	server:bind(host, port)

	server:listen(128, function(err)
		if err then
			print("error starting listener:", err)
			return
		end

		LocalHandle = uv.new_tcp()
		server:accept(LocalHandle)

		print("client connected")

		LocalHandle:read_start(function(read_err, data)
			if read_err then
				print("error reading from client:", read_err)
				LocalHandle:close()
			elseif data then
				vim.schedule(function()
					vim.fn.setreg('"0', data)
					vim.fn.system(string.format("echo %s | pbcopy ", vim.fn.shellescape(data)))
				end)
			else
				print("client disconnected")
				LocalHandle:close()
			end
		end)
	end)
else
	RemoteHandle = uv.new_tcp()
	RemoteHandle:connect("127.0.0.1", port, function(err)
		if err then
			print("error connecting to server:", err)
			return
		end

		print("connected to server")

		RemoteHandle:read_start(function(read_err, data)
			if read_err then
				print("error reading from client:", read_err)
				RemoteHandle:close()
			elseif data then
				vim.schedule(function()
					vim.fn.setreg('"0', data)
				end)
			else
				print("client disconnected")
				RemoteHandle:close()
			end
		end)
	end)
end

-- Autocommand to send over yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = clipboardGroup,
	callback = function()
		print("callback triggered")
		vim.schedule(function()
			local register = vim.fn.getreg('"0')
			if is_server == true then
				LocalHandle:write(register)
			end
			if is_server == false then
				RemoteHandle:write(register)
			end
		end)
	end,
})
