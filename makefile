.PHONY: update restore

update:
	nvim -c "lua vim.pack.update()"

restore:
	nvim -c "lua vim.pack.update(nil, { target = 'lockfile' })"

