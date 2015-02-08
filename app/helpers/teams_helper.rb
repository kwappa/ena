module TeamsHelper
  def team_summary(team)
    /\A(?<first_line>.+)(\r?\n)/ =~ team.description
    truncate(first_line.to_s.strip, length: 32)
  end
end
