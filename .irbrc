IRB.conf[:PROMPT][:PRETTY] = {
  :AUTO_INDENT => true,
  :PROMPT_I =>  "\033[0;31mruby \033[0m ",
  :PROMPT_S =>  "\033[0;31mruby \033[0m ",
  :PROMPT_C =>  "\033[0;31mruby \033[0m ",
  :RETURN => "==> %s\n"
}

IRB.conf[:PROMPT_MODE] = :PRETTY

puts RUBY_DESCRIPTION
