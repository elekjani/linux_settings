command! -n=0 -bar ARKWin :call s:toggleArk()
command! -n=? -bar ARKStartApp :call s:startApp(<args>)
command! -n=0 -bar ARKWinUpdate :call s:initArkApps()
command! -n=? -bar ARKShowOutput :call s:showOutput(<args>)
command! -n=? -bar ARKStopApp :call s:stopApp(<args>)
command! -n=? -bar ARKShowDetail :call s:showDetails(<args>)

let s:next_buffer_number = 0
let s:ArkAppStatus = {}
let s:Outputs = {'stdout': [], 'stderr': []}
let s:Details = ''

function! s:showDetails(...)
    if a:0 > 0
        let b:appName = a:1
    else
        let l:pos = getpos('.')
        if l:pos[1] > 1
            let l:line = getline('.')
            if getline('1') != 'Stdout:'
                let b:appName = split(l:line)[0]
            endif
        endif
    endif

    python showDetails(vim.eval('b:appName'))

    let l:lines = []
    for l:line in split(s:Details, '\n')
        call add(l:lines, l:line)
    endfor

    setlocal modifiable
    silent! exec 'normal! ggdG'
    call setline('.', l:lines)
    setlocal nomodifiable
endfunction

function! s:showOutput(...)
    if a:0 > 0
        let b:appName = a:1
    else
        let l:pos = getpos('.')
        if l:pos[1] > 1
            let l:line = getline('.')
            if getline('1') != 'Stdout:'
                let b:appName = split(l:line)[0]
            endif
        endif
    endif

    python updateOutput(vim.eval('b:appName'))

    let l:lines = ['Stdout:']
    for l:line in s:Outputs.stdout
        call add(l:lines, l:line)
    endfor
    call add(l:lines, repeat('-',20))

    call add(l:lines, 'Stderr')
    for l:line in s:Outputs.stderr
        call add(l:lines, l:line)
    endfor
    call add(l:lines, repeat('-',20))

    setlocal modifiable
    silent! exec 'normal! ggdG'
    call setline('.', l:lines)
    setlocal nomodifiable
endfunction

function! s:stopApp(...)
    if a:0 > 0
        python stopApp(vim.eval('a:1'))
    else
        let l:pos = getpos('.')
        if l:pos[1] > 1
            let l:line = getline('.')
            let l:appName = split(l:line)[0]
            python stopApp(vim.eval('l:appName'))
        endif
    endif
endfunction


function! s:startApp(...)
    if a:0 > 0
        python startApp(vim.eval('a:1'))
    else
        let l:pos = getpos('.')
        if l:pos[1] > 1
            let l:line = getline('.')
            let l:appName = split(l:line)[0]
            python startApp(vim.eval('l:appName'))
        endif
    endif
endfunction

function! s:initArkApps()
    python updateStatus()
    let l:maxNameLen = max(map(copy(keys(s:ArkAppStatus)), 'len(v:val)'))
    let l:maxStatusLen = max(map(copy(values(s:ArkAppStatus)), 'len(v:val.status)'))
    let l:maxAppIdLen = max(map(copy(values(s:ArkAppStatus)), 'len(v:val.appId)'))

    let l:headerName = 'Name'
    let l:headerStatus = 'Status'
    let l:headerAppId = 'AppId'

    let l:maxNameLen = max([l:headerName, l:maxNameLen])
    let l:maxStatusLen = max([l:headerStatus, l:maxStatusLen])
    let l:maxAppIdLen = max([l:headerAppId, l:maxAppIdLen])

    let l:line = s:createCell(l:headerName, l:maxNameLen)
    let l:line .= s:createCell(l:headerStatus, l:maxStatusLen)
    let l:line .= s:createCell(l:headerAppId, l:maxAppIdLen)

    let l:lines = [l:line]

    for [l:appName, l:status] in sort(items(s:ArkAppStatus))
        let l:line = s:createCell(l:appName, l:maxNameLen)
        let l:line .= s:createCell(l:status.status, l:maxStatusLen)
        let l:line .= s:createCell(l:status.appId, l:maxAppIdLen)
        call add(l:lines, l:line)
    endfor

    setlocal modifiable
    let l:cursor = getpos('.')
    silent! exec 'normal! ggdG'
    call setline('.', l:lines)
    call cursor(l:cursor[1], 0)
    setlocal nomodifiable
endfunction

function! s:createCell(text, maxLen)
    return a:text . repeat(' ', a:maxLen - len(a:text) + 1)
endfunction

function! s:initArk()
    if !exists('t:ArkBufferName')
        let t:ArkBufferName = 'ARK ' . s:next_buffer_number
        let s:next_buffer_number += 1
        
        silent! exec 'botright 15 new'
        silent! exec 'edit ' . t:ArkBufferName
    else
        silent! exec 'botright 15 split'
        silent! exec 'buffer ' . t:ArkBufferName
    endif

    setlocal winfixwidth
    call s:setCommonBufOptions()
    call s:setMappings()
    call s:initArkApps()
endfunction

function! s:setMappings()
    nmap <buffer> <CR> :ARKStartApp<CR>
    nmap <buffer> r :ARKWinUpdate<CR>
    nmap <buffer> o :ARKShowOutput<CR>
    nmap <buffer> s :ARKStopApp<CR>
    nmap <buffer> d :ARKShowDetail<CR>
endfunction

function! s:setCommonBufOptions()
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nowrap
    setlocal foldcolumn=0
    setlocal nobuflisted
    setlocal nospell
    setlocal nomodifiable

    setfiletype ark
    syn keyword myOK RUNNING
    syn keyword myERROR FAILED KILLED
    syn keyword myUNKNOWN UNKNOWN
    syn keyword myFINISHED FINISHED
    hi kwGreen term=standout ctermfg=22 guifg=Green
    hi kwRed term=standout ctermfg=88 guifg=DarkRed
    hi kwBlue term=standout ctermfg=18 guifg=DarkBlue
    hi def link myOK kwGreen
    hi def link myERROR kwRed
    hi def link myFINISHED kwBlue

endfunction

function! s:toggleArk()
    if exists('t:ArkBufferName')
        if s:getArkWinNum() == -1
            call s:initArk()
        else
            call s:closeArk()
        endif
    else
        call s:initArk()
    endif
endfunction

function! s:closeArk()
    if s:getArkWinNum() != -1
        if winnr('$') != 1
            if winnr() == s:getArkWinNum()
                wincmd p
                let bufnr = bufnr('')
                wincmd p
            else
                let bufnr = bufnr('')
            endif

            call s:exec(s:getArkWinNum() . ' wincmd w')
            close
            call s:exec(bufwinnr(bufnr) . ' wincmd w')
        else
            close
        endif
    endif
endfunction

function! s:getArkWinNum()
    if exists('t:ArkBufferName')
        return bufwinnr(t:ArkBufferName)
    else
        return -1
    endif
endfunction

function! s:exec(cmd)
    let old_ei = &ei
    set ei=all
    exec a:cmd
    let &ei = old_ei
endfunction

python << EOF
import json
import vim
import httplib


def getCall(path, query=None, server=None):
    fullpath = (path + '?' + query) if query is not None else path
    if server is None:
        conn = httplib.HTTPConnection("localhost:8888")
    else:
        conn = httplib.HTTPConnection(server)
    conn.request("GET", fullpath)
    return conn.getresponse()


def let(var, val, quote=True):
    if quote:
        vim.command('let ' + var + ' = "' + val + '"')
    else:
        vim.command('let ' + var + ' = ' + val)


def updateStatus():
    update_resp = getCall('/update')
    if update_resp.status == 200:
        r_dict = json.loads(update_resp.read())
        let('s:ArkAppStatus', '{}', quote=False)
        for k,v in r_dict['apps'].items():
            app_dict = 's:ArkAppStatus.' + k
            let(app_dict, '{}', quote=False)

            status = v.get('status') if v.get('status') else 'UNKNOWN'
            appId = v.get('appId') if v.get('appId') else 'None'
            let(app_dict + '.status', status)
            let(app_dict + '.appId', appId)
    else:
        print update_resp.status, update_resp.reason


def startApp(appName):
    start_resp = getCall('/start', 'app=' + appName)
    if start_resp.status == 200:
        print start_resp.read()
    else:
        print start_resp.status, start_resp.reason


def stopApp(appName):
    stop_resp = getCall('/stop', 'app=' + appName)
    if stop_resp.status == 200:
        print stop_resp.read()
    else:
        print stop_resp.status, stop_resp.reason


def showDetails(appName):
    details_resp = getCall('/details', 'app=' + appName)
    if details_resp.status != 200:
        print 'Unable to get details from ARK: ', details_resp.status, details_resp.reason
    else:
        details = json.loads(details_resp.read())
        details_pretty = json.dumps(details, sort_keys=True, indent=4, separators=(',',': '))
        details_pretty = details_pretty.replace('"', '\\"',)
        vim.command('let s:Details = "' + details_pretty + '"')

def updateOutput(appName):
    details_resp = getCall('/details', 'app=' + appName)
    if details_resp.status != 200:
        print 'Unable to get details from ARK: ', details_resp.status, details_resp.reason
    else:
        details = json.loads(details_resp.read())
        container, host = sorted(details['containers'].items(), reverse=True)[0]
        host = host.split('.')[0]

        stdout_resp = getCall('/stdout/' + host, 'container=' + container, server='sekalvdr134.epk.ericsson.se:5000')
        if stdout_resp.status != 200:
            print 'Unable to get stdout from LVDR: ', stdout_resp.status, stdout_resp.reason
        stdout = stdout_resp.read() if stdout_resp.status == 200 else None

        stderr_resp = getCall('/stderr/' + host, 'container=' + container, server='sekalvdr134.epk.ericsson.se:5000')
        if stderr_resp.status != 200:
            print 'Unable to get stderr from LVDR: ', stderr_resp.status, stderr_resp.reason
        stderr = stderr_resp.read() if stderr_resp.status == 200 else None

        vim.command('let s:Outputs.stdout = []')
        vim.command('let s:Outputs.stderr = []')
        if stdout is not None:
            stdout = stdout.split('\n')
            if len(stdout) > 100:
                stdout = stdout[-100:]
            for l in stdout:
                escaped_line = l.replace('"', '\\"',)
                vim.command('call add(s:Outputs.stdout, "' + escaped_line + '")')

        if stderr is not None:
            stderr = stderr.split('\n')
            if len(stderr) > 100:
                stderr = stderr[-100:]
            for l in stderr:
                escaped_line = l.replace('"', '\\"',)
                vim.command('call add(s:Outputs.stderr, "' + escaped_line + '")')


EOF

