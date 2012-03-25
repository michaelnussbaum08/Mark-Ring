" Use <leader>m to cycle through your marks in alphabetic order, and use
" <leader>M to cycle through your marks in reverse alphabetic order.
"
" Bindings can be changed here:
nmap <silent> <leader>m :python next_mark(forward=True)<CR>
nmap <silent> <leader>M :python next_mark(forward=False)<CR>

python << EOF
import string
import vim

marks = string.lowercase + string.uppercase    # string of all alphabetic marks
next_index = -1     # next_index is index in marks to be tried next
# found_any is used to stop recursion after all marks are tried
found_any = False


def next_mark(forward=True, call_count=0):
    '''Moves cursor to the next mark and prints mark letter. Moves either
    alphabetically or reverse alphabetically through marks. Finds set marks by
    trying every possible mark (every letter) until one is found. If it cycles
    through all the marks without finding any set it informs the user and gives
    up.'''
    # advance_index increments next_index global variable
    if forward:
        advance_index(1)
    else:
        advance_index(-1)
    global found_any
    mark_loc = vim.current.buffer.mark(marks[next_index])
    if call_count == len(marks) and not found_any and not mark_loc:
        # Here we've cycled through all the letters and found none set, so quit
        print "No marks set"
        return

    if mark_loc is None:
        next_mark(forward=forward, call_count=call_count+1)
    else:
        found_any = True
        print "Mark:", marks[next_index]
        vim.current.window.cursor = mark_loc

def advance_index(step):
    '''Increments or decrements global next_index while keeping it between 0
    and the number of marks.'''
    global next_index
    if 0 <= next_index + step < len(marks):
        next_index += step
    elif next_index + step < 0:
        next_index = len(marks) - 1
    else:
        next_index = -1
EOF

