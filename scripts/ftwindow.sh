# ftwindow - switch window
windows=$(tmux list-windows -a -F '#S:#W')

target=$(echo "$windows" | fzf +m --reverse) || return

target_session=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}')

tmux switch -t $target_session
tmux select-window -t $target_window
