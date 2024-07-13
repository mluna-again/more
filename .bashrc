alias v=nvim
alias dots=yadm
alias dotss="yadm status"
alias dotsa="yadm add -u"
alias dotsC="yadm checkout"
alias dotsR="yadm reset --hard"
alias dotsd="yadm diff"
alias dotsdd="yadm diff --cached"
alias dotsl="yadm log"
dotsc() {
  yadm commit -m "$@"
}

export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
