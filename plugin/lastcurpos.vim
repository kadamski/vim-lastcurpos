if !exists("g:lastcurpos_mark") 
    let g:lastcurpos_mark = "z"
endif

if !exists("g:lastcurpos_minupdatetime")
    let g:lastcurpos_minupdatetime = 1000
endif

if !exists("g:lastcurpos_ignoresignature")
    let g:lastcurpos_ignoresignature = 1
endif

" b:lastcurpos_lastpos - position of the cursor before change
" b:lastcurpos_saved   - position of the cursor now
function! lastcurpos#UpdateLastCurMark()
    if exists("b:lastcurpos_saved")
        if g:lastcurpos_mark != ""
            call setpos("'" . g:lastcurpos_mark, b:lastcurpos_saved)
        endif
        let b:lastcurpos_lastpos = b:lastcurpos_saved
    endif
    let b:lastcurpos_saved = getpos(".")
endfunction

function! lastcurpos#JumpToLast()
    if (exists("b:lastcurpos_lastpos"))
        call setpos(".", b:lastcurpos_lastpos)
    endif
endfunction

autocmd! CursorMoved
autocmd CursorMoved * :call lastcurpos#UpdateLastCurMark()
if &updatetime>g:lastcurpos_minupdatetime
    let &updatetime = g:lastcurpos_minupdatetime
endif

if (g:lastcurpos_mark != '' && g:lastcurpos_ignoresignature && exists("g:SignatureIncludeMarks"))
    let s:tmp = substitute(g:SignatureIncludeMarks, g:lastcurpos_mark, '', '')
    let g:SignatureIncludeMarks = s:tmp 
endif

nnoremap <silent>g. :call lastcurpos#JumpToLast()<cr>
