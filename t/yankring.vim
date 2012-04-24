call vspec#hint({'scope': 'yankring#scope()', 'sid': 'yankring#sid()'})

describe 'yankring'
  before
    let g:tmp = exists('g:YANKRING') ? g:YANKRING : []
    let g:YANKRING = []
  end

  after
    let g:YANKRING = g:tmp
    call Set('s:yankring', [])
  end

  it 'should keep a list unique'
    Expect Call('s:uniq', ['a', 'b', 'c', 'd', 'a']) ==  ['a', 'b', 'c', 'd']
    Expect Call('s:uniq', ['a', 'a']) ==  ['a']
    Expect Call('s:uniq', ['a', 'b']) ==  ['a', 'b']
  end

  it 'should store list globally'
    call Call('s:store', ['a', 'b', 'c'])
    Expect g:YANKRING == ['a', 'b', 'c']
  end

  it 'should collect words'
    call setreg('"', 'foo')
    call yankring#collect()
    Expect Ref('s:yankring') == ['foo']
    call setreg('"', 'bar')
    call yankring#collect()
    Expect Ref('s:yankring') == ['bar', 'foo']
    call setreg('"', 'baz')
    call yankring#collect()
    call setreg('"', 'bar')
    call yankring#collect()
    Expect Ref('s:yankring') == ['bar', 'baz', 'foo']
  end

  it 'should collect words in reversed order'
    let g:reversed = get(g:, 'ctrlp_match_window_reversed', 0)
    let g:ctrlp_match_window_reversed = 1
    call setreg('"', 'foo')
    call yankring#collect()
    Expect Ref('s:yankring') == ['foo']
    call setreg('"', 'bar')
    call yankring#collect()
    Expect Ref('s:yankring') == ['foo', 'bar']
    call setreg('"', 'baz')
    call yankring#collect()
    call setreg('"', 'bar')
    call yankring#collect()
    Expect Ref('s:yankring') == ['foo', 'baz', 'bar']
    let g:ctrlp_match_window_reversed = g:reversed
  end
end
