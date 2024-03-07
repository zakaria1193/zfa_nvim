require'lspconfig'.robotframework_ls.setup{robot ={
      lint = {robocop = {enabled = true}},
      variables = {execdir = os.getenv('PWD')},
      pythonpath = {
        "/home/zfadli/repos/embedded/magellan/modules/automated-test-tools/python/lib",
        "/home/zfadli/repos/embedded/magellan/modules/python-emb-tools/python/lib/",
        "/home/zfadli/repos/embedded/magellan/modules/embedded_farm/python/lib",
        "/home/zfadli/repos/embedded/magellan/python/lib",
        "/home/zfadli/.local/lib/python3.10/site-packages/"
      },
}}
