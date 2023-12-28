import Lake
open Lake DSL

package «prg» where
  -- add package configuration options here

-- lean_lib «Prg» where
  -- add library configuration options here

@[default_target]
lean_exe «prg» where
  root := `prg
