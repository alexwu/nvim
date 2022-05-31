vim.g.projectionist_heuristics = {
  ["app/lib/*.rb"] = {
    ["test"] = {
      "spec/lib/%s_spec.rb",
    },
  },
  ["app/controllers/*.rb"] = {
    ["test"] = {
      "spec/request/%s_spec.rb",
    },
  },
  ["lib/*.rb"] = {
    alternate = "spec/lib/%s_spec.rb",
    test = {
      "spec/lib/%s_spec.rb",
    },
  },
  ["spec/request/*_spec.rb"] = {
    alternate = "app/controllers/{}.rb",
    type = "source",
  },
  -- ["src/*"] = {
  ["*.ts"] = {
    alternate = {
      "{dirname}/{basename}.test.ts",
      "{dirname}/{dirname}.test.ts",
      "{dirname}/__tests__/{basename}.test.ts",
    },
    type = "source",
  },
  ["*.tsx"] = {
    alternate = {
      "{dirname}/{basename}.test.tsx",
      "{dirname}/{dirname}.test.tsx",
      "{dirname}/__tests__/{basename}.test.tsx",
    },
    type = "source",
  },
  ["*.test.ts"] = {
    alternate = {
      "{dirname}/{basename}.ts",
      "{dirname}/index.ts",
      "{dirname}/../{basename}.ts",
    },
    type = "test",
  },
  ["*.test.tsx"] = {
    alternate = {
      "{dirname}/{basename}.tsx",
      "{dirname}/index.tsx",
      "{dirname}/../{basename}.tsx",
    },
    type = "test",
  },
  -- },
  ["lua/*.lua"] = {
    type = "source",
    alternate = "tests/{dirname}/{basename}_spec.lua",
  },
  ["tests/*_spec.lua"] = {
    type = "type",
    alternate = "lua/{dirname}/{basename}.lua",
  },
}

-- nmap("<leader>av", [[:AV<cr>]], { silent = true })
-- nmap("<leader>as", [[:AS<cr>]], { silent = true })
-- nmap("<leader>ae", [[:A<cr>]], { silent = true })
