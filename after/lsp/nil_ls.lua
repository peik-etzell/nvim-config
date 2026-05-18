return {
    settings = {
        ['nil'] = {
            nix = {
                flake = { autoArchive = true },
            },
            formatting = {
                command = { 'nixfmt' },
            },
        },
    },
}
