namespace :ena do
  desc 'specify admin by nick'
  task :specify_admin, [:nick] => :environment do |task, args|
    puts args.nick

    if args.nick.blank?
      puts "usage: rake ena:speicyf_admin NICK"
      next
    end

    user = User.find_by(nick: args.nick)
    fail "user '#{args.nick}' does not found." unless user.present?

    puts "specify user '#{user.nick}(#{user.name})' as administrator.\nare you sure? [y/N]"
    answer = STDIN.gets.chomp
    unless answer =~ /\A(y|Y)\Z/
      puts "aborted."
      next
    end

    if user.authorize(:administration)
      puts "user '#{user.nick}(#{user.name})' is specified as administrator."
    else
      fail 'update failed.'
    end
  end
end
