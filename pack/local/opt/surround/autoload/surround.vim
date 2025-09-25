vim9script
# autoload/surround.vim — add, change and delete surroundings.
# Modelled on tpope/vim-surround: same mappings, targets and replacements.
#
# ds/cs/ys all run as operators (g@), so `.` repeats them natively: the keys
# typed after the operator are read once and kept in `pending`, and a
# repeat finds them there instead of prompting again.

# ── Pending operation ────────────────────────────────────────────────────────
# kind: 'ds' | 'cs' | 'cS' | 'ys' | 'yS'; fresh: no keys read yet;
# target/count: what ds/cs act on; char/input: the replacement and the answer
# to its prompt (tag or function name).
var pending: dict<any> = {}
var last_tag = ''

# Called from an <expr> mapping: remember what to do, then hand over to g@.
export def Setup(kind: string): string
    pending = {kind: kind, fresh: true, count: v:count1, target: '', char: '', input: ''}
    &operatorfunc = 'surround#Operator'
    return 'g@'
enddef

# ── Reading keys ─────────────────────────────────────────────────────────────

def ReadChar(): string
    const c = getcharstr()
    return c == "\<Esc>" || c == "\<C-C>" ? '' : c
enddef

# A target may be prefixed with a count: ds2( deletes the second-level ( ).
def ReadTarget(): list<any>
    var digits = ''
    var c = ReadChar()
    while c =~ '^\d$'
        digits ..= c
        c = ReadChar()
    endwhile
    return [empty(digits) ? 1 : str2nr(digits), c]
enddef

# ── Replacements ─────────────────────────────────────────────────────────────

const pairs = {
    b: ['(', ')'], ')': ['(', ')'], '(': ['( ', ' )'],
    B: ['{', '}'], '}': ['{', '}'], '{': ['{ ', ' }'],
    r: ['[', ']'], ']': ['[', ']'], '[': ['[ ', ' ]'],
    a: ['<', '>'], '>': ['<', '>'],
}

# The [before, after] text {char} wraps with, or [] when cancelled. {removed}
# is the opening delimiter being replaced (its tag attributes are kept);
# {input} answers the prompt when repeating.
def Delims(char: string, removed: string, input: string): list<string>
    const custom = get(b:, 'surround_' .. char2nr(char), get(g:, 'surround_' .. char2nr(char), ''))
    if !empty(custom)
        const parts = split(custom, "\r", true)
        return [parts[0], get(parts, 1, '')]
    elseif has_key(pairs, char)
        return pairs[char]
    elseif char =~# '^[tT<]$'
        var tag = input
        if empty(tag)
            const default = char ==# 'T' ? matchstr(last_tag, '^<\zs[^ \t\n>]*') : ''
            tag = input('<', default)
            if empty(tag)
                return []
            endif
        endif
        pending.input = tag
        const attrs = tag =~ '>$' ? '' : matchstr(removed, '^<[^ \t\n>]\+\zs\_.\{-\}\ze/\=>$')
        const name = substitute(tag, '>*$', '', '')
        if name =~ '/$'
            return ['<' .. substitute(name, '/$', '', '') .. attrs .. ' />', '']
        endif
        return ['<' .. name .. attrs .. '>', '</' .. matchstr(name, '^\S*') .. '>']
    elseif char ==# 'f' || char ==# 'F'
        var fn = input
        if empty(fn)
            fn = input('function: ')
            if empty(fn)
                return []
            endif
        endif
        pending.input = fn
        const sp = char ==# 'F' ? ' ' : ''
        return [substitute(fn, '($', '', '') .. '(' .. sp, sp .. ')']
    elseif char =~ '^\p$' && char !~ '\a'
        return [char, char]
    endif
    return []
enddef

# ── Buffer edits ─────────────────────────────────────────────────────────────

def IndentUnit(): string
    return &expandtab ? repeat(' ', shiftwidth()) : "\t"
enddef

# Replace bytes {sc}..{ec} (inclusive, 1-based) spanning lines {sl}..{el}
# with {text}, which may contain newlines. A single undoable change.
def Replace(sl: number, sc: number, el: number, ec: number, text: string)
    const prefix = strpart(getline(sl), 0, sc - 1)
    const suffix = strpart(getline(el), ec)
    SetLines(sl, el, split(prefix .. text .. suffix, "\n", true))
enddef

def SetLines(sl: number, el: number, lines: list<string>)
    const n = el - sl + 1
    if len(lines) >= n
        setline(sl, lines[: n - 1])
        if len(lines) > n
            append(el, lines[n :])
        endif
    else
        setline(sl, lines)
        deletebufline('%', sl + len(lines), el)
    endif
enddef

def Reindent(sl: number, el: number)
    if !get(b:, 'surround_indent', get(g:, 'surround_indent', true))
        return
    endif
    if !empty(&equalprg) || !empty(&indentexpr) || &cindent || &smartindent || &lisp
        execute $'silent keepjumps normal! {sl}G={el}G'
    endif
enddef

def StripCommonIndent(lines: list<string>): list<string>
    const indents = mapnew(filter(copy(lines), (_, l) => l =~ '\S'), (_, l) => strdisplaywidth(matchstr(l, '^\s*')))
    const n = empty(indents) ? 0 : min(indents)
    return mapnew(lines, (_, l) => substitute(l, '^\s\{,' .. n .. '}', '', ''))
enddef

# {text} wrapped in {d} with the delimiters on lines of their own and the
# body one indent level deeper, all under {indent}.
def WrapLines(text: string, d: list<string>, indent: string, deeper: bool): list<string>
    const unit = deeper ? IndentUnit() : ''
    const body = mapnew(StripCommonIndent(split(text, "\n", true)),
        (_, l) => l =~ '\S' ? indent .. unit .. l : '')
    var out = [indent .. trim(d[0], ' ', 2)] + body
    if !empty(d[1])
        out->add(indent .. trim(d[1], ' ', 1))
    endif
    return out
enddef

# ── Finding a target ─────────────────────────────────────────────────────────
# Returns {sl, sc, el, ec, open, inner, close} for the {count}th surrounding
# {char} around the cursor, or {} when there is none.

def ByTextObject(keys: string, open: string, close: string): dict<any>
    const view = winsaveview()
    const marks = [getpos("'<"), getpos("'>")]
    const sel = &selection
    &selection = 'inclusive'
    setpos("'<", getpos('.'))
    setpos("'>", getpos('.'))
    execute "silent! normal! \<Esc>v" .. keys .. "\<Esc>"
    const [s, e] = [getpos("'<"), getpos("'>")]
    &selection = sel
    setpos("'<", marks[0])
    setpos("'>", marks[1])
    winrestview(view)

    if s == e
        return {}
    endif
    const pos = getregionpos(s, e, {type: 'v', exclusive: false})
    const whole = join(getregion(s, e, {type: 'v', exclusive: false}), "\n")
    const o = open ==# 't' ? matchstr(whole, '^<[^>]*>') : whole[0]
    const c = open ==# 't' ? matchstr(whole, '</[^>]*>$') : whole[-1 :]
    if empty(o) || empty(c) || (open !=# 't' && (o !=# open || c !=# close))
        return {}
    endif
    return {sl: s[1], sc: pos[0][0][2], el: e[1], ec: pos[-1][1][2], open: o, close: c,
        inner: strpart(whole, len(o), len(whole) - len(o) - len(c))}
enddef

# Punctuation pairs such as *…* or |…| on the cursor line.
def ByChar(char: string): dict<any>
    const line = getline('.')
    const cur = col('.') - 1
    var left = strridx(line, char, cur)
    var right = left < 0 ? -1 : stridx(line, char, left + 1)
    if right < 0 && left == cur
        right = cur
        left = strridx(line, char, cur - 1)
    endif
    if left < 0 || right < 0
        return {}
    endif
    return {sl: line('.'), sc: left + 1, el: line('.'), ec: right + 1, open: char, close: char,
        inner: strpart(line, left + 1, right - left - 1)}
enddef

def Find(char: string, count: number): dict<any>
    const c = get({a: '>', r: ']'}, char, char)
    const closing = {'(': ')', ')': ')', b: ')', '{': '}', '}': '}', B: '}', '[': ']', ']': ']', '<': '>', '>': '>'}
    if has_key(closing, c)
        const open = {')': '(', '}': '{', ']': '[', '>': '<'}[closing[c]]
        return ByTextObject(count .. 'a' .. c, open, closing[c])
    elseif c ==# 't'
        return ByTextObject(count .. 'at', 't', '')
    elseif c =~ "^[\"'`]$"
        return ByTextObject('2i' .. c, c, c)
    elseif c =~ '^[[:punct:]]$'
        return ByChar(c)
    endif
    return {}
enddef

# Open delimiter ends its line and close delimiter starts one: a block like
#   if (x) {
#       body
#   }
def IsBlock(t: dict<any>): bool
    return t.inner =~ '^[ \t]*\n' && t.inner =~ '\n\s*$'
enddef

def BlockBody(t: dict<any>): list<string>
    return split(substitute(substitute(t.inner, '^[ \t]*\n', '', ''), '\n\s*$', '', ''), "\n", true)
enddef

# ── Operations ───────────────────────────────────────────────────────────────

def Delete(t: dict<any>, char: string)
    if IsBlock(t)
        const before = substitute(strpart(getline(t.sl), 0, t.sc - 1), '\s*$', '', '')
        const after = substitute(strpart(getline(t.el), t.ec), '^\s*', '', '')
        const indent = matchstr(getline(t.el), '^\s*')
        const lines = (before =~ '\S' ? [before] : []) + BlockBody(t)
            + (after =~ '\S' ? [indent .. after] : [])
        SetLines(t.sl, t.el, lines)
        Reindent(t.sl, t.sl + len(lines) - 1)
    else
        Replace(t.sl, t.sc, t.el, t.ec, char =~ '^[([{<]$' ? trim(t.inner) : t.inner)
    endif
    cursor(t.sl, t.sc)
enddef

def Change(t: dict<any>, char: string, d: list<string>, lines: bool)
    const indent = matchstr(getline(t.sl), '^\s*')
    if lines
        const body = IsBlock(t) ? join(BlockBody(t), "\n") : trim(t.inner)
        const wrapped = WrapLines(body, d, indent, true)
        Replace(t.sl, t.sc, t.el, t.ec, join(wrapped, "\n")[len(indent) :])
        Reindent(t.sl, t.sl + len(wrapped) - 1)
    elseif IsBlock(t)
        Replace(t.sl, t.sc, t.el, t.ec, trim(d[0], ' ', 2) .. t.inner .. trim(d[1], ' ', 1))
    else
        Replace(t.sl, t.sc, t.el, t.ec, d[0] .. (char =~ '^[([{<]$' ? trim(t.inner) : t.inner) .. d[1])
    endif
    cursor(t.sl, t.sc)
enddef

# Wrap the region {s}..{e}. {type} is 'char', 'line' or 'block' (operator
# types); {lines} puts the delimiters on lines of their own.
def Add(s: list<number>, e: list<number>, type: string, d: list<string>, lines: bool, trailing: bool)
    if type ==# 'block'
        const segs = getregionpos(s, e, {type: "\<C-V>", exclusive: false})
        for seg in reverse(copy(segs))
            const [lnum, sc, ec] = [seg[0][1], seg[0][2], seg[1][2]]
            if sc <= len(getline(lnum))
                Replace(lnum, sc, lnum, ec, d[0] .. strpart(getline(lnum), sc - 1, ec - sc + 1) .. d[1])
            endif
        endfor
        cursor(s[1], segs[-1][0][2])
        return
    endif

    if type ==# 'line'
        const [sl, el] = [s[1], e[1]]
        const indent = matchstr(getline(sl), '^\s*')
        const wrapped = WrapLines(join(getline(sl, el), "\n"), d, indent, lines)
        SetLines(sl, el, wrapped)
        Reindent(sl, sl + len(wrapped) - 1)
        cursor(sl, len(indent) + 1)
        return
    endif

    const pos = getregionpos(s, e, {type: 'v', exclusive: false})
    const [sl, sc, el, ec] = [s[1], pos[0][0][2], e[1], pos[-1][1][2]]
    var text = join(getregion(s, e, {type: 'v', exclusive: false}), "\n")
    # Motions such as `w` take the whitespace after a word; keep it outside.
    var tail = ''
    if trailing
        tail = matchstr(text, '\_s\@<!\s*$')
        text = strpart(text, 0, len(text) - len(tail))
    endif
    if lines
        const indent = matchstr(getline(sl), '^\s*')
        const wrapped = WrapLines(text, d, indent, true)
        Replace(sl, sc, el, ec, join(wrapped, "\n")[len(indent) :] .. tail)
        Reindent(sl, sl + len(wrapped) - 1)
    else
        Replace(sl, sc, el, ec, d[0] .. text .. d[1] .. tail)
    endif
    cursor(sl, sc)
enddef

export def Operator(type: string)
    const p = pending
    if empty(p)
        return
    endif
    if p.fresh
        if p.kind =~# '^[dc]'
            const [n, target] = ReadTarget()
            p.target = target
            if empty(p.target)
                pending = {}
                return
            endif
            p.count *= n
        endif
        if p.kind !=# 'ds'
            p.char = ReadChar()
            if empty(p.char)
                pending = {}
                return
            endif
        endif
        p.fresh = false
    endif

    if p.kind ==# 'ys' || p.kind ==# 'yS'
        const d = Delims(p.char, '', p.input)
        if !empty(d)
            Add(getpos("'["), getpos("']"), type, d, p.kind ==# 'yS', true)
        endif
        return
    endif

    const t = Find(p.target, p.count)
    if empty(t)
        return
    endif
    last_tag = t.open
    if p.kind ==# 'ds'
        Delete(t, p.target)
    else
        const d = Delims(p.char, t.open, p.input)
        if !empty(d)
            Change(t, p.target, d, p.kind ==# 'cS')
        endif
    endif
enddef

# Visual S / gS. {mode} is visualmode(); {lines} asks for the delimiters on
# lines of their own.
export def Visual(mode: string, lines: bool)
    const char = ReadChar()
    if empty(char)
        return
    endif
    pending = {kind: 'ys', fresh: false, count: 1, target: '', char: char, input: ''}
    const d = Delims(char, '', '')
    if empty(d)
        return
    endif
    const type = {v: 'char', V: 'line', "\<C-V>": 'block'}[mode]
    var e = getpos("'>")
    if mode ==# 'v' && &selection ==# 'exclusive' && e[2] > 1
        e[2] -= 1
    endif
    Add(getpos("'<"), e, type, d, lines, false)
enddef

# Insert-mode <C-G>s / <C-G>S: type both delimiters, cursor in between.
export def Insert(lines: bool): string
    const char = ReadChar()
    if empty(char)
        return ''
    endif
    pending = {}
    const d = Delims(char, '', '')
    if empty(d)
        return ''
    endif
    if lines
        return trim(d[0], ' ', 2) .. "\<CR>\<CR>" .. trim(d[1], ' ', 1) .. "\<Up>\<C-O>cc"
    endif
    return d[0] .. d[1] .. repeat("\<C-G>U\<Left>", strchars(d[1]))
enddef
