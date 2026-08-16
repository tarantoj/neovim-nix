# Neovim Keymap Cheatsheet

Leader key is `Space`. `<leader>` below means `Space`.

## Essentials (default Neovim)

| Key | Action |
|---|---|
| `i`, `a`, `o`, `I`, `A`, `O` | enter insert mode |
| `v`, `V`, `<C-v>` | visual / line-visual / block-visual |
| `dd`, `yy`, `p`, `P`, `x`, `r` | delete/yank/paste line, replace char |
| `u`, `<C-r>` | undo / redo |
| `.` | repeat last change |
| `w`, `b`, `e`, `0`, `$`, `gg`, `G` | word / line / buffer navigation |
| `%` | jump to matching bracket |
| `f`/`t`, `F`/`T`, `;`/`,` | find / move to char, repeat |
| `ciw`, `diw`, `ci(`, `da"`, ... | built-in textobjects (still work; mini.ai extends these) |
| `*`, `#`, `/`, `?`, `n`, `N` | search (results are centered, `n`/`N` keep view) |
| `<Esc>` | clear search highlight |
| `<C-d>`, `<C-u>` | scroll half-page (cursor centered) |
| `<C-w>s`, `<C-w>v`, `<C-w>q`, `<C-w>h/j/k/l` | split windows / navigate |
| `gt`, `gT` | next / previous tab page |
| `m<x>` then `'x` | set mark / jump to mark |
| `za`, `zo`, `zc` | toggle / open / close fold (treesitter folds) |
| `J`, `K` (visual) | move selection down / up |
| `j`, `k` | wrap-aware movement |
| `:w`, `:q`, `:wq` (also `W`, `Wq`, `Q`) | save / quit |
| `-` | open Oil file explorer (parent dir) |
| `<leader>-` | open Oil at project root |

## Buffer commands

| Key | Action |
|---|---|
| `<leader><leader>[` / `]` | previous / next buffer |
| `<leader><leader>l` | jump to last buffer |
| `<leader><leader>d` | delete buffer (keeps window layout) |
| `[b` / `]b`, `[B` / `]B` | prev / next buffer, first / last (mini.bracketed) |
| `<C-^>` | alternate buffer |
| `gt`/`gT` | prev / next tab page |

## Clipboard

| Key | Action |
|---|---|
| `<leader>y` | yank to system clipboard |
| `<leader>Y` | yank line to clipboard |
| `<leader>p` | paste from clipboard |
| `<leader>P` (visual) | paste over selection (no clobber) |
| `<C-p>` (insert) | paste from clipboard |
| `<C-a>` | select all |

## LSP

| Key | Action |
|---|---|
| `gd`, `gD`, `gI`, `gr` | definition / declaration / implementation / references |
| `<leader>D` | type definition |
| `K` | hover |
| `<C-k>` | signature help |
| `<leader>rn` | rename |
| `<leader>ca` | code action |
| `<leader>ds`, `<leader>ws` | document / workspace symbols |
| `<leader>wa`, `<leader>wr`, `<leader>wl` | workspace folders |
| `<leader>th` | toggle inlay hints |
| `[d` / `]d`, `[D` / `]D` | prev / next diagnostic (float opens) |
| `<leader>e` | open floating diagnostic |
| `<leader>q` | diagnostics to location list |
| `:Format` | format buffer via LSP |

## Search (Telescope)

| Key | Action |
|---|---|
| `<leader>sf` | find files |
| `<leader>sg` | live grep |
| `<leader>sp` | live grep in git root |
| `<leader>sw` | grep word under cursor |
| `<leader>s/` | grep in open files |
| `<leader>sd` | diagnostics |
| `<leader>ss` | telescope pickers list |
| `<leader>sk` | keymaps |
| `<leader>sh` | help tags |
| `<leader>sr` | resume last picker |
| `<leader>s.` | recent files |
| `<leader>sM` | notifications |
| `<leader><leader>s` | buffers |
| `<leader>/` | fuzzy find in current buffer |
| `<C-enter>` | fuzzy refine in picker |

## Git

| Key | Action |
|---|---|
| `<leader>gs`, `<leader>gr` | stage / reset hunk |
| `<leader>gS`, `<leader>gR` | stage / reset buffer |
| `<leader>gu` | undo stage hunk |
| `<leader>gp` | preview hunk |
| `<leader>gb` | blame line |
| `<leader>gd`, `<leader>gD` | diff against index / last commit |
| `<leader>gtb`, `<leader>gtd` | toggle blame / deleted lines |
| `<leader>hs`, `<leader>hr` (visual) | stage / reset hunk |
| `ih` (operator) | select hunk |
| `<leader>gdo`, `<leader>gdh`, `<leader>gdc` | diffview: open / history / close |
| `:G`... | fugitive (e.g. `:G blame`, `:GBrowse`) |

## Diagnostics / Lists (Trouble)

| Key | Action |
|---|---|
| `<leader>xx` | toggle diagnostics |
| `<leader>xX` | buffer diagnostics |
| `<leader>cs` | document symbols |
| `<leader>cl` | LSP references / definitions |
| `<leader>xL`, `<leader>xQ` | location / quickfix list |
| `<leader>st`, `<leader>xt` | search / list TODO comments |

## Testing (Neotest)

| Key | Action |
|---|---|
| `<leader>tt` | run current file |
| `<leader>tT` | run all tests |
| `<leader>tr` | run nearest test |
| `<leader>tl` | run last test |
| `<leader>ts` | toggle summary |
| `<leader>to`, `<leader>tO` | output / output panel |
| `<leader>tS` | stop |
| `<leader>tw` | toggle watch mode |

## Debugging (DAP)

| Key | Action |
|---|---|
| `<F5>` | start / continue |
| `<F1>`, `<F2>`, `<F3>` | step into / over / out |
| `<F7>` | toggle DAP UI |
| `<leader>b` | toggle breakpoint |
| `<leader>B` | conditional breakpoint |

## Formatting

| Key | Action |
|---|---|
| `<leader>FF` | format file (conform, LSP fallback) |
| — | auto-format on save (stylua / prettier / alejandra) |

## mini.nvim

| Key | Action |
|---|---|
| `a<i>` / `i<i>` | textobjects: `i(`, `af`, `it`, `a"`, `aa`, `a?`, ... |
| `g[` / `g]` | move to left / right edge of textobject |
| `[c`/`]c`, `[C`/`]C` | prev / next comment |
| `[t`/`]t`, `[T`/`]T` | prev / next treesitter node |
| `[w`/`]w`, `[W`/`]W` | prev / next window |
| `[q`/`]q`, `[l`/`]l` | quickfix / location list |
| `[i`/`]i`, `[j`/`]j`, `[o`/`]o`, `[y`/`]y`, `[x`/`]x`, `[f`/`]f`, `[u`/`]u` | indent / jump / old file / yank / conflict / file / undo navigation |
| `<M-h/j/k/l>` | move line / selection |
| `gcc`, `gc<motion>` | toggle comment |
| `sa<motion><char>`, `sd<char>`, `sr<char>` | surround: add / delete / replace |
| `s<char>` (visual) | add surround to selection |
| `(`, `)`, `[`, `]`, `{`, `}`, `"`, `'`, `` ` `` | auto-paired in insert mode (mini.pairs) |
| tabline | clickable buffer tabs, current buffer centered |

## Completion (blink.cmp)

| Key | Action |
|---|---|
| `<C-y>` | accept suggestion |
| `<C-n>` / `<C-p>` | next / previous |
| `<C-Space>` | trigger manually |
| `<M-n>` (in snippet) | next choice |

## Misc

| Key | Action |
|---|---|
| `<leader>U` | undo tree |
| `<leader>ng` | generate doc comment (neogen) |
| `<leader>qs`, `<leader>ql`, `<leader>qd` | persistence: restore / last session / stop |
| `<leader>mp`, `<leader>ms`, `<leader>mt` | markdown preview: open / stop / toggle |
| `:StartupTime` | startup profiling |

Discover more with `<leader>sk` (search keymaps) or `<leader>ss`.
