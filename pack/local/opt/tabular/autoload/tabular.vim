vim9script
# autoload/tabular.vim — align columns of text on a delimiter pattern.
# Modelled on godlygeek/tabular: same command syntax and alignment rules.

# ── Named patterns ───────────────────────────────────────────────────────────
# `:Tabularize name` looks the name up in b:tabular_patterns, then
# g:tabular_patterns, then here. A value is '/pattern[/format]'; the optional
# 'squeeze' entry collapses runs matching it to its 'to' string first.
const builtin: dict<dict<string>> = {
    assignment:          {cmd: '/[|&+*/%<>=!~-]\@<!\([<>!=]=\|=\~\)\@![|&+*/%<>=!~-]*=/l1r1'},
    two_spaces:          {cmd: '/  /l0'},
    multiple_spaces:     {cmd: '/  /l0', squeeze: '   *', to: '  '},
    spaces:              {cmd: '/ /l0', squeeze: '  *', to: ' '},
    ternary_operator:    {cmd: '/^.\{-}\zs?\|:/l1'},
    cpp_io:              {cmd: '/<<\|>>/l1'},
    pascal_assign:       {cmd: '/:=/l1'},
    trailing_c_comments: {cmd: '/\/\*\|\*\/\|\/\//l1'},
}

const format_elem = '\%([lrc]\d\+\)'
var last_command = ''

def Lookup(name: string): dict<string>
    for scope in [get(b:, 'tabular_patterns', {}), get(g:, 'tabular_patterns', {})]
        if has_key(scope, name)
            const v = scope[name]
            return type(v) == v:t_string ? {cmd: v} : v
        endif
    endfor
    return get(builtin, name, {})
enddef

export def Complete(lead: string, ..._): list<string>
    const names = keys(builtin) + keys(get(g:, 'tabular_patterns', {}))
        + keys(get(b:, 'tabular_patterns', {}))
    return sort(uniq(sort(filter(names, (_, n) => n =~# '^' .. lead))))
enddef

# '/pat/l1r0' → ['pat', 'l1r0']. The pattern may itself contain '/', so only a
# trailing, unescaped '/<format>' counts as the format.
export def ParsePattern(cmd: string): list<string>
    if cmd[0] != '/'
        return ['', '']
    endif
    const body = cmd[1 :]
    const fmt = matchstr(body, '\\\@<!\%(\\\\\)\{-}\zs/' .. format_elem .. '*$')
    if empty(fmt)
        return [body, '']
    endif
    return [strpart(body, 0, len(body) - len(fmt)), fmt[1 :]]
enddef

# ── Splitting and padding ────────────────────────────────────────────────────

# 'a=b=c' on '=' → ['a', '=', 'b', '=', 'c']: text fields at even indexes,
# delimiters at odd ones. Zero-width matches split without consuming text.
export def SplitDelim(str: string, delim: string): list<string>
    var fields: list<string> = []
    var beg = 0
    var off = 0
    while true
        const mid = match(str, delim, beg + off)
        if mid == -1 || mid == len(str)
            break
        endif
        const m = matchstr(str, delim, beg + off)
        if empty(m) && mid == beg
            off += 1
            continue
        endif
        fields->add(strpart(str, beg, mid - beg))->add(m)
        beg = mid + len(m)
        off = 0
    endwhile
    return fields->add(strpart(str, beg))
enddef

def Pad(field: string, how: string, width: number): string
    const spaces = width - strdisplaywidth(field)
    if how ==? 'r'
        return matchstr(field, '^\s*') .. repeat(' ', spaces) .. substitute(field, '^\s*', '', '')
    elseif how ==? 'c'
        const right = spaces / 2
        return repeat(' ', spaces - right) .. field .. repeat(' ', right)
    endif
    return field .. repeat(' ', spaces)
enddef

def CommonIndent(lines: list<string>): string
    if empty(lines)
        return ''
    endif
    var n = 0
    while join(mapnew(lines, (_, l) => l[n]), '') =~ '^ \+$\|^\t\+$'
        n += 1
    endwhile
    return strpart(lines[0], 0, n)
enddef

# Align {lines} on {delim}. {format} is a run of [lrc]<pad> elements applied
# cyclically to text and delimiter fields alike ('l1' = left-align, one
# space after). With {only_matching}, lines without a delimiter are left
# alone and don't count towards column widths.
export def Align(lines: list<string>, delim: string, format = '', only_matching = false): list<string>
    const fmtstr = empty(format) ? get(g:, 'tabular_default_format', 'l1') : format
    if fmtstr !~? '^' .. format_elem .. '\+$'
        throw 'Tabular: invalid format "' .. fmtstr .. '"'
    endif
    const fmt = split(fmtstr, format_elem .. '\zs')

    var rows = mapnew(lines, (_, l) => SplitDelim(l, delim))
    const Skip = (row: list<string>) => only_matching && len(row) == 1

    var firsts: list<string> = []
    for row in rows
        if Skip(row)
            continue
        endif
        firsts->add(row[0])
        for i in range(0, len(row) - 1, 2)
            row[i] = trim(row[i])
        endfor
    endfor
    const indent = CommonIndent(firsts)

    var widths: list<number> = []
    for row in rows
        if Skip(row)
            continue
        endif
        for i in range(len(row))
            const w = strdisplaywidth(row[i])
            if i == len(widths)
                widths->add(w)
            elseif w > widths[i]
                widths[i] = w
            endif
        endfor
    endfor

    var out: list<string> = []
    for row in rows
        if Skip(row)
            out->add(row[0])
            continue
        endif
        var line = indent
        for i in range(len(row))
            const elem = fmt[i % len(fmt)]
            line ..= Pad(row[i], elem[0], widths[i]) .. repeat(' ', str2nr(elem[1 :]))
        endfor
        out->add(substitute(line, '\s*$', '', ''))
    endfor
    return out
enddef

# ── Commands ─────────────────────────────────────────────────────────────────

# :[range]Tabularize[ /pattern[/format] | name ]
# Without a range, aligns the block of adjacent lines around the cursor that
# match the pattern. Without arguments, repeats the last command.
export def Tabularize(args: string, line1: number, line2: number, has_range: bool, global = false)
    var cmd = trim(args)
    if empty(cmd)
        if empty(last_command)
            echohl WarningMsg | echomsg 'Tabularize: no previous pattern' | echohl None
            return
        endif
        cmd = last_command
    endif
    last_command = cmd

    var spec: dict<string> = cmd[0] == '/' ? {cmd: cmd} : Lookup(cmd)
    if empty(spec)
        echohl ErrorMsg | echomsg 'Tabularize: unknown pattern ' .. string(cmd) | echohl None
        return
    endif
    const [pattern, format] = ParsePattern(spec.cmd)
    if empty(pattern)
        echohl ErrorMsg | echomsg 'Tabularize: empty pattern' | echohl None
        return
    endif

    var top = line1
    var bot = line2
    if !global && !has_range
        if getline(top) !~ pattern
            return
        endif
        while top > 1 && getline(top - 1) =~ pattern
            top -= 1
        endwhile
        while bot < line('$') && getline(bot + 1) =~ pattern
            bot += 1
        endwhile
    endif

    var lines = getline(top, bot)
    if has_key(spec, 'squeeze')
        map(lines, (_, l) => substitute(l, spec.squeeze, spec.to, 'g'))
    endif
    const aligned = Align(lines, pattern, format, global)
    if aligned != getline(top, bot)
        setline(top, aligned)
    endif
enddef
