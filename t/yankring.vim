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

  it 'should represent plugin cache dir'
    Expect expand(Call('s:cachedir')) == expand('~/.cache/ctrlp/yankring')
  end

  it 'should remove old duplicated'
    let g:val = [1, 2, 3 ,4, 5]
    call Call('s:remove_duplicated', g:val, 2)
    call Call('s:remove_duplicated', g:val, 4)
    Expect g:val == [1, 3, 5]
  end

  it 'should add entry'
    let g:val = [1, 2, 3]
    call Call('s:add', g:val, 0, 0)
    Expect g:val == [0, 1, 2, 3]
    call Call('s:add', g:val, 4, 1)
    Expect g:val == [0, 1, 2, 3, 4]
end
