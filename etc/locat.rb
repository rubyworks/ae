
match 'lib/**.rb' do |file, line|
  case line
  when /^\s+#/
    'Comment'
  when /^\s*$/
    'Blank'
  else
    'Code'
  end
end

match 'test/**.rb' do |file, line|
  unless line.strip.empty?
    'Test'
  end
end

match 'qed/**.rdoc' do |file, line|
  unless line.strip.empty?
    'Test'
  end
end

match 'demo/**.rdoc' do |file, line|
  unless line.strip.empty?
    'Test'
  end
end

