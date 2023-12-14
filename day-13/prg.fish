function reverse
	for line in $argv[-1..1]
		echo $line
	end
end

function transpose
	while test -n "$argv[1]"
		string match -r '^.' $argv | string join ''
		set argv (string replace -r '^.' '' $argv)
	end
end

function diffeq
	test $argv[1] = $argv[2]
end

function diffone
	string match -q -r \
	'^([^!]*)[.]([^!]*)[#]([^!]*)!\\1[#]\\2[.]\\3$' \
	"$argv[1]!$argv[2]" \
	|| string match -q -r \
	'^([^!]*)[#]([^!]*)[.]([^!]*)!\\1[.]\\2[#]\\3$' \
	"$argv[1]!$argv[2]"
end

function findMirror
	set cnt (count $argv)
	if test (math $cnt % 2) -eq 1
		set -e argv[1]
		set cnt (math $cnt + 1)
	end
	while test -n "$argv"
		if $diff (string join '@' $argv) (string join '@' $argv[-1..1])
			echo (math $cnt / 2)
			return
		else
			set -e argv[1 2]
			set cnt (math $cnt + 2)
		end
	end
	return 1
end

function processBlock
	set block $argv
	if set top (findMirror $block)
		echo (math $top \* 100)
		return
	end
	
	set rev (reverse $block)
	if set bottom (findMirror $rev)
		echo (math (math (count $rev) - $bottom) \* 100)
		return
	end
	
	set trans (transpose $block)
	if set left (findMirror $trans)
		echo $left
		return
	end

	set revtrans (reverse $trans)
	if set right (findMirror $revtrans)
		echo (math (count $revtrans) - $right)
		return
	end
end

function readFile
	set block
	set sum1 0
	set sum2 0
	while true
		if ! read -l line
			set -g diff diffeq
			set cnt1 (processBlock $block)
			set sum1 (math $sum1 + $cnt1)
			set -g diff diffone
			set cnt2 (processBlock $block)
			set sum2 (math $sum2 + $cnt2)
			break
		else if test -z "$line"
			set -g diff diffeq
			set cnt1 (processBlock $block)
			set sum1 (math $sum1 + $cnt1)
			set -g diff diffone
			set cnt2 (processBlock $block)
			set sum2 (math $sum2 + $cnt2)
			set block
		else
			set -a block $line
		end
	end < $argv[1]
	echo $sum1
	echo $sum2
end

readFile $argv[1]

